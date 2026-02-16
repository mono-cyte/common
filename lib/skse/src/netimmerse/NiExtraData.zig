const std = @import("std");
const assert = std.debug.assert;
const NiObject = @import("NiObject.zig").NiObject;
const Allocator = std.mem.Allocator;
const SkseAllocator = @import("../api/Heap.zig").SkseAllocator;

// 18
pub const NiExtraData = extern struct {
    base: NiObject, // 00
    m_pcName: [*:0]const u8, // 10

    const Self = @This();
    pub fn initHeap(allocator: Allocator, size: u32, vtbl: usize) *NiExtraData {
        var memory = try allocator.alloc(u8, size);
        @memset(memory, 0);
        const xData: *NiExtraData = @ptrCast(@alignCast(memory.ptr));
        xData.base.base.vtable = @ptrFromInt(vtbl);
        return xData;
    }

    pub fn incRef(self: *Self) void {
        self.base.IncRef();
    }

    pub fn decRef(self: *Self) void {
        self.base.DecRef();
    }
};
comptime {
    assert(@sizeOf(NiExtraData) == 0x18);
}
