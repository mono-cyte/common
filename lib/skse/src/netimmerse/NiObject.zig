const std = @import("std");
const assert = std.debug.assert;

const relocation = @import("../Relocation.zig");
const RelocPtr = relocation.RelocPtr;
const RelocAddr = relocation.RelocAddr;
const RelocFn = RelocAddr;
const NiRTTI = @import("NiRTTI.zig").NiRTTI;
const NiRect = @import("NiRect.zig").NiRect;
const NiPoint3 = @import("NiPoint.zig").NiPoint3;

// NiRefObject/NiObject and important children
// generally other children should go in other files
// especially if they can be grouped

// 前向声明, 无定义
pub const NiCloningProcess = opaque {};
pub const NiStream = opaque {};
pub const NiObjectGroup = opaque {};
pub const NiExtraData = opaque {};
pub const NiTimeController = opaque {};
pub const NiNode = opaque {};
pub const NiGeometry = opaque {};
pub const BSGeometry = opaque {};
pub const NiRenderedTexture = opaque {};
pub const NiSwitchNode = opaque {};
pub const NiTriBasedGeom = opaque {};
pub const NiTriShape = opaque {};
pub const NiTriStrips = opaque {};
pub const BSSegmentedTriShape = opaque {};
pub const NiRenderTargetGroup = opaque {};
pub const NiProperty = opaque {};
pub const NiSourceTexture = opaque {};
pub const BSTriShape = opaque {};
pub const TESObjectCELL = opaque {};
pub const TESModelTri = opaque {};
pub const BSFaceGenMorphData = opaque {};
pub const TESObjectREFR = opaque {};

// 2789403034E226069B9EC04A8AC7BD367AF61384+BC
var g_worldToCamMatrix = RelocPtr(f32).init(0x031AD3A0);

// 2789403034E226069B9EC04A8AC7BD367AF61384+13E
var g_viewPort = RelocPtr(NiRect(f32)).init(0x031AE960);

const _WorldPtToScreenPt3_Internal = *const fn (worldToCamMatrix: *f32, port: *NiRect(f32), p_in: *NiPoint3, x_out: *f32, y_out: *f32, z_out: *f32, zeroTolerance: f32) callconv(.c) bool;
var WorldPtToScreenPt3_Internal = RelocFn(_WorldPtToScreenPt3_Internal).init(0x00D2C780);

const _NiAllocate = *const fn (size: usize) callconv(.c) ?*anyopaque;
var NiAllocate = RelocFn(_NiAllocate).init(0x00CE7DD0);

const _NiFree = *const fn (*anyopaque) callconv(.c) void;
var NiFree = RelocFn(_NiFree).init(0x00CE8070);

const NiRefObject = @import("NiRefObject.zig").NiRefObject;

// NiObject - 继承自 NiRefObject
pub const NiObject = extern struct {
    /// 继承自 NiRefObject - 必须放在第一个字段以保持内存布局
    base: NiRefObject,

    pub const VTable = extern struct {
        base: NiRefObject.VTable, // 00

        // standard NetImmerse
        GetRTTI: *const fn (*Self) callconv(.c) ?*const NiRTTI,

        // then a bunch of attempts to avoid dynamic_cast?
        // unverified, do not use
        GetAsNiNode: *const fn (*Self) callconv(.c) ?*const NiNode,
        GetAsNiSwitchNode: *const fn (*Self) callconv(.c) ?*const NiSwitchNode,
        Unk_05: *const fn (*Self) callconv(.c) ?*anyopaque,
        Unk_06: *const fn (*Self) callconv(.c) u32,
        GetAsBSGeometry: *const fn (*Self) callconv(.c) ?*const BSGeometry,
        Unk_08: *const fn (*Self) callconv(.c) ?*anyopaque,
        GetAsBSTriShape: *const fn (*Self) callconv(.c) ?*const BSTriShape,
        Unk_0A: *const fn (*Self) callconv(.c) ?*anyopaque,
        Unk_0B: *const fn (*Self) callconv(.c) ?*anyopaque,
        Unk_0C: *const fn (*Self) callconv(.c) ?*anyopaque,
        GetAsNiGeometry: *const fn (*Self) callconv(.c) ?*const NiGeometry,
        GetAsNiTriBasedGeom: *const fn (*Self) callconv(.c) ?*const NiTriBasedGeom,
        GetAsNiTriShape: *const fn (*Self) callconv(.c) ?*const NiTriShape,
        Unk_10: *const fn (*Self) callconv(.c) ?*anyopaque,
        Unk_11: *const fn (*Self) callconv(.c) ?*anyopaque,
        Unk_12: *const fn (*Self) callconv(.c) ?*anyopaque,

        // SE: these 4 were added
        Unk_13: *const fn (*Self) callconv(.c) u32,
        Unk_14: *const fn (*Self) callconv(.c) u32,
        Unk_15: *const fn (*Self) callconv(.c) u32,
        Unk_16: *const fn (*Self) callconv(.c) u32,

        // then back to NetImmerse
        CreateClone: *const fn (*Self, *NiCloningProcess) callconv(.c) ?*Self,
        LoadBinary: *const fn (*Self, *NiStream) callconv(.c) void,
        LinkObject: *const fn (*Self, *NiStream) callconv(.c) void,
        RegisterStreamables: *const fn (*Self, *NiStream) callconv(.c) bool,
        SaveBinary: *const fn (*Self, *NiStream) callconv(.c) void,

        // viewer appears to be disabled sadly
        // why did you do that? it was really useful for figuring out class data
        // and it's not like it totally bloated up the executa... er never mind
        IsEqual: *const fn (*Self, ?*Self) callconv(.c) bool,
        ProcessClone: *const fn (*Self, *NiCloningProcess) callconv(.c) void,
        PostLinkObject: *const fn (*Self, *NiStream) callconv(.c) void,
        StreamCanSkip: *const fn (*Self) callconv(.c) bool,
        GetStreamableRTTI: *const fn (*const Self) callconv(.c) ?*const anyopaque,
        GetBlockAllocationSize: *const fn (*const Self) callconv(.c) u32,
        GetGroup: *const fn (*const Self) callconv(.c) ?*NiObjectGroup,
        SetGroup: *const fn (*Self, ?*NiObjectGroup) callconv(.c) void,

        // begin bethesda extensions? possibly just stuff we can't match up
        Unk_20: *const fn (*Self) callconv(.c) u32,
    };

    const Self = @This();

    pub fn IncRef(self: *Self) void {
        self.base.IncRef();
    }

    pub fn DecRef(self: *Self) void {
        self.base.DecRef();
    }

    pub const DeepCopy = RelocFn(*const fn (self: *Self, **Self) callconv(.c) *NiStream).init(0x00D18080);
};

comptime {
    assert(@sizeOf(NiObject) == 0x10);
}
