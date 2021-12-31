const std = @import("std");
const TestCase = @import("utils.zig").TestCase;
const expect = std.testing.expect;
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

test "part1 samples" {

    const tests = [_]TestCase {
        .{ .expected = 0, .data = "(())" },
        .{ .expected = 0, .data = "()()" },

        .{ .expected = 3, .data = "(((" },
        .{ .expected = 3, .data = "(()(()(" },
        .{ .expected = 3, .data = "))(((((" },

        .{ .expected = -1, .data = "())" },
        .{ .expected = -1, .data = "))(" },

        .{ .expected = -3, .data = ")))" },
        .{ .expected = -3, .data = ")())())" },
    };

    for (tests) |tc| {
        var floor: i32 = 0;
        for(tc.data) |b| {
            floor += getDirection(b);
        }
        try expect(floor == tc.expected);
    }
}

test "part2 samples" {
    const tests = [_]TestCase {
        .{ .expected = 1, .data = ")" },
        .{ .expected = 5, .data = "()())" },
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
        try expect(basement_floor == tc.expected);
    }
}