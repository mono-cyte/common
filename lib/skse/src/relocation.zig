const windows = @import("windows");

pub const RelocationManager = struct {
    fn initBase() !usize {
        return .{
            .s_baseAddr = @intFromPtr(try windows.GetModuleHandle(null)),
        };
    }

    pub var s_baseAddr: usize = initBase() catch |err| {
        @panic("Failed to initialize relocation manager: " ++ @errorName(err));
    };
};

// use this for addresses that represent pointers to a type T
pub fn RelocPtr(T: type) type {
    return struct {
        m_offset: usize,

        const Self = @This();
        pub fn init(offset: usize) Self {
            return .{
                .m_offset = offset + RelocationManager.s_baseAddr,
            };
        }
        pub fn get(self: Self) *T {
            return self.getPtr();
        }
        pub fn getPtr(self: Self) *T {
            return @ptrFromInt(self.m_offset);
        }
        pub fn getPtrConst(self: Self) *const T {
            return @ptrFromInt(self.m_offset);
        }
        pub fn getAddr(self: Self) usize {
            return self.m_offset;
        }
    };
}

// use this for direct addresses to types T. needed to avoid ambiguity
pub fn RelocAddr(P: type) type {
    return struct {
        m_offset: usize,

        const Self = @This();

        pub fn init(offset: usize) Self {
            return .{
                .m_offset = offset + RelocationManager.s_baseAddr,
            };
        }
        pub fn get(self: Self) P {
            return self.getPtr();
        }

        fn getPtr(self: Self) P {
            return @ptrFromInt(self.m_offset);
        }

        pub fn getAddr(self: Self) usize {
            return self.m_offset;
        }
    };
}
