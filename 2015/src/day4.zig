const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day4.txt");

pub fn part1() !void {
    const res = try findIts(input, "00000");
    std.log.info("Part1: Result is {}", .{res});
}

pub fn part2() !void {
    const res = try findIts(input, "000000");
    std.log.info("Part2: Result is {}", .{res});
}

fn findIts(key: []const u8, difficulty: []const u8) !u32 {
    const md5 = std.crypto.hash.Md5;
    var digest: [std.crypto.hash.Md5.digest_length]u8 = undefined;
    var c: u32 = 0;

    var cs: [32]u8 = undefined;
    var cslice = cs[0..];

    var cs2: [32]u8 = undefined;
    var cslice2 = cs2[0..];

    while (true) : (c += 1) {
        const tohash = try std.fmt.bufPrint(cslice, "{s}{d}", .{ key, c });
        md5.hash(tohash, &digest, .{});
        const dig: []const u8 = digest[0..];
        const hexdigest = try std.fmt.bufPrint(cslice2, "{s}", .{std.fmt.fmtSliceHexLower(dig)});

        if (std.mem.startsWith(u8, hexdigest, difficulty)) {
            //std.log.warn("key: {s}, digest: {s}", .{ tohash, hexdigest });
            //std.log.warn("Found match.", .{});
            break;
        }
    }

    return c;
}

test "part1 tests" {
    const tests = [_]TestCase(u32){
        newTest(u32, 609043, "abcdef"),
        newTest(u32, 1048970, "pqrstuv"),
    };

    for (tests) |tc| {
        const c = try findIts(tc.data, "00000");
        try expectEqual(tc.expected, c);
    }
}

// This puzzle has no sample for part two
// test "part2 tests" {
//     const tests = [_]TestCase{
//       //  .{ .expected = 609043, .data = "abcdef" },
//       // .{ .expected = 1048970, .data = "pqrstuv" },
//     };

//     for (tests) |tc| {
//         const c = try findIts(tc.data, "000000");
//         try expect(c == tc.expected);
//     }
// }
