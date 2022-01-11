const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/dayN.txt");

pub fn part1() !void {
    std.debug.print("Part1: Result is {}\n", .{0});
}

pub fn part2() !void {
    std.debug.print("Part2: Result is {}\n", .{0});
}

test "part1 tests" {
    std.log.warn("", .{});

    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
        try expectEqual(tc.expected, 0);
    }
}

test "part2 tests" {
    std.log.warn("", .{});

    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
        try expectEqual(tc.expected, 0);
    }
}
