// 8
/// NiPoint2 二维点
pub const NiPoint2 = extern struct {
    x: f32, // 0
    y: f32, // 4
};

// C
/// NiPoint3 三维点
pub const NiPoint3 = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,

    const Self = @This();

    /// 默认构造函数（全零）
    pub fn init() Self {
        return .{};
    }

    /// 带参数构造函数
    pub fn initXYZ(x: f32, y: f32, z: f32) Self {
        return .{ .x = x, .y = y, .z = z };
    }

    /// 一元负号：返回负向量
    pub fn neg(self: Self) Self {
        return .{
            .x = -self.x,
            .y = -self.y,
            .z = -self.z,
        };
    }

    /// 向量加法
    pub fn add(self: Self, other: Self) Self {
        return .{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
        };
    }

    /// 向量减法
    pub fn sub(self: Self, other: Self) Self {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
            .z = self.z - other.z,
        };
    }

    /// 标量乘法
    pub fn mul(self: Self, scalar: f32) Self {
        return .{
            .x = self.x * scalar,
            .y = self.y * scalar,
            .z = self.z * scalar,
        };
    }

    /// 标量除法
    pub fn div(self: Self, scalar: f32) Self {
        return .{
            .x = self.x / scalar,
            .y = self.y / scalar,
            .z = self.z / scalar,
        };
    }

    /// 向量加等于
    pub fn addAssign(self: *Self, other: Self) void {
        self.x += other.x;
        self.y += other.y;
        self.z += other.z;
    }

    /// 向量减等于
    pub fn subAssign(self: *Self, other: Self) void {
        self.x -= other.x;
        self.y -= other.y;
        self.z -= other.z;
    }

    /// 标量乘等于
    pub fn mulAssign(self: *Self, scalar: f32) void {
        self.x *= scalar;
        self.y *= scalar;
        self.z *= scalar;
    }

    /// 标量除等于
    pub fn divAssign(self: *Self, scalar: f32) void {
        self.x /= scalar;
        self.y /= scalar;
        self.z /= scalar;
    }
};
