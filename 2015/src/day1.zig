const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day1.txt");

inline fn getDirection(b: u8) i32 {
    return switch(b) {
        '(' => 1,
        ')' => -1,
        else => @intCast(i32, 0),
    };
}

pub fn part1() void {
    var floor: i32 = 0;
    for(input) |b| {
        floor += getDirection(b);
    }

    std.log.info("Part1: Final floor is {}", .{floor});
}

pub fn part2() void {
    var floor: i32 = 0;
    var basement_floor: u32 = 0;
    for(input) |b| {
        floor += getDirection(b);
        basement_floor += 1;
        if (floor == -1) {
            break;
        }
    }

    std.log.info("Part2: Floor Santa enters basement is {}", .{basement_floor});
}

test "part1 tests" {

    const tests = [_]aocTest.TestCase(i32) {
        aocTest.newTest(i32, 0, "(())"),
        aocTest.newTest(i32, 0, "(())"),
        aocTest.newTest(i32, 0, "()()"),

        aocTest.newTest(i32, 3, "((("),
        aocTest.newTest(i32, 3, "(()(()("),
        aocTest.newTest(i32, 3, "))((((("),

        aocTest.newTest(i32, -1, "())"),
        aocTest.newTest(i32, -1, "))("),

        aocTest.newTest(i32, -3, ")))"),
        aocTest.newTest(i32, -3, ")())())"),
    };

    for (tests) |tc| {
        var floor: i32 = 0;
        for(tc.data) |b| {
            floor += getDirection(b);
        }
        try expectEqual(tc.expected, floor);
    }
}

test "part2 tests" {
    const tests = [_]aocTest.TestCase(u32) {
        aocTest.newTest(u32, 1, ")"),
        aocTest.newTest(u32, 5, "()())"),
    };

    for (tests) |tc| {
        var floor: i32 = 0;
        var basement_floor: u32 = 0;
        for(tc.data) |b| {
            floor += getDirection(b);
            basement_floor += 1;
            if (floor == -1) {
                break;
            }
        }
        try expectEqual(tc.expected, basement_floor);
    }
}