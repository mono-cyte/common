const std = @import("std");

/// 4
/// NiPointer 智能指针
pub fn NiPointer(T: type) type {
    return extern struct {
        m_pObject: ?*T, // 00

        const Self = @This();

        pub fn init(pObject: ?*T) Self {
            const ptr = Self{ .m_pObject = pObject };
            if (pObject) |obj| {
                if (@hasDecl(T, "IncRef")) {
                    obj.IncRef();
                }
            }
            return ptr;
        }

        pub fn deinit(self: *Self) void {
            if (self.m_pObject) |obj| {
                if (@hasDecl(T, "DecRef")) {
                    obj.DecRef();
                }
                self.m_pObject = null;
            }
        }

        pub fn copy(rhs: *const Self) Self {
            const ptr = Self{ .m_pObject = rhs.m_pObject };
            if (rhs.m_pObject) |obj| {
                if (@hasDecl(T, "IncRef")) {
                    obj.IncRef();
                }
            }
            return ptr;
        }

        pub fn assign(self: *Self, rhs: *const Self) void {
            if (self.m_pObject != rhs.m_pObject) {
                if (rhs.m_pObject) |obj| {
                    if (@hasDecl(T, "IncRef")) {
                        obj.IncRef();
                    }
                }
                if (self.m_pObject) |obj| {
                    if (@hasDecl(T, "DecRef")) {
                        obj.DecRef();
                    }
                }
                self.m_pObject = rhs.m_pObject;
            }
        }

        pub fn assignFromPtr(self: *Self, rhs: ?*T) void {
            if (self.m_pObject != rhs) {
                if (rhs) |obj| {
                    if (@hasDecl(T, "IncRef")) {
                        obj.IncRef();
                    }
                }
                if (self.m_pObject) |obj| {
                    if (@hasDecl(T, "DecRef")) {
                        obj.DecRef();
                    }
                }
                self.m_pObject = rhs;
            }
        }

        pub fn get(self: *const Self) ?*T {
            return self.m_pObject;
        }

        pub fn getConst(self: *const Self) ?*const T {
            return self.m_pObject;
        }

        pub fn getMut(self: *Self) ?*T {
            return self.m_pObject;
        }

        pub fn isNull(self: *const Self) bool {
            return self.m_pObject == null;
        }

        pub fn isNotNull(self: *const Self) bool {
            return self.m_pObject != null;
        }

        pub fn equals(self: *const Self, pObject: ?*T) bool {
            return self.m_pObject == pObject;
        }

        pub fn notEquals(self: *const Self, pObject: ?*T) bool {
            return self.m_pObject != pObject;
        }

        pub fn equalsPtr(self: *const Self, ptr: *const Self) bool {
            return self.m_pObject == ptr.m_pObject;
        }

        pub fn notEqualsPtr(self: *const Self, ptr: *const Self) bool {
            return self.m_pObject != ptr.m_pObject;
        }

        pub fn deref(self: *const Self) *T {
            std.debug.assert(self.m_pObject != null, "Attempting to dereference null NiPointer");
            return self.m_pObject.?;
        }

        pub fn arrow(self: *const Self) *T {
            std.debug.assert(self.m_pObject != null, "Attempting to access null NiPointer");
            return self.m_pObject.?;
        }

        pub fn reset(self: *Self) void {
            if (self.m_pObject) |obj| {
                if (@hasDecl(T, "DecRef")) {
                    obj.DecRef();
                }
            }
            self.m_pObject = null;
        }

        pub fn swap(self: *Self, other: *Self) void {
            const temp = self.m_pObject;
            self.m_pObject = other.m_pObject;
            other.m_pObject = temp;
        }

        pub fn release(self: *Self) ?*T {
            const ptr = self.m_pObject;
            self.m_pObject = null;
            return ptr;
        }

        pub fn adopt(self: *Self, pObject: ?*T) void {
            if (self.m_pObject) |obj| {
                if (@hasDecl(T, "DecRef")) {
                    obj.DecRef();
                }
            }
            self.m_pObject = pObject;
        }
    };
}
