const std = @import("std");
const win = @import("windows");
const re = @import("re");

const Args = std.process.Args;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Io = std.Io;

fn prase_cmdline(allocator: Allocator, args: Args) !ArrayList([:0]const u8) {
    var it = try args.iterateAllocator(allocator);
    defer it.deinit();

    var list = try std.ArrayList([:0]const u8).initCapacity(allocator, 0);
    errdefer {
        for (list.items) |item| allocator.free(item);
        list.deinit(allocator);
    }
    while (it.next()) |arg| {
        const arg_copy = try allocator.dupeZ(u8, arg);
        try list.append(allocator, arg_copy);
    }
    return list;
}

pub fn main(init: std.process.Init) !void {
    const alloc = init.arena.allocator();
    const args = init.minimal.args;

    var threaded = std.Io.Threaded.init(alloc, .{
        .environ = init.minimal.environ,
    });
    defer threaded.deinit();

    const io = threaded.io();

    var args_array = try prase_cmdline(alloc, args);
    defer args_array.deinit(alloc);

    const path = args_array.items[1];

    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(io, path, .{});

    // const new = try cwd.createFile(io, "new.exe", .{ .read = true });
    const pe_file = try re.PEFile.initFromFile(alloc, io, file);
    try pe_file.formatExport();
    // try pe_file.formatImport();
}
