const std = @import("std");
const meta = std.meta;
const mem = std.mem;

const Day = enum {
    day1,
    day2,
    day3,
    day4,
    day5,
    day6,
    day7,
    day8,
    day9,
    day10,
    day11,
    day12,
    day13,
};

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    var argCount: u32 = 0;
    var args = std.process.args();
    _ = args.skip();
    while (try args.next(allocator)) |arg| {
        argCount += 1;
        defer allocator.free(arg);

        const argument = meta.stringToEnum(Day, arg) orelse {
            usage(arg);
            break;
        };
        std.log.info("Running solution for {s}", .{@tagName(argument)});
        switch (argument) {
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
            .day4 => {
                const day4 = @import("day4.zig");
                try day4.part1();
                try day4.part2();
            },
            .day5 => {
                const day5 = @import("day5.zig");
                day5.part1();
                day5.part2();
            },
            .day6 => {
                const day6 = @import("day6.zig");
                try day6.part1();
                try day6.part2();
            },
            .day7 => {
                const day7 = @import("day7.zig");
                try day7.part1();
                try day7.part2();
            },
            .day8 => {
                const day8 = @import("day8.zig");
                try day8.part1();
                try day8.part2();
            },
            .day9 => {
                const day9 = @import("day9.zig");
                try day9.part1();
                try day9.part2();
            },
            .day10 => {
                const day10 = @import("day10.zig");
                try day10.part1();
                try day10.part2();
            },
            .day11 => {
                const day11 = @import("day11.zig");
                try day11.part1();
                try day11.part2();
            },
            .day12 => {
                const day12 = @import("day12.zig");
                try day12.part1();
                try day12.part2();
            },
            .day13 => {
                const day13 = @import("day13.zig");
                try day13.part1();
                try day13.part2();
            },
        }
    }

    if (argCount == 0) {
        usage("");
    }

    std.log.info("done.\n", .{});
}

fn usage(arg: []u8) void {
    std.log.warn("No day matching \"{s}\" found.", .{arg});
    std.log.warn("", .{});
    std.log.warn("usage: Aoc2015.exe <dayN>", .{});
    std.log.warn("Available days are:", .{});
    for (meta.fieldNames(Day)) |fieldName| {
        std.log.warn("\t{s}", .{fieldName});
    }
}

test "" {
    //_ = @import("day13.zig");
}
