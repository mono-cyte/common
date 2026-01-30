const std = @import("std");
const buildin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const windows = b.dependency("windows", .{
        .target = target,
        .optimize = optimize,
    }).module("windows");

    const root = b.addModule("re", .{
        .root_source_file = b.path("src/re.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "windows", .module = windows },
        },
    });

    const lib = b.addLibrary(.{
        .name = "re",
        .root_module = root,
    });

    b.installArtifact(lib);
}
