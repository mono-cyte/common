const std = @import("std");
const buildin = @import("builtin");

pub fn addDllSKSE(b: *std.Build, m: *std.Build.Module) *std.Build.Step.Compile {
    var dll = b.addLibrary(.{
        .name = "skse",
        .root_module = m,
        .linkage = .dynamic,
    });
    dll.entry = .{ .symbol_name = "entry" };
    return dll;
}

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .windows,
    });
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

    const dll = addDllSKSE(b, root);

    b.installArtifact(dll);
}
