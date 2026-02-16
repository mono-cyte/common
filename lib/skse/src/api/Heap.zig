const std = @import("std");
const Allocator = std.mem.Allocator;
const Alignment = std.mem.Alignment;

const relocation = @import("../relocation.zig");
const RelocPtr = relocation.RelocPtr;
const RelocAddr = relocation.RelocAddr;
const RelocFn = RelocAddr;

pub const Heap = struct {
    // 运行时获取函数指针
    const Allocate = RelocFn(*const fn (self: *Heap, size: usize, alignment: usize, aligned: bool) callconv(.c) *anyopaque).init(0x00CC40C0);
    const Free = RelocFn(*const fn (self: *Heap, buf: *anyopaque, aligned: bool) callconv(.c) void).init(0x00CC4510);

    pub fn alloc(self: *Heap, size: usize, alignment: usize, aligned: bool) ?[*]u8 {
        return self.Allocate.get()(self, size, alignment, aligned);
    }

    pub fn free(self: *Heap, cxt: *anyopaque, aligned: bool) void {
        self.Free.get()(self, cxt, aligned);
    }
};

// B05BDE2B512930D17FC7064CCC201FEE897AA475+44
pub const g_mainHeap = RelocPtr(Heap).init(0x035F11E0);

pub const SkseAllocator = struct {
    heap: *Heap = g_mainHeap.get(),
    const Self = @This();

    fn alloc(ctx: *anyopaque, n: usize, alignment: Alignment, ra: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        _ = ra;
        return self.heap.alloc(n, alignment, true);
    }

    // fn resize(ctx: *anyopaque, buf: []u8, alignment: Alignment, new_len: usize, ret_addr: usize) bool {
    //     const self: *Self = @ptrCast(@alignCast(ctx));
    //     _ = alignment;
    //     _ = ret_addr;

    //     _ = buf;
    //     _ = self;
    //     _ = new_len;
    //     return false;
    // }

    // fn remap(
    //     context: *anyopaque,
    //     memory: []u8,
    //     alignment: Alignment,
    //     new_len: usize,
    //     return_address: usize,
    // ) ?[*]u8 {
    //     return if (resize(context, memory, alignment, new_len, return_address)) memory.ptr else null;
    // }

    fn free(ctx: *anyopaque, buf: []u8, alignment: Alignment, ret_addr: usize) void {
        _ = alignment;
        _ = ret_addr;

        const self: *Self = @ptrCast(@alignCast(ctx));
        self.heap.free(buf.ptr, true);
    }

    pub fn allocator(self: *Self) Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .free = free,
                .resize = Allocator.noResize,
                .remap = Allocator.noRemap,
            },
        };
    }
};
