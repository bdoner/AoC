const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
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

    const tests = [_]TestCase(i32) {
        newTest(i32, 0, "(())"),
        newTest(i32, 0, "(())"),
        newTest(i32, 0, "()()"),

        newTest(i32, 3, "((("),
        newTest(i32, 3, "(()(()("),
        newTest(i32, 3, "))((((("),

        newTest(i32, -1, "())"),
        newTest(i32, -1, "))("),

        newTest(i32, -3, ")))"),
        newTest(i32, -3, ")())())"),
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
    const tests = [_]TestCase(u32) {
        newTest(u32, 1, ")"),
        newTest(u32, 5, "()())"),
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