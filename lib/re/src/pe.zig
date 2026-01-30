const std = @import("std");
const coff = std.coff;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const MACHINE = coff.IMAGE.FILE.MACHINE;
const REL = coff.IMAGE.REL;
const DIRECTORY_ENTRY = coff.IMAGE.DIRECTORY_ENTRY;
const DllFlags = coff.DllFlags;
const Magic = coff.OptionalHeader.Magic;
const Subsystem = coff.Subsystem;
const ImageDataDirectory = coff.ImageDataDirectory;
const IMAGE_NUMBEROF_DIRECTORY_ENTRIES = DIRECTORY_ENTRY.len;
const Flags = coff.Header.Flags;
const BaseRelocationEntry = coff.BaseRelocation;
const BaseRelocationType = coff.BaseRelocationType;

pub const IMAGE_DOS_SIGNATURE = 0x5A4D; // MZ
pub const IMAGE_NT_SIGNATURE = 0x00004550; // PE00

pub const DosHeader = extern struct {
    e_magic: u16, // Magic number: Mark Zbikowski(MZ)
    e_cblp: u16, // Bytes on last page of file
    e_cp: u16, // Pages in file
    e_crlc: u16, // Relocations
    e_cparhdr: u16, // Size of header in paragraphs
    e_minalloc: u16, // Minimum extra paragraphs needed
    e_maxalloc: u16, // Maximum extra paragraphs needed
    e_ss: u16, // Initial (relative) SS value
    e_sp: u16, // Initial SP value
    e_csum: u16, // Checksum
    e_ip: u16, // Initial IP value
    e_cs: u16, // Initial (relative) CS value
    e_lfarlc: u16, // File address of relocation table
    e_ovno: u16, // Overlay number
    e_res: [4]u16, // Reserved words
    e_oemid: u16, // OEM identifier (for e_oeminfo)
    e_oeminfo: u16, // OEM information; e_oemid specific
    e_res2: [10]u16, // Reserved words
    e_lfanew: u32, // File address of new exe header

};

pub const NTHeaders = extern struct {
    signature: u32,
    file_header: FileHeader,
    optional_header: OptionalHeader,
};

pub const FileHeader = coff.Header;

pub const IMAGE_SIZEOF_FILE_HEADER = @sizeOf(FileHeader);

pub const DataDirectories = extern struct {
    EXPORT: ImageDataDirectory,
    IMPORT: ImageDataDirectory,
    RESOURCE: ImageDataDirectory,
    EXCEPTION: ImageDataDirectory,
    SECURITY: ImageDataDirectory,
    BASE_RELOC: ImageDataDirectory,
    DEBUG: ImageDataDirectory,
    COPYRIGHT: ImageDataDirectory,
    GLOBAL_PTR: ImageDataDirectory,
    TLS: ImageDataDirectory,
    LOAD_CONFIG: ImageDataDirectory,
    BOUND_IMPORT: ImageDataDirectory,
    IAT: ImageDataDirectory,
    DELAY_IMPORT: ImageDataDirectory,
    COM_DESCRIPTOR: ImageDataDirectory,
    RESERVED: ImageDataDirectory,

    pub const Export = extern struct {
        characteristics: u32,
        time_date_stamp: u32,
        major_version: u16,
        minor_version: u16,
        name: u32,
        base: u32,
        number_of_functions: u32,
        number_of_names: u32,
        address_of_functions: u32, // RVA from base of image
        address_of_names: u32, // RVA from base of image
        address_of_name_ordinals: u32, // RVA from base of image
    };

    pub const ImportDesc = extern struct {
        name_table: u32,
        time_date_stamp: u32,
        forwarder_chain: u32,
        module_name: u32,
        address_table: u32,
        pub fn isBound(self: *const ImportDesc) bool {
            return self.time_date_stamp != 0;
        }

        fn isTerminal(self: *const ImportDesc) bool {
            return self.name_table == 0 and self.time_date_stamp == 0 and self.forwarder_chain == 0 and self.module_name == 0 and self.address_table == 0;
        }

        pub fn lenSliceToTerminal(self: *const ImportDesc) usize {
            var start: [*]const ImportDesc = @ptrCast(self);
            var len: usize = 0;
            while (!start[len].isTerminal()) {
                len += 1;
            }
            return len;
        }
        pub fn sliceToTerminal(self: *const ImportDesc) []const ImportDesc {
            const start: [*]const ImportDesc = @ptrCast(self);
            const len = self.lenSliceToTerminal();
            return start[0..len];
        }
    };

    pub const BaseRelocation = extern struct {
        page_rva: u32,
        block_size: u32,
        type_offset: [0]BaseRelocationEntry,

        pub fn lenSliceEntries(self: *const BaseRelocation) usize {
            return (self.block_size - @sizeOf(BaseRelocation)) / @sizeOf(BaseRelocationEntry);
        }

        pub fn sliceEntries(self: *const BaseRelocation) []const BaseRelocationEntry {
            const start: [*]const BaseRelocationEntry = @ptrCast(&self.type_offset);
            const num = self.lenSliceEntries();
            return start[0..num];
        }

        fn isTerminal(self: *const BaseRelocation) bool {
            return self.page_rva == 0 and self.block_size == 0;
        }

        pub fn lenSliceToTerminal(self: *const BaseRelocation) usize {
            var start: [*]const u8 = @ptrCast(self);
            var reloc: *const BaseRelocation = @ptrCast(@alignCast(start));
            var i: usize = 0;
            while (!reloc.isTerminal()) {
                i += 1;
                start += reloc.block_size;
                reloc = @ptrCast(@alignCast(start));
            }
            return i;
        }

        pub fn sliceToTerminal(self: *const BaseRelocation, allocator: Allocator) ![]*const BaseRelocation {
            var start: [*]const u8 = @ptrCast(self);
            var reloc: *const BaseRelocation = @ptrCast(@alignCast(start));
            var list = try ArrayList(*const BaseRelocation).initCapacity(allocator, 0);
            var i: usize = 0;
            while (!reloc.isTerminal()) {
                start += reloc.block_size;
                try list.append(allocator, reloc);
                reloc = @ptrCast(@alignCast(start));
                i += 1;
            }
            return list.items;
        }
    };

    const Self = @This();

    pub fn asList(self: *const Self) *const [IMAGE_NUMBEROF_DIRECTORY_ENTRIES]ImageDataDirectory {
        return @ptrCast(self);
    }

    comptime {
        if (IMAGE_NUMBEROF_DIRECTORY_ENTRIES != @typeInfo(DataDirectories).@"struct".fields.len) {
            @compileError("PE Data Directories mismatch with count");
        }
    }
};

pub fn ThunkData(bits: comptime_int) type {
    const T = switch (bits) {
        32 => u31,
        64 => u63,
        else => @compileError("Unsupported architecture"),
    };

    return packed struct {
        data: T,
        is_ordinal: bool,

        const Self = @This();

        fn isTerminal(self: *const Self) bool {
            return self.data == 0 and !self.is_ordinal;
        }
        pub fn lenSliceToTerminal(self: *const Self) usize {
            const start: [*]const Self = @ptrCast(self);
            var i: usize = 0;
            while (!start[i].isTerminal()) i += 1;
            return i;
        }
        pub fn sliceToTerminal(self: *const Self) []const Self {
            const start: [*]const Self = @ptrCast(self);
            const num: usize = self.lenSliceToTerminal();
            return start[0..num];
        }
    };
}

pub const ImportByName = struct {
    hint: u16,
    name: [0]u8,
    const Self = @This();
    pub fn getName(self: *const Self) [:0]const u8 {
        const p: [*:0]const u8 = @ptrCast(&self.name);
        return std.mem.sliceTo(p, 0);
    }
};

pub const OptionalHeader = extern struct {
    magic: Magic,
    major_linker_version: u8,
    minor_linker_version: u8,
    size_of_code: u32,
    size_of_initialized_data: u32,
    size_of_uninitialized_data: u32,
    address_of_entry_point: u32,
    base_of_code: u32,

    pub const PE32 = extern struct {
        standard: OptionalHeader,
        base_of_data: u32,
        image_base: u32,
        section_alignment: u32,
        file_alignment: u32,
        major_operating_system_version: u16,
        minor_operating_system_version: u16,
        major_image_version: u16,
        minor_image_version: u16,
        major_subsystem_version: u16,
        minor_subsystem_version: u16,
        win32_version_value: u32,
        size_of_image: u32,
        size_of_headers: u32,
        checksum: u32,
        subsystem: Subsystem,
        dll_flags: DllFlags,
        size_of_stack_reserve: u32,
        size_of_stack_commit: u32,
        size_of_heap_reserve: u32,
        size_of_heap_commit: u32,
        loader_flags: u32,
        number_of_rva_and_sizes: u32,
        data_directories: DataDirectories,
        section_headers: [0]SectionHeader,
    };

    pub const @"PE32+" = extern struct {
        standard: OptionalHeader,
        image_base: u64,
        section_alignment: u32,
        file_alignment: u32,
        major_operating_system_version: u16,
        minor_operating_system_version: u16,
        major_image_version: u16,
        minor_image_version: u16,
        major_subsystem_version: u16,
        minor_subsystem_version: u16,
        win32_version_value: u32,
        size_of_image: u32,
        size_of_headers: u32,
        check_sum: u32,
        subsystem: Subsystem,
        dll_flags: DllFlags,
        size_of_stack_reserve: u64,
        size_of_stack_commit: u64,
        size_of_heap_reserve: u64,
        size_of_heap_commit: u64,
        loader_flags: u32,
        number_of_rva_and_sizes: u32,
        data_directories: DataDirectories,
        section_headers: [0]SectionHeader,
    };

    fn fieldPtr(self: *const OptionalHeader, comptime field_name: []const u8, comptime T: type) *const T {
        return switch (self.magic) {
            .PE32 => @ptrCast(&@field(@as(*const PE32, @ptrCast(@alignCast(self))), field_name)),
            .@"PE32+" => @ptrCast(&@field(@as(*const @"PE32+", @ptrCast(@alignCast(self))), field_name)),
            else => unreachable,
        };
    }

    fn fieldVal(self: *const OptionalHeader, comptime field_name: []const u8, comptime T: type) T {
        return switch (self.magic) {
            .PE32 => @as(T, @field(@as(*const PE32, @ptrCast(@alignCast(self))), field_name)),
            .@"PE32+" => @as(T, @field(@as(*const @"PE32+", @ptrCast(@alignCast(self))), field_name)),
            else => unreachable,
        };
    }

    // 简化的访问器
    pub fn getSizeOfImage(self: *const OptionalHeader) u32 {
        return self.fieldVal("size_of_image", u32);
    }

    pub fn getSizeOfHeaders(self: *const OptionalHeader) u32 {
        return self.fieldVal("size_of_headers", u32);
    }

    pub fn getDataDirectories(self: *const OptionalHeader) *const DataDirectories {
        return self.fieldPtr("data_directories", DataDirectories);
    }

    pub fn getSectionHeaders(self: *const OptionalHeader, file_hdr: *const FileHeader) []const SectionHeader {
        const number_of_sections = file_hdr.number_of_sections;
        const section_headers_ptr: [*]const SectionHeader = @ptrCast(self.fieldPtr("section_headers", SectionHeader));
        return section_headers_ptr[0..number_of_sections];
    }

    pub fn getImageBase(self: *const OptionalHeader) usize {
        return self.fieldVal("image_base", usize);
    }
};

const IMAGE_SIZEOF_SHORT_NAME = 8;

pub const SectionHeader = coff.SectionHeader;
