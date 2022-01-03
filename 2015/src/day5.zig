const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day5.txt");

pub fn part1() void {
    var nice_strings: u32 = 0;
    var it = std.mem.split(u8, input, "\n");
    while (it.next()) |line| {
        if (isNice(line)) {
            nice_strings += 1;
        }
    }
    std.log.info("Part1: Result is {}", .{nice_strings});
}

pub fn part2() void {
    std.log.info("Part2: Result is {}", .{0});
}

fn isNice(string: []const u8) bool {
    const vowels = "aeiou";

    // Contains at least three vowels
    var n_vowels: u32 = 0;
    for (string) |b| {
        if (std.mem.indexOfScalar(u8, vowels, b)) |_| {
            n_vowels += 1;
        }
    }
    if (n_vowels < 3) {
        return false;
    }

    // Has two (or more) repeating chars
    var found = false;
    var i: u32 = 1;
    while (i < string.len) : (i += 1) {
        if (string[i - 1] == string[i]) {
            found = true;
            break;
        }
    }
    if (!found) {
        return false;
    }

    // Does *not* contains any of the following; ab, cd, pq, or xy
    const bad_chars = [_][]const u8{ "ab", "cd", "pq", "xy" };
    for (bad_chars) |bc| {
        if (std.mem.indexOf(u8, string, bc)) |_| {
            return false;
        }
    }

    return true;
}

test "part1 tests" {
    const tests = [_]TestCase(bool){
        newTest(bool, true, "ugknbfddgicrmopn"),
        newTest(bool, true, "aaa"),
        newTest(bool, false, "jchzalrnumimnmhp"),
        newTest(bool, false, "dvszwmarrgswjxmb"),
    };

    for (tests) |tc| {
        const n = isNice(tc.data);
        try expectEqual(tc.expected, n);
    }
}

test "part2 tests" {
    const tests = [_]TestCase(u32){
        newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
        try expectEqual(tc.expected, 0);
    }
}
