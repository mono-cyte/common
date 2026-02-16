const relocation = @import("../Relocation.zig");
const RelocPtr = relocation.RelocPtr;
const RelocAddr = relocation.RelocAddr;
const RelocFn = RelocAddr;

const std = @import("std");
const Allocator = std.mem.Allocator;

// 80808
pub const StringCache = extern struct {
    pub const Ref = extern struct {
        data: [*:0]const u8,
        const Self = @This();

        const fn_ctor = RelocFn(*const fn (self: *Self, buf: [*:0]const u8) callconv(.c) *Self).init(0x00CEC5D0);
        // 31D79EFB15D5E4B34BD32D03A46EAFF65C28ACFB+CB

        const fn_ctor_ref = RelocFn(*const fn (self: *Self, rhs: *const Self) callconv(.c) *Self).init(0x00CEC680);
        const fn_set = RelocFn(*const fn (self: *Self, buf: [*:0]const u8) callconv(.c) *Self).init(0x00CEC760);
        // 31D79EFB15D5E4B34BD32D03A46EAFF65C28ACFB+41
        const fn_set_ref = RelocFn(*const fn (self: *Self, rhs: *const Self) callconv(.c) *Self).init(0x00CEC820);
        // 46F6DC561A3C9677037E58B55951C58A08E41C47+4A
        const fn_release = RelocFn(*const fn (self: *Self) callconv(.c) void).init(0x00CED9A0);

        pub const init = ctor; // alias
        pub fn ctor(self: *Self, buf: [*:0]const u8) *Self {
            return fn_ctor.get()(self, buf);
        }
        pub fn ctor_ref(self: *Self, rhs: *const Self) *Self {
            return fn_ctor_ref.get()(self, rhs);
        }
        pub fn set(self: *Self, buf: [*:0]const u8) *Self {
            return fn_set.get()(self, buf);
        }
        pub fn set_ref(self: *Self, rhs: *const Self) *Self {
            return fn_set_ref.get()(self, rhs);
        }
        pub fn release(self: *Self) void {
            return fn_release.get()(self);
        }

        pub fn getData(self: Self) [*:0]const u8 {
            return self.data;
        }

        /// 相等比较（对应 operator==）
        pub fn eql(self: Self, other: Self) bool {
            return self.data == other.data;
        }

        /// 小于比较（对应 operator<）
        pub fn lessThan(self: Self, other: Self) bool {
            const a = @intFromPtr(self.data orelse return false);
            const b = @intFromPtr(other.data orelse return true);
            return a < b;
        }
    };
    pub const Lock = extern struct {
        _unk00: u32,
        _pad04: u32,
        _pad08: u64,
    };

    lut: [0x10000]*anyopaque, // 00000
    lock: [0x80]Lock, // 00000
    isInit: u8, // 80800
};

pub const BSFixedString = StringCache.Ref;
