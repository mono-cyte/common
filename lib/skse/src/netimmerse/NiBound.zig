const std = @import("std");
const assert = std.debug.assert;

const NiPoint3 = @import("NiPoint.zig").NiPoint3;

// 10
pub const NiBound = extern struct {
    pos: NiPoint3,
    radius: f32,
};

comptime {
    assert(@sizeOf(NiBound) == 0x10);
}
