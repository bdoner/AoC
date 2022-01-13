const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day11.txt");

pub fn part1() !void {
    var slc = input.*;
    std.debug.print("Current password: {s}\n", .{&slc});
    while (!isValid(&slc)) {
        flip(&slc);
        //std.debug.print("Testing password: {s}\n", .{&slc});
    }
    std.debug.print("Part1: Next valid password is {s}\n", .{slc});
}

pub fn part2() !void {
    var slc = input.*;
    std.debug.print("Current password: {s}\n", .{&slc});
    while (!isValid(&slc)) {
        flip(&slc);
    }
    
    std.debug.print("1st valid password: {s}\n", .{&slc});

    flip(&slc);
    while (!isValid(&slc)) {
        flip(&slc);
    }

    std.debug.print("Part2: Next next valid password is {s}\n", .{slc});
}

fn flip(pw: []u8) void {
    if (pw.len == 1) {
        return;
    }

    const li = pw.len - 1;
    if (pw[li] == 'z') {
        pw[li] = 'a';
        flip(pw[0..li]);
    } else {
        pw[li] += 1;
    }
}

fn isValid(pw: []const u8) bool {
    var found: bool = false;
    var i: usize = 0;
    while (i < pw.len - 2) : (i += 1) {
        if (pw[i] == pw[i + 1] - 1 and pw[i] == pw[i + 2] - 2) {
            found = true;
            break;
        }
    }

    if (!found) {
        return false;
    }

    if (0 < std.mem.count(u8, pw, "i")) return false;
    if (0 < std.mem.count(u8, pw, "o")) return false;
    if (0 < std.mem.count(u8, pw, "l")) return false;

    var pairOne: u8 = 0;
    found = false;
    i = 0;
    while (i < pw.len - 1) : (i += 1) {
        if (pw[i] == pw[i + 1]) {
            pairOne = pw[i];
            break;
        }
    }

    while (i < pw.len - 1) : (i += 1) {
        if (pw[i] == pw[i + 1] and pw[i] != pairOne) {
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
        aocTest.newTest(bool, false, "hijklmmn"),
        aocTest.newTest(bool, false, "abbceffg"),
        aocTest.newTest(bool, false, "abbcegjk"),
        aocTest.newTest(bool, true, "abcdffaa"),
        aocTest.newTest(bool, true, "ghjaabcc"),
    };

    for (tests) |tc| {
        const pass = isValid(tc.data);

        try expectEqual(tc.expected, pass);
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
