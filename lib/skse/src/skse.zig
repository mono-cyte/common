const std = @import("std");
const assert = std.debug.assert;

const windows = @import("windows");
const re = @import("re");
const pe = re.pe;

const HANDLE = windows.HANDLE;

const _PIFV = windows._PIFV;

// api-ms-win-crt-runtime-l1-1-0.dll
const initterm_type = ?*const @TypeOf(windows.ucrtbase._initterm_e);
const cmdline_type = ?*const @TypeOf(windows.ucrtbase.__get_narrow_winmain_command_line);

var g_initterm_e_original: initterm_type = null;
var g_get_narrow_winmain_command_line_original: cmdline_type = null;

pub fn bootstrap() !void {
    // 对应于 cpp spdlog库初始化
    const exe = try windows.GetModuleHandle(null); // 当前可执行程序模块    const base: [*]const u8 = @ptrCast(exe);
    const base = @as([*]const u8, @ptrCast(exe));
    const ptrs = try re.PEManager.Ptrs.initFromBase(base);
    if (ptrs.getImportAddressPtr(
        "api-ms-win-crt-runtime-l1-1-0.dll",
        "_initterm_e",
        64,
        initterm_type,
    )) |initterm| {
        g_initterm_e_original = @ptrCast(initterm);
        //write hook
    } else |err| {
        // log error
        std.log.err("boot error: {s}", .{@errorName(err)});
    }

    if (ptrs.getImportAddressPtr(
        "api-ms-win-crt-runtime-l1-1-0.dll",
        "_get_narrow_winmain_command_line",
        64,
        cmdline_type,
    )) |cmdline| {
        g_get_narrow_winmain_command_line_original = @ptrCast(cmdline);
        //write hook
    } else |err| {
        // log error
        std.log.err("boot error: {s}", .{@errorName(err)});
    }
}

// runs before global initializers
fn __initterm_e_hook(a: [*]_PIFV, b: [*]_PIFV) i32 {
    // could be used for plugin optional preload
    return g_initterm_e_original(a, b);
}

// runs after global initializers
fn __get_narrow_winmain_command_line_hook() u8 {
    init();
    return g_get_narrow_winmain_command_line_original();
}

fn init() void {}
