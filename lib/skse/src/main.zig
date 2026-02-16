const std = @import("std");

const windows = @import("windows");
const HINSTANCE = windows.HINSTANCE;
const DllReason = windows.DllReason;
const LPVOID = windows.LPVOID;
const DWORD = windows.DWORD;
const BOOL = windows.BOOL;

const skse = @import("skse.zig");

var g_module: ?HINSTANCE = null;

export fn entry(
    dll_handle: HINSTANCE,
    reason: DllReason,
    reserved: LPVOID,
) callconv(.winapi) BOOL {
    _ = reserved;

    switch (reason) {
        .PROCESS_ATTACH => {
            _ = windows.user32.MessageBoxW(
                null,
                &[_:0]u16{ 'S', 'K', 'S', 'E', ' ', 'l', 'o', 'a', 'd', 'e', 'd', 0 },
                null,
                .{
                    
                },
            );
            g_module = dll_handle;
        },
        .PROCESS_DETACH => {},
        else => {
            return 0;
        },
    }
    return 1;
}

export fn StartSKSE() void {
    skse.bootstrap() catch |e| {
        std.log.err("Failed to bootstrap SKSE: {s}", .{@errorName(e)});
        @panic("Failed to bootstrap SKSE!!");
    };
}
