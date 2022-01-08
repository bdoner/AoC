const std = @import("std");
const aocTest = @import("helpers/testcase.zig");


const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day5.txt");

pub fn part1() void {
    var nice_strings: u32 = 0;
    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        if (isNice(line)) {
            nice_strings += 1;
        }
    }
    std.log.info("Part1: Result is {}", .{nice_strings});
}

pub fn part2() void {
    var nice_strings: u32 = 0;
    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        if (isNiceV2(line)) {
            nice_strings += 1;
        }
    }
    std.log.info("Part2: Result is {}", .{nice_strings});
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

fn isNiceV2(string: []const u8) bool {
    
    // It contains a pair of any two letters that appears at least twice in the string without overlapping, 
    // like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
    var found = false;
    var i: u32 = 0;
    while (i < string.len - 1) : (i += 1) {
        if (std.mem.indexOfPos(u8, string, i+2, string[i..i+2])) |_| {
            found = true;
            break;
        }
    }
    if (!found) {
        return false;
    }
    
    //It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
    found = false;
    i = 0;
    while (i < string.len - 2) : (i += 1) {
        if (string[i] == string[i+2]) {
            found = true;
            break;
        }
    }
    if (!found) {
        return false;
    }


    return true;
}

test "part1 tests" {
    const tests = [_]aocTest.TestCase(bool){
        aocTest.newTest(bool, true, "ugknbfddgicrmopn"),
        aocTest.newTest(bool, true, "aaa"),
        aocTest.newTest(bool, false, "jchzalrnumimnmhp"),
        aocTest.newTest(bool, false, "dvszwmarrgswjxmb"),
    };

    for (tests) |tc| {
        const n = isNice(tc.data);
        try expectEqual(tc.expected, n);
    }
}

test "part2 tests" {
    const tests = [_]aocTest.TestCase(bool){
        aocTest.newTest(bool, true, "qjhvhtzxzqqjkmpb"),
        aocTest.newTest(bool, true, "xxyxx"),
        aocTest.newTest(bool, false, "uurcxstgmygtbstg"),
        aocTest.newTest(bool, false, "ieodomkazucvgmuy"),
    };

    std.log.warn("", .{});
    for (tests) |tc| {
        std.log.warn("testing: {s}", .{tc.data});

        const n = isNiceV2(tc.data);
        try expectEqual(tc.expected, n);
    }
}
