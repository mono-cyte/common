const std = @import("std");
const buildin = @import("builtin");

fn build_log() void {
    std.debug.print("ABI: {}\n", .{buildin.abi});
    std.debug.print("OS: {}\n", .{buildin.os.tag});
    std.debug.print("Mode: {}\n", .{buildin.mode});
    std.debug.print("Version: {f}\n", .{buildin.zig_version});
    std.debug.print("CPU: {}\n", .{buildin.cpu});
    std.debug.print("Output: {}\n", .{buildin.output_mode});
}

pub fn build(b: *std.Build) void {
    build_log();
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const windows = b.dependency("windows", .{
        .target = target,
        .optimize = optimize,
    }).module("windows");

    const re = b.dependency("re", .{
        .target = target,
        .optimize = optimize,
    }).module("re");

    const skse = b.dependency("skse", .{
        .target = target,
        .optimize = optimize,
    }).module("skse");

    const log = b.dependency("log", .{
        .target = target,
        .optimize = optimize,
    }).module("log");

    const root = b.createModule(.{ .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize, .imports = &.{
        .{ .name = "windows", .module = windows },
        .{ .name = "re", .module = re },
        .{ .name = "skse", .module = skse },
        .{ .name = "log", .module = log },
    } });

    const exe = b.addExecutable(.{
        .name = "common",
        .root_module = root,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
