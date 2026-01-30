const std = @import("std");
const buildin = @import("builtin");

pub fn build(b: *std.Build) void {
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

    const root = b.addModule("skse", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "windows", .module = windows },
            .{ .name = "re", .module = re },
        },
    });

    var dll = b.addLibrary(.{
        .name = "skse",
        .root_module = root,
        .linkage = .dynamic,
    });
    dll.dll_export_fns = true;
    dll.setLinkerScript(b.path("skse64.def"));

    b.installArtifact(dll);
}
