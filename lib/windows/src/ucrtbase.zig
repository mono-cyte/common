const std = @import("std");
const windows = @import("windows.zig");
const _PIFV = windows._PIFV;

pub extern "ucrtbase" fn _initterm(start: [*]const _PIFV, end: [*]const _PIFV) callconv(.c) void;
pub extern "ucrtbase" fn _initterm_e(start: [*]const _PIFV, end: [*]const _PIFV) callconv(.c) i32;
pub extern "ucrtbase" fn __get_narrow_winmain_command_line() callconv(.c) [*]const u8;
