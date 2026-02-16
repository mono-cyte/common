const std = @import("std");
const windows = std.os.windows;
pub const ntdll = @import("ntdll.zig");
pub const ucrtbase = @import("ucrtbase.zig");
pub const user32 = @import("user32.zig");

pub const UINT = windows.UINT;
pub const ULONG = windows.ULONG;
pub const ACCESS_MASK = windows.ACCESS_MASK;
pub const BOOL = windows.BOOL;
pub const WORD = windows.WORD;
pub const DWORD = windows.DWORD;
pub const LPCVOID = windows.LPCVOID;
pub const PMEMORY_BASIC_INFORMATION = windows.PMEMORY_BASIC_INFORMATION;
pub const MEM = windows.MEM;
pub const PAGE = windows.PAGE;
pub const SIZE_T = windows.SIZE_T;
pub const ULONG_PTR = windows.ULONG_PTR;
pub const PVOID = windows.PVOID;
pub const HANDLE = windows.HANDLE;
pub const HMODULE = windows.HMODULE;
pub const HINSTANCE = windows.HINSTANCE;
pub const HWND = windows.HWND;
pub const SECURITY_ATTRIBUTES = windows.SECURITY_ATTRIBUTES;
pub const LPTHREAD_START_ROUTINE = windows.LPTHREAD_START_ROUTINE;
pub const LPVOID = windows.LPVOID;
pub const OBJECT_ATTRIBUTES = windows.OBJECT_ATTRIBUTES;
pub const unexpectedStatus = windows.unexpectedStatus;
pub const STARTUPINFOW = windows.STARTUPINFOW;
pub const NTSTATUS = windows.NTSTATUS;
pub const Win32Error = windows.Win32Error;
pub const BOOLEAN = windows.BOOLEAN;
pub const PWSTR = windows.PWSTR;
pub const PCWSTR = windows.PCWSTR;
pub const LPCWSTR = windows.LPCWSTR;
pub const UNICODE_STRING = windows.UNICODE_STRING;

pub const DllReason = enum(u32) {
    PROCESS_DETACH = 0,
    PROCESS_ATTACH = 1,
    THREAD_ATTACH = 2,
    THREAD_DETACH = 3,
    _,
};

pub const _PIFV = ?*const fn () callconv(.c) void;

pub const teb = windows.teb;

pub const GetCurrentProcess = windows.GetCurrentProcess;
pub const GetCurrentThread = windows.GetCurrentThread;
pub const GetCurrentProcessId = windows.GetCurrentProcessId;
pub const GetCurrentThreadId = windows.GetCurrentThreadId;

pub const CLIENT_ID = extern struct {
    UniqueProcess: ?HANDLE,
    UniqueThread: ?HANDLE,
};

const VirtualQueryError = error{Unexpected};

pub fn VirtualQueryEx(
    process_handle: HANDLE,
    addr: ?LPCVOID,
    buf: PMEMORY_BASIC_INFORMATION,
    len: SIZE_T,
) VirtualQueryError!SIZE_T {
    var write_len = 0;
    const rc = ntdll.NtQueryVirtualMemory(process_handle, addr, .MemoryBasicInformation, buf, len, &write_len);
    switch (rc) {
        .SUCCESS => return write_len,
        else => return unexpectedStatus(rc),
    }
}

pub fn VirtualQuery(
    addr: ?LPCVOID,
    buf: PMEMORY_BASIC_INFORMATION,
    len: SIZE_T,
) VirtualQueryError!SIZE_T {
    return try VirtualQueryEx(GetCurrentProcess(), addr, buf, len);
}

const VirtualProtectError = error{Unexpected};

pub fn VirtualProtectEx(
    process_handle: HANDLE,
    addr: LPVOID,
    size: SIZE_T,
    new_protect: PAGE,
    old_protect: *PAGE,
) VirtualProtectError!void {
    var _addr = addr;
    var _size = size;

    var rc = ntdll.NtProtectVirtualMemory(process_handle, &_addr, &_size, new_protect, old_protect);

    if (rc == .INVALID_PAGE_PROTECTION and process_handle == GetCurrentProcess()) {
        if (ntdll.RtlFlushSecureMemoryCache(_addr, _size) != 0) {
            rc = ntdll.NtProtectVirtualMemory(process_handle, &_addr, &_size, new_protect, old_protect);
        }
    }

    switch (rc) {
        .SUCCESS => return,
        else => return unexpectedStatus(rc),
    }
}

pub fn VirtualProtect(
    addr: LPVOID,
    size: SIZE_T,
    new_protect: PAGE,
    old_protect: *PAGE,
) VirtualProtectError!void {
    try VirtualProtectEx(GetCurrentProcess(), addr, size, new_protect, old_protect);
}

const OpenProcessError = error{
    InValidCID,
    Unexpected,
};

pub fn OpenProcess(
    access: ACCESS_MASK,
    inherit_handle: bool,
    pid: DWORD,
) OpenProcessError!HANDLE {
    const obj_attr: OBJECT_ATTRIBUTES = .{
        .Length = @sizeOf(OBJECT_ATTRIBUTES),
        .RootDirectory = null,
        .Attributes = .{ .INHERIT = inherit_handle },
        .ObjectName = null,
        .SecurityDescriptor = null,
        .SecurityQualityOfService = null,
    };
    const cid: CLIENT_ID = .{
        .UniqueProcess = @ptrFromInt(pid),
        .UniqueThread = null,
    };
    var handle: HANDLE = undefined;
    const rc = ntdll.NtOpenProcess(
        &handle,
        access,
        &obj_attr,
        &cid,
    );
    switch (rc) {
        .SUCCESS => return handle,
        .INVALID_CID => return error.InValidCID,
        else => return unexpectedStatus(rc),
    }
}

const VirtualFreeExError = error{
    AccessDenied,
    InvalidHandle,
    InvalidParameter,
    Unexpected,
};

pub fn VirtualFreeEx(process_handle: HANDLE, addr: LPVOID, size: SIZE_T, free_type: MEM.FREE) VirtualFreeExError!void {
    if (free_type.RELEASE and size != 0) {
        return error.InvalidParameter;
    }

    var _addr = addr;
    var _size = size;
    var rc = ntdll.NtFreeVirtualMemory(
        process_handle,
        &_addr,
        &_size,
        free_type,
    );
    if (rc == .INVALID_PAGE_PROTECTION and process_handle == GetCurrentProcess()) {
        if (ntdll.RtlFlushSecureMemoryCache(_addr, _size) != 0) {
            rc = ntdll.NtFreeVirtualMemory(process_handle, &_addr, &_size, free_type);
        }
    }
    switch (rc) {
        .SUCCESS => return,
        .ACCESS_DENIED => return error.AccessDenied,
        .INVALID_HANDLE => return error.InvalidHandle,
        .INVALID_PARAMETER => return error.InvalidParameter,
        else => return unexpectedStatus(rc),
    }
}

const VirtualFreeError = VirtualFreeExError;

pub fn VirtualFree(addr: LPVOID, size: SIZE_T, free_type: MEM.FREE) VirtualFreeError!void {
    return try VirtualFreeEx(GetCurrentProcess(), addr, size, free_type);
}

pub const VirtualAllocError = error{
    AccessDenied,
    InvalidHandle,
    InvalidParameter,
    Unexpected,
};

pub fn VirtualAllocEx(
    process_handle: HANDLE,
    addr: ?LPVOID,
    size: SIZE_T,
    alloc_type: MEM.ALLOCATE,
    protect: PAGE,
) VirtualAllocError!LPVOID {
    var base_addr: ?LPVOID = addr;
    var region_size: SIZE_T = size;

    const rc = ntdll.NtAllocateVirtualMemory(
        process_handle,
        @ptrCast(&base_addr),
        0,
        &region_size,
        alloc_type,
        protect,
    );

    return switch (rc) {
        .SUCCESS => base_addr orelse error.Unexpected,
        .ACCESS_DENIED => error.AccessDenied,
        .INVALID_HANDLE => error.InvalidHandle,
        .INVALID_PARAMETER => error.InvalidParameter,
        else => unexpectedStatus(rc),
    };
}

pub fn VirtualAlloc(
    addr: ?LPVOID,
    size: SIZE_T,
    alloc_type: MEM.ALLOCATE,
    protect: PAGE,
) VirtualAllocError!LPVOID {
    return try VirtualAllocEx(
        GetCurrentProcess(),
        addr,
        size,
        alloc_type,
        protect,
    );
}

pub const GetMoudleHandleError = error{
    NameTooLong,
    Unexpected,
};

pub fn GetModuleHandle(module_name: ?[]const u16) GetMoudleHandleError!HMODULE {
    if (module_name) |name| {
        const len_bytes = std.math.cast(u16, name.len * 2) orelse return error.NameTooLong;
        var unicode: UNICODE_STRING = .{
            .Length = @intCast(len_bytes),
            .MaximumLength = @intCast(len_bytes),
            .Buffer = @constCast(name.ptr),
        };
        var module_handle: PVOID = undefined;
        const rc = ntdll.LdrGetDllHandle(null, null, &unicode, &module_handle);
        return switch (rc) {
            .SUCCESS => @ptrCast(module_handle),
            else => unexpectedStatus(rc),
        };
    } else {
        return teb().ProcessEnvironmentBlock.ImageBaseAddress;
    }
}
