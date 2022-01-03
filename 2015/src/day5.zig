const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day5.txt");

pub fn part1() void {
    
    std.log.info("Part1: Result is {}", .{0});
}

pub fn part2() void {
    
    std.log.info("Part2: Result is {}", .{0});
}

test "part1 tests" {
    const tests = [_]TestCase(u32) {
        newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
    
        try expectEqual(tc.expected, 0);
    }
}

test "part2 tests" {
     const tests = [_]TestCase(u32) {
        newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
    
        try expectEqual(tc.expected, 0);
    }
}