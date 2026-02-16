// 10
/// NiRefObject 接口 - 用于引用计数
pub const NiRefObject = extern struct {
    vtable: *const VTable, // 00
    refCount: i32, // 08 volatile
    pad0C: u32, // 0C

    pub const VTable = extern struct {
        _destructor: *const fn (*Self) callconv(.c) void,
        DeleteThis: *const fn (*Self) callconv(.c) void,
    };
    const Self = @This();

    pub fn IncRef(self: *Self) void {
        _ = @atomicRmw(@TypeOf(self.refCount), &self.refCount, .Add, 1, .seq_cst);
    }

    pub fn DecRef(self: *Self) void {
        if (self.Release()) {
            self.DeleteThis();
        }
    }

    fn DeleteThis(self: *Self) void {
        self.vtable.DeleteThis(self);
    }

    fn Release(self: *Self) bool {
        // NOTION: atomicRmw returns previous value
        return @atomicRmw(@TypeOf(self.refCount), &self.refCount, .Sub, 1, .seq_cst) - 1 == 0;
    }
};
