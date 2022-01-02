const std = @import("std");
const meta = std.meta;
const mem = std.mem;

const Day = enum {
    day1,
    day2,
    day3,
};

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer { _ = gpa.deinit(); }

    var argCount: u32 = 0;
    var args = std.process.args();
    _ = args.skip();
    while(try args.next(allocator)) |arg| {
        argCount += 1;
        defer allocator.free(arg);

        const argument = meta.stringToEnum(Day, arg) orelse { usage(arg); break; };
        std.log.info("Running solution for {s}", .{@tagName(argument)});
        switch(argument) {
            .day1 => {
                const day1 = @import("day1.zig");
                day1.part1();
                day1.part2();
            },
            .day2 => {
                const day2 = @import("day2.zig");
                day2.part1();
                day2.part2();
            },
            .day3 => {
                const day3 = @import("day3.zig");
                try day3.part1();
                try day3.part2();
            },
        }
        
    }

    if(argCount == 0) {
        usage("");
    }

    std.log.info("done.\n", .{});
}

fn usage(arg: []u8) void {
    std.log.warn("No day matching \"{s}\" found.", .{arg});
    std.log.warn("",.{});
    std.log.warn("usage: Aoc2015.exe <dayN>", .{});
    std.log.warn("Available days are:", .{});
    for(meta.fieldNames(Day)) |fieldName| {
        std.log.warn("\t{s}", .{fieldName});
    }
}