const std = @import("std");
const assert = std.debug.assert;

// 18
/// NiTArray 稀疏数组，可含 NULL 条目，遍历时跳过
/// 迭代范围：0 到 m_emptyRunStart - 1
pub fn NiTArray(comptime T: type) type {
    return extern struct {
        _vtable: *const VTable, // 00
        m_data: ?[*]T, // 08 - 数据指针
        m_arrayBufLen: u16, // 10 - 缓冲区最大元素数
        m_emptyRunStart: u16, // 12 - 空槽起始索引
        m_size: u16, // 14 - 已用槽位数
        m_growSize: u16, // 16 - 扩容步长

        const Self = @This();
        const VTable = extern struct {
            _destructor: *const fn (self: *Self) callconv(.C) void,
        };
    };
}

comptime {
    assert(@sizeOf(NiTArray(?*anyopaque)) == 0x18);
}
