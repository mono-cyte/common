const std = @import("std");
const assert = std.debug.assert;

const NiPoint3 = @import("NiPoint.zig").NiPoint3;

// 24
/// NiMatrix33 3x3 矩阵
pub const NiMatrix33 = extern struct {
    data: f32[3][3],

    const Self = @This();

    pub fn initIdentity() Self {
        return Self{
            .data = [3][3]f32{
                [3]f32{ 1.0, 0.0, 0.0 },
                [3]f32{ 0.0, 1.0, 0.0 },
                [3]f32{ 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn asIdentity(self: *Self) void {
        self.data[0][0] = 1.0;
        self.data[0][1] = 0.0;
        self.data[0][2] = 0.0;
        self.data[1][0] = 0.0;
        self.data[1][1] = 1.0;
        self.data[1][2] = 0.0;
        self.data[2][0] = 0.0;
        self.data[2][1] = 0.0;
        self.data[2][2] = 1.0;
    }

    // Addition/Subtraction
    pub fn add(self: *const Self, other: *const Self) Self {
        return .{
            .data = [3][3]f32{
                [3]f32{ self.data[0][0] + other.data[0][0], self.data[0][1] + other.data[0][1], self.data[0][2] + other.data[0][2] },
                [3]f32{ self.data[1][0] + other.data[1][0], self.data[1][1] + other.data[1][1], self.data[1][2] + other.data[1][2] },
                [3]f32{ self.data[2][0] + other.data[2][0], self.data[2][1] + other.data[2][1], self.data[2][2] + other.data[2][2] },
            },
        };
    }
    pub fn sub(self: *const Self, other: *const Self) Self {
        return .{
            .data = [3][3]f32{
                [3]f32{ self.data[0][0] - other.data[0][0], self.data[0][1] - other.data[0][1], self.data[0][2] - other.data[0][2] },
                [3]f32{ self.data[1][0] - other.data[1][0], self.data[1][1] - other.data[1][1], self.data[1][2] - other.data[1][2] },
                [3]f32{ self.data[2][0] - other.data[2][0], self.data[2][1] - other.data[2][1], self.data[2][2] - other.data[2][2] },
            },
        };
    }

    // Matric mult
    pub fn mulMatrix(self: *const Self, other: *const Self) Self {
        return .{
            .data = [3][3]f32{
                [3]f32{
                    self.data[0][0] * other.data[0][0] + self.data[0][1] * other.data[1][0] + self.data[0][2] * other.data[2][0],
                    self.data[0][0] * other.data[0][1] + self.data[0][1] * other.data[1][1] + self.data[0][2] * other.data[2][1],
                    self.data[0][0] * other.data[0][2] + self.data[0][1] * other.data[1][2] + self.data[0][2] * other.data[2][2],
                },
                [3]f32{
                    self.data[1][0] * other.data[0][0] + self.data[1][1] * other.data[1][0] + self.data[1][2] * other.data[2][0],
                    self.data[1][0] * other.data[0][1] + self.data[1][1] * other.data[1][1] + self.data[1][2] * other.data[2][1],
                    self.data[1][0] * other.data[0][2] + self.data[1][1] * other.data[1][2] + self.data[1][2] * other.data[2][2],
                },
                [3]f32{
                    self.data[2][0] * other.data[0][0] + self.data[2][1] * other.data[1][0] + self.data[2][2] * other.data[2][0],
                    self.data[2][0] * other.data[0][1] + self.data[2][1] * other.data[1][1] + self.data[2][2] * other.data[2][1],
                    self.data[2][0] * other.data[0][2] + self.data[2][1] * other.data[1][2] + self.data[2][2] * other.data[2][2],
                },
            },
        };
    }

    // Scalar multiplier
    pub fn mulScalar(self: *const Self, scalar: f32) Self {
        return .{
            .data = [3][3]f32{
                [3]f32{ self.data[0][0] * scalar, self.data[0][1] * scalar, self.data[0][2] * scalar },
                [3]f32{ self.data[1][0] * scalar, self.data[1][1] * scalar, self.data[1][2] * scalar },
                [3]f32{ self.data[2][0] * scalar, self.data[2][1] * scalar, self.data[2][2] * scalar },
            },
        };
    }
    // Vector mult
    pub fn mulVector(self: *const Self, pt: *const NiPoint3) NiPoint3 {
        return .{
            .x = self.data[0][0] * pt.x + self.data[0][1] * pt.y + self.data[0][2] * pt.z,
            .y = self.data[1][0] * pt.x + self.data[1][1] * pt.y + self.data[1][2] * pt.z,
            .z = self.data[2][0] * pt.x + self.data[2][1] * pt.y + self.data[2][2] * pt.z,
        };
    }

    pub fn Transpose(self: *const Self) Self {
        return .{
            .data = [3][3]f32{
                [3]f32{ self.data[0][0], self.data[1][0], self.data[2][0] },
                [3]f32{ self.data[0][1], self.data[1][1], self.data[2][1] },
                [3]f32{ self.data[0][2], self.data[1][2], self.data[2][2] },
            },
        };
    }

    // Get/Set Euler angles
    /// 获取矩阵的欧拉角
    pub fn GetEulerAngles(self: *const Self) [3]f32 {
        var heading: f32 = undefined;
        var attitude: f32 = undefined;
        var bank: f32 = undefined;
        if (self.data[1][0] > 0.998) { // singularity at north pole
            heading = std.math.atan2(self.data[0][2], self.data[2][2]);
            attitude = std.math.pi / 2;
            bank = 0;
        } else if (self.data[1][0] < -0.998) { // singularity at south pole
            heading = std.math.atan2(self.data[0][2], self.data[2][2]);
            attitude = -std.math.pi / 2;
            bank = 0;
        } else {
            heading = std.math.atan2(-self.data[2][0], self.data[0][0]);
            bank = std.math.atan2(-self.data[1][2], self.data[1][1]);
            attitude = std.math.asin(self.data[1][0]);
        }
        return .{ heading, attitude, bank };
    }
    pub fn SetEulerAngles(self: *Self, heading: f32, attitude: f32, bank: f32) void {

        // 或考虑使用double提高精度

        const ch = std.math.cos(heading);
        const sh = std.math.sin(heading);
        const ca = std.math.cos(attitude);
        const sa = std.math.sin(attitude);
        const cb = std.math.cos(bank);
        const sb = std.math.sin(bank);

        self.data[0][0] = ch * ca;
        self.data[0][1] = sh * sb - ch * sa * cb;
        self.data[0][2] = ch * sa * sb + sh * cb;
        self.data[1][0] = sa;
        self.data[1][1] = ca * cb;
        self.data[1][2] = -ca * sb;
        self.data[2][0] = -sh * ca;
        self.data[2][1] = sh * sa * cb + ch * sb;
        self.data[2][2] = -sh * sa * sb + ch * cb;
    }
};

comptime {
    assert(@sizeOf(NiMatrix33) == 0x24);
}
