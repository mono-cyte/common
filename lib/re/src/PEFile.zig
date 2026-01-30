const Self = @This();
const PEManager = @import("PEManager.zig");

const std = @import("std");
const pe = @import("pe.zig");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Io = std.Io;
const File = Io.File;

const assert = std.debug.assert;

file: File,
raw: PEManager,
img: PEManager,
pe_addr: PEAddress,

const PEAddress = struct {
    addrs: ArrayList(Data),
    const Data = struct {
        raw_address: u32,
        raw_size: u32,
        img_address: u32,
        img_size: u32,
    };
    pub fn init(allocator: Allocator, raw: PEManager) !PEAddress {
        var addrs = try ArrayList(Data).initCapacity(allocator, 4);
        try addrs.append(allocator, .{
            .raw_address = 0,
            .raw_size = raw.hdr_size,
            .img_address = 0,
            .img_size = raw.hdr_size,
        });

        const sec_hdrs = raw.ptrs.opt_hdr.getSectionHeaders(raw.ptrs.file_hdr);
        for (sec_hdrs) |sec_hdr| {
            try addrs.append(allocator, .{
                .raw_address = sec_hdr.pointer_to_raw_data,
                .raw_size = sec_hdr.size_of_raw_data,
                .img_address = sec_hdr.virtual_address,
                .img_size = sec_hdr.virtual_size,
            });
        }
        return .{
            .addrs = addrs,
        };
    }
    pub fn rva2foa(self: PEAddress, rva: u32) !u32 {
        for (self.addrs.items) |da| {
            if (rva >= da.img_address and rva < da.img_address + da.img_size) {
                const rrva = rva - da.img_address;
                const foa = da.raw_address + rrva;
                if (foa < da.raw_address + da.raw_size) {
                    return foa;
                } else {
                    return error.InvalidFileOffset;
                }
            }
        }
        return error.InvalidVirtualAddress;
    }
    pub fn foa2rva(self: PEAddress, foa: u32) !u32 {
        for (self.addrs.items) |da| {
            if (foa >= da.raw_address and foa < da.raw_address + da.raw_size) {
                const rrva = foa - da.raw_address;
                const rva = da.img_address + rrva;
                return rva;
            }
        }
        return error.InvalidFileOffset;
    }
};

pub fn initFromFile(allocator: Allocator, io: Io, file: File) !Self {
    const raw = try PEManager.fileToRaw(allocator, io, file);
    const img = try PEManager.rawToImg(allocator, raw);
    const pe_addr = try PEAddress.init(allocator, img);
    return .{
        .file = file,
        .raw = raw,
        .img = img,
        .pe_addr = pe_addr,
    };
}

pub fn formatImport(self: *const Self) !void {
    var dd = self.raw.ptrs.opt_hdr.getDataDirectories();
    if (dd.IMPORT.virtual_address == 0) {
        return error.InvalidDataDirectory;
    }
    const base = self.img.ptrs.base;
    const imp = @as(*const pe.DataDirectories.ImportDesc, @ptrCast(@alignCast(base + dd.IMPORT.virtual_address))).sliceToTerminal();
    // const dll_name: [*:0]const u8 = @ptrCast(@alignCast(self.img.ptrs.base + imp.module_name));
    for (imp) |desc| {
        const INT = @as(*const pe.ThunkData(64), @ptrCast((@alignCast(base + desc.name_table)))).sliceToTerminal();
        const IAT = @as(*const pe.ThunkData(64), @ptrCast(@alignCast(base + desc.address_table))).sliceToTerminal();
        std.debug.print("\nmodule: {s}\n", .{@as([*:0]const u8, @ptrCast(base + desc.module_name))});
        assert(INT.len == IAT.len);
        for (INT, 0..) |n, i| {
            if (n.is_ordinal) {
                std.debug.print("ordinal: {x:0>8}\n", .{n.data});
            } else {
                const ibn: *const pe.ImportByName = @ptrCast(@alignCast(base + n.data));
                const str = ibn.getName();
                std.debug.print("name: {s}\n", .{str});
            }
            if (desc.isBound()) {
                std.debug.print("&address: {}", .{&IAT[i]});
                std.debug.print("address: 0x{X}", .{@as(usize, @bitCast(IAT[i]))});
            }
        }
    }
}

pub fn formatReloc(self: *const Self, allocator: Allocator) !void {
    var dd = self.raw.ptrs.opt_hdr.getDataDirectories();
    if (dd.BASE_RELOC.virtual_address == 0) {
        return error.InvalidDataDirectory;
    }
    const reloc: *const pe.DataDirectories.BaseRelocation = @ptrCast(@alignCast(self.img.ptrs.base + dd.BASE_RELOC.virtual_address));
    const reloc_list = try reloc.sliceToTerminal(allocator);
    for (reloc_list) |r| {
        std.debug.print("rva: {x:0>8} block_size: {x:0>8}\n", .{ r.page_rva, r.block_size });
        for (r.sliceEntries()) |e| {
            std.debug.print("rva: {any} type: {x:0>8}\n", .{ e.type, e.offset });
        }
    }
}

pub fn formatExport(self: *const Self) !void {
    var dd = self.raw.ptrs.opt_hdr.getDataDirectories();

    if (dd.EXPORT.virtual_address == 0) {
        return error.InvalidDataDirectory;
    }

    const ex: *const pe.DataDirectories.Export = @ptrCast(@alignCast(self.img.ptrs.base + dd.EXPORT.virtual_address));
    const func_rva_list: []const u32 = @as([*]const u32, @ptrCast(@alignCast(self.img.ptrs.base + ex.address_of_functions)))[0..ex.number_of_functions];
    const name_rva_list: []const u32 = @as([*]const u32, @ptrCast(@alignCast(self.img.ptrs.base + ex.address_of_names)))[0..ex.number_of_names];
    const name_ordinal_list: []const u16 = @as([*]const u16, @ptrCast(@alignCast(self.img.ptrs.base + ex.address_of_name_ordinals)))[0..ex.number_of_names];

    for (0..ex.number_of_functions) |i| {
        const func_rva = func_rva_list[i];
        std.debug.print("function rva: {x:0>8} ", .{func_rva});
        for (0..ex.number_of_names) |j| {
            if (name_ordinal_list[j] == i) {
                const name_rva = name_rva_list[j];
                const name: [*:0]const u8 = @ptrCast(@alignCast(self.img.ptrs.base + name_rva));
                std.debug.print("name: {s}", .{name});
                break;
            }
        }
        std.debug.print("\n", .{});
    }
}
