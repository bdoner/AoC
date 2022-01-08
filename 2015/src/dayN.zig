const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/dayN.txt");

pub fn part1() void {
    
    std.log.info("Part1: Result is {}", .{0});
}

pub fn part2() void {
    
    std.log.info("Part2: Result is {}", .{0});
}

test "part1 tests" {
    std.log.warn("", .{});

    const tests = [_]aocTest.TestCase(u32) {
        aoctest.newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
    
        try expectEqual(tc.expected, 0);
    }
}

test "part2 tests" {
    std.log.warn("", .{});

     const tests = [_]aocTest.TestCase(u32) {
        aoctest.newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
    
        try expectEqual(tc.expected, 0);
    }
}