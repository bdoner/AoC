const std = @import("std");
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

    const tests = [_]struct { exp: i32, data: []const u8 } {
        .{ .exp = 0, .data = "(())" },
        .{ .exp = 0, .data = "()()" },

        .{ .exp = 3, .data = "(((" },
        .{ .exp = 3, .data = "(()(()(" },
        .{ .exp = 3, .data = "))(((((" },

        .{ .exp = -1, .data = "())" },
        .{ .exp = -1, .data = "))(" },

        .{ .exp = -3, .data = ")))" },
        .{ .exp = -3, .data = ")())())" },
    };

    for (tests) |tc| {
        var floor: i32 = 0;
        for(tc.data) |b| {
            floor += getDirection(b);
        }
        try expect(floor == tc.exp);
    }
}

test "part2 samples" {
    const tests = [_]struct { exp: i32, data: []const u8 } {
        .{ .exp = 1, .data = ")" },
        .{ .exp = 5, .data = "()())" },
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
        try expect(basement_floor == tc.exp);
    }
}