const std = @import("std");
const assert = std.debug.assert;

const NiPoint3 = @import("NiPoint.zig").NiPoint3;
const NiMatrix33 = @import("NiMatrix.zig").NiMatrix33;

// 34
pub const NiTransform = extern struct {
    rot: NiMatrix33, // 00
    pos: NiPoint3, // 24
    scale: f32, // 30

    const Self = @This();
    pub fn init() Self {
        return .{
            .rot = NiMatrix33.initIdentity(),
            .pos = .{},
            .scale = 1.0,
        };
    }

    // Multiply transforms
    pub fn mul(self: *const Self, rhs: *const Self) Self {
        return .{
            .rot = self.rot.mulMatrix(rhs.rot),
            .pos = self.pos.add(self.rot.mulVector(rhs.pos).mul(self.scale)),
            .scale = self.scale * rhs.scale,
        };
    }

    // Transform point
    pub fn mulPoint(self: *const Self, pt: *const NiPoint3) NiPoint3 {
        return self.rot.mulVector(pt).mul(self.scale).add(self.pos);
    }

    // Invert
    pub fn Invert(self: *const Self, kDest: *Self) void {
        kDest.rot = self.rot.Transpose();
        kDest.scale = 1.0 / self.scale;
        kDest.pos = kDest.rot.mulVector(-self.pos).mul(kDest.scale);
    }
};

comptime {
    assert(@sizeOf(NiTransform) == 0x34);
}
