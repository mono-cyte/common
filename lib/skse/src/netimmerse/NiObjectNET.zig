const std = @import("std");
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;

const NiObject = @import("NiObject.zig").NiObject;
const NiTimeController = @import("NiTimeController.zig").NiTimeController;
const NiExtraData = @import("NiExtraData.zig").NiExtraData;
const BSFixedString = @import("../skse64/StringCache.zig").BSFixedString;

// 30
pub const NiObjectNET = extern struct {
    base: NiObject, // 00

    m_name: [*:0]const u8, // 10
    m_controller: *NiTimeController, // 18 next pointer at +0x30
    m_extraData: ?[*]?*NiExtraData, // 20 extra data
    m_extraDataLen: u16, // 28 max valid entry
    m_extraDataCapacity: u16, // 2A array len
    pad2C: u32,

    const Self = @This();

    pub const VTable = extern struct {
        // base: NiObject
        base: NiObject.VTable, // 00
    };

    // UNTESTED
    pub fn putExtraData(self: *Self, allocator: Allocator, extraData: *NiExtraData) !void {
        extraData.incRef();
        // No capacity, allocate and grow
        var new_size: u32 = 0;

        if (self.m_extraDataCapacity == 0) {
            new_size = 1;
            const extraData_list = try allocator.alloc(*NiExtraData, new_size);
            extraData_list[0] = extraData;
            self.m_extraData = extraData_list.ptr;
            self.m_extraDataCapacity = new_size;
            self.m_extraDataLen = new_size;
            return;
        } // Reached capacity, reallocate and grow
        else if (self.m_extraDataLen == self.m_extraDataCapacity) {
            new_size = (self.m_extraDataCapacity * 2) + 1;
            const extraData_list = try allocator.alloc(*NiExtraData, new_size);
            // Copy the entries over
            @memcpy(extraData_list[0..self.m_extraDataLen], self.m_extraData[0..self.m_extraDataLen]);
            @memset(extraData_list[self.m_extraDataLen..new_size], 0);

            allocator.free(self.m_extraData[0..self.m_extraDataCapacity]); // free the old data
            self.m_extraData = extraData_list.ptr; // set the new data
            self.m_extraDataCapacity = new_size;
        }

        self.m_extraData[self.m_extraDataLen] = extraData;
        self.m_extraDataLen += 1;

        std.mem.sort(*NiExtraData, self.m_extraData[0..self.m_extraDataLen], {}, ExtraDataLessThan);
    }

    fn ExtraDataLessThan(cxt: anytype, a: *NiExtraData, b: *NiExtraData) bool {
        _ = cxt;
        const lhs = @intFromPtr(a.m_pcName);
        const rhs = @intFromPtr(b.m_pcName);
        return lhs < rhs; // 当且仅当 lhs < rhs 时返回 true，对应 C 的 -1
    }

    pub fn removeExtraData(self: *Self, allocator: Allocator, extraData: *NiExtraData) bool {
        const index = self.GetIndexOf(extraData);
        if (index >= 0) {
            extraData.decRef();
            for (index..self.m_extraDataLen - 1) |i| {
                self.m_extraData[i] = self.m_extraData[i + 1];
            }
            self.m_extraDataLen -= 1;
            self.m_extraData[self.m_extraDataLen] = null;
            if (self.m_extraDataLen == 0) {
                allocator.free(self.m_extraData[0..self.m_extraDataCapacity]);
                self.m_extraData = null;
                self.m_extraDataLen = 0;
                self.m_extraDataCapacity = 0;
            }
            return true;
        } else {
            return false;
        }
    }
    pub fn getIndexOf(self: *Self, extraData: *NiExtraData) i32 {
        if (extraData.m_pcName) |name| {
            var min: i16 = 0;
            var max: i16 = self.m_extraDataLen - 1;
            // Iterative binary search 二分查找
            while (max >= min) {
                const mid = (min + max) >> 1;
                if (self.m_extraData[mid].m_pcName == name) {
                    return mid; // Found entry
                } else if (self.m_extraData[mid].m_pcName < name) {
                    min = mid + 1;
                } else {
                    max = mid - 1;
                }
            }
        } else {
            return -1;
        }
    }
    pub fn getExtraData(self: *Self, name: BSFixedString) ?*NiExtraData {
        var min = 0;
        var max = self.m_extraDataLen - 1;

        while (max >= min) { // Iterative binary search
            const mid = (min + max) >> 1;
            if (self.m_extraData) |extraData| {
                if (extraData[mid]) |da| {
                    if (da.m_pcName == name.data) {
                        return &da;
                    } else if (da.m_pcName < name.data) {
                        min = mid + 1;
                    } else {
                        max = mid - 1;
                    }
                }
            }
            return null;
        }
    }
};

comptime {
    assert(@sizeOf(NiObjectNET) == 0x30);
}
