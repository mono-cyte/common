// 20
pub fn NiTLargeArray(comptime T: type) type {
    return extern struct {
        _vtable: *const VTable, // 00
        m_data: ?[*]T, // 08 - 数据指针
        m_arrayBufLen: u32, // 10 - max elements storable in m_data
        m_emptyRunStart: u32, // 14 - index of beginning of empty slot run
        m_size: u32, // 18 - number of filled slots
        m_growSize: u32, // 1C - number of slots to grow m_data by
        const Self = @This();
        const VTable = extern struct {
            _destructor: *const fn (self: *Self) callconv(.C) void,
        };
    };
}
