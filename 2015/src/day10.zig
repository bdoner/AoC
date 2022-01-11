const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day10.txt");

pub fn part1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var out: []const u8 = &input.*;
    var c: usize = 0;
    while (c < 40) : (c += 1) {
        //std.debug.print("{d}: {s} ", .{ c, out });
        out = try solvep1(allocator, out);
        //std.debug.print("=> {s}\n", .{out});

        //allocator.free(out);
    }

    std.debug.print("Part1: Length of result after 40 iterations is {d}\n", .{out.len});
    allocator.free(out);
}

pub fn part2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var out: []const u8 = &input.*;
    var c: usize = 0;
    while (c < 50) : (c += 1) {
        //std.debug.print("{d}: {s} ", .{ c, out });
        out = try solvep1(allocator, out);
        //std.debug.print("=> {s}\n", .{out});

        //allocator.free(out);
    }

    std.debug.print("Part2: Length of result after 50 iterations is {d}\n", .{out.len});
    allocator.free(out);
}

fn solvep1(allocator: std.mem.Allocator, inp: []const u8) ![]u8 {
    var al = std.ArrayList(u8).init(allocator);

    if (inp.len == 0) {
        return al.toOwnedSlice();
    }

    if (inp.len == 1) {
        try al.append('1');
        try al.append(inp[0]);

        return al.toOwnedSlice();
    }

    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var end: usize = i + 1;
        while (end < inp.len and inp[i] == inp[end]) : (end += 1) {} else {
            const num = inp[i];
            const occ = end - i;

            var buffBack = [_]u8{0} ** 16;
            var buff: []u8 = buffBack[0..];
            const sl = std.fmt.formatIntBuf(buff, occ, 10, .lower, .{});
            try al.appendSlice(buff[0..sl]);
            try al.append(num);

            i = end - 1;
        }
    }

    return al.toOwnedSlice();
}

test "part1 tests" {
    std.debug.print("\n", .{});

    const tests = [_]aocTest.TestCase([]const u8){
        aocTest.newTest([]const u8, "11", "1"),
        aocTest.newTest([]const u8, "21", "11"),
        aocTest.newTest([]const u8, "1211", "21"),
        aocTest.newTest([]const u8, "111221", "1211"),
        aocTest.newTest([]const u8, "312211", "111221"),
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    for (tests) |tc| {
        const out = try solvep1(allocator, tc.data);
        std.debug.print("{s} => {s}\n", .{ tc.data, out });
        std.debug.print("{any} => {any}\n\n", .{ tc.data, out });
        try std.testing.expectEqualStrings(tc.expected, out);
        allocator.free(out);
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
