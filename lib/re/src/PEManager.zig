const Self = @This();
const std = @import("std");
const assert = std.debug.assert;

const pe = @import("pe.zig");
const Allocator = std.mem.Allocator;
const Io = std.Io;
const File = Io.File;
const Dir = Io.Dir;

buf: []u8,
hdr_size: u32,
size: usize,
ptrs: Ptrs,
pub const Ptrs = struct {
    base: [*]const u8,
    dos_hdr: *const pe.DosHeader,
    nt_hdrs: *const pe.NTHeaders,
    file_hdr: *const pe.FileHeader,
    opt_hdr: *const pe.OptionalHeader,
    data_dirs: *const pe.DataDirectories,
    section_hdrs: [*]const pe.SectionHeader,

    pub fn initFromBuffer(buffer: []const u8) !Ptrs {
        const base: [*]u8 = @ptrCast(@alignCast(@constCast(buffer.ptr)));
        return try initFromBase(base);
    }

    pub fn initFromBase(base: [*]const u8) !Ptrs {
        const dos_hdr: *const pe.DosHeader = @ptrCast(@alignCast(base));
        // 校验 DOS 签名
        if (dos_hdr.e_magic != pe.IMAGE_DOS_SIGNATURE) return error.InvalidDosSignature;
        const nt_hdr: *const pe.NTHeaders = @ptrCast(@alignCast(base + dos_hdr.e_lfanew));
        // 校验 NT 签名
        if (nt_hdr.signature != pe.IMAGE_NT_SIGNATURE) return error.InvalidNtSignature;
        const file_hdr = &nt_hdr.file_header;
        const opt_hdr = &nt_hdr.optional_header;
        const data_dirs = o: switch (opt_hdr.magic) {
            .PE32 => {
                const ex: *const pe.OptionalHeader.PE32 = @ptrCast(@alignCast(opt_hdr));
                break :o &ex.data_directories;
            },
            .@"PE32+" => {
                const ex: *const pe.OptionalHeader.@"PE32+" = @ptrCast(@alignCast(opt_hdr));
                break :o &ex.data_directories;
            },
            _ => {
                return error.InvalidOptHeaderMagic;
            },
        };
        const opt_ptr: [*]const u8 = @ptrCast(opt_hdr);
        const section_hdrs: [*]const pe.SectionHeader = @ptrCast(@alignCast(opt_ptr + file_hdr.size_of_optional_header));
        return .{
            .base = base,
            .dos_hdr = dos_hdr,
            .nt_hdrs = nt_hdr,
            .file_hdr = file_hdr,
            .opt_hdr = opt_hdr,
            .data_dirs = data_dirs,
            .section_hdrs = section_hdrs,
        };
    }

    /// 获取导入函数地址的指针:
    /// 确保知道目标函数类型 F
    pub fn getImportAddressPtr(ptrs: Ptrs, module: []const u8, func: []const u8, bitness: comptime_int, F: type) !*const ?*const F {
        const base = ptrs.base;
        const dd = ptrs.data_dirs;
        const imp = @as(*const pe.DataDirectories.ImportDesc, @ptrCast(@alignCast(base + dd.IMPORT.virtual_address))).sliceToTerminal();
        for (imp) |desc| {
            const module_name = std.mem.sliceTo(@as([*]const u8, base + desc.module_name), 0);
            if (!std.ascii.eqlIgnoreCase(module_name, module)) continue; // 模块名: 大小写无关

            const INT = @as(*const pe.ThunkData(bitness), @ptrCast(@alignCast(base + desc.name_table))).sliceToTerminal();
            const IAT = @as(*const pe.ThunkData(bitness), @ptrCast(@alignCast(base + desc.address_table))).sliceToTerminal();
            assert(INT.len == IAT.len);

            for (INT, 0..) |n, i| {
                if (n.is_ordinal) continue;
                const ibn: *const pe.ImportByName = @ptrCast(@alignCast(base + n.data));
                if (std.mem.eql(u8, ibn.getName(), func)) {
                    return @ptrCast(&IAT[i]);
                }
            }
            return error.SymbolNotFound;
        }
        return error.ModuleNotFound;
    }
};

/// 获取PE文件态buffer
pub fn fileToRaw(allocator: Allocator, io: Io, file: File) !Self {
    const status = try file.stat(io);
    const size_of_file = status.size;

    var buf: [1024]u8 = undefined;
    var reader = file.reader(io, &buf);
    // 分配空间: 原始PE文件
    const raw = try reader.interface.readAlloc(allocator, size_of_file);
    const ptrs = try Ptrs.initFromBuffer(raw);
    const size_of_headers: u32 = ptrs.opt_hdr.getSizeOfHeaders();
    return .{
        .buf = raw,
        .size = status.size,
        .hdr_size = size_of_headers,
        .ptrs = ptrs,
    };
}

/// 将PE从文件态展开为运行态
pub fn rawToImg(allocator: Allocator, raw: Self) !Self {
    const size_of_img: u32 = raw.ptrs.opt_hdr.getSizeOfImage();
    const size_of_headers: u32 = raw.ptrs.opt_hdr.getSizeOfHeaders();

    var img = try allocator.alloc(u8, size_of_img);
    // 复制 Headers
    @memcpy(img[0..size_of_headers], raw.buf[0..size_of_headers]);
    // 复制节区(展开)
    for (raw.ptrs.section_hdrs[0..raw.ptrs.file_hdr.number_of_sections]) |sec| {
        @memcpy(img[sec.virtual_address .. sec.virtual_address + sec.size_of_raw_data], raw.buf[sec.pointer_to_raw_data .. sec.pointer_to_raw_data + sec.size_of_raw_data]);
    }
    return .{
        .buf = img,
        .size = size_of_img,
        .hdr_size = size_of_headers,
        .ptrs = try Ptrs.initFromBuffer(img),
    };
}

/// 将PE从运行态压缩为文件态
pub fn imgToRaw(allocator: Allocator, img: Self) !Self {
    // 以最后节区的末尾作为文件大小
    const last_sec = img.ptrs.section_hdrs[img.ptrs.file_hdr.number_of_sections - 1];
    const size_of_raw = last_sec.pointer_to_raw_data + last_sec.size_of_raw_data;
    const size_of_headers: u32 = img.ptrs.opt_hdr.getSizeOfHeaders();

    var raw = try allocator.alloc(u8, size_of_raw);
    @memcpy(raw[0..size_of_headers], img.buf[0..size_of_headers]);
    for (img.ptrs.section_hdrs[0..img.ptrs.file_hdr.number_of_sections]) |sec| {
        @memcpy(raw[sec.pointer_to_raw_data .. sec.pointer_to_raw_data + sec.size_of_raw_data], img.buf[sec.virtual_address .. sec.virtual_address + sec.size_of_raw_data]);
    }
    return .{
        .buf = raw,
        .size = size_of_raw,
        .hdr_size = size_of_headers,
        .ptrs = try Ptrs.initFromBuffer(raw),
    };
}

/// 将PE文件态写入文件
pub fn rawToFile(io: Io, raw: Self, file: File) !void {
    var buf: [1024]u8 = undefined;
    var writer = file.writer(io, &buf);
    try writer.interface.writeAll(raw.buf[0..]);
}
