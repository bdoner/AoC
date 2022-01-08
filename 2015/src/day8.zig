const std = @import("std");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day8.txt");

pub fn part1() !void {
    std.log.warn("", .{});

    var buff: [100]u8 = undefined;
    var totMemLen: u32 = 0;
    var totStorLen: u32 = 0;
    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |tok| {
        const lr = try parseString(tok, &buff);
        std.log.warn("ml: {d}, sl: {d}, r: {s}, p: {s}", .{ lr.memoryLen, lr.storageLen, lr.rawStr, lr.parsedStr });
        totMemLen += lr.memoryLen;
        totStorLen += lr.storageLen;
    }

    std.log.info("Part1: Difference between stored chars and chars in mem is {}", .{totStorLen - totMemLen});
}

pub fn part2() !void {
    std.log.warn("", .{});

    var buff: [100]u8 = undefined;
    var totMemLen: u32 = 0;
    var totStorLen: u32 = 0;
    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |tok| {
        const lr = try bloatString(tok, &buff);
        std.log.warn("ml: {d}, sl: {d}, r: {s}, p: {s}", .{ lr.memoryLen, lr.storageLen, lr.rawStr, lr.parsedStr });
        totMemLen += lr.memoryLen;
        totStorLen += lr.storageLen;
    }

    std.log.info("Part2: Difference between stored chars and chars in mem is {}", .{totMemLen - totStorLen});
}

const StringInfo = struct {
    memoryLen: u32,
    storageLen: u32,
    rawStr: []const u8,
    parsedStr: []const u8,
};

fn parseString(str: []const u8, outBuff: []u8) !StringInfo {
    var istr = str[1 .. str.len - 1];
    if (istr.len == 0) {
        return StringInfo{
            .storageLen = @intCast(u32, str.len),
            .memoryLen = 0,
            .rawStr = str,
            .parsedStr = "",
        };
    }

    var i: usize = 0;
    var o: usize = 0;
    while (i < istr.len) {
        if (istr[i] == '\\') {
            if (istr[i + 1] == 'x') {
                //const hxChr = istr[i + 2 .. i + 4];
                outBuff[o] = '_'; // try std.fmt.parseInt(u8, hxChr, 16);
                o += 1;
                i += 4;
                continue;
            } else {
                i += 1;
            }
        }
        outBuff[o] = istr[i];
        o += 1;
        i += 1;
    }

    const ret = outBuff[0..o];
    return StringInfo{ .storageLen = @intCast(u32, str.len), .memoryLen = @intCast(u32, ret.len), .rawStr = str, .parsedStr = ret };
}

fn bloatString(str: []const u8, outBuff: []u8) !StringInfo {
    outBuff[0] = '"';

    var i: usize = 0;
    var o: usize = 1;
    while (i < str.len) : (i += 1) {
        switch (str[i]) {
            '"', '\\' => {
                outBuff[o] = '\\';
                o += 1;
            },
            else => {},
        }

        outBuff[o] = str[i];
        o += 1;
    }

    outBuff[o] = '"';
    o += 1;

    const ret = outBuff[0..o];
    return StringInfo{ .storageLen = @intCast(u32, str.len), .memoryLen = @intCast(u32, ret.len), .rawStr = str, .parsedStr = ret };
}

test "part1 tests" {
    std.log.warn("", .{});
    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 12,
            \\""
            \\"abc"
            \\"aaa\"aaa"
            \\"\x27"
        ),
    };

    for (tests) |tc| {
        var buff: [100]u8 = undefined;
        var totMemLen: u32 = 0;
        var totStorLen: u32 = 0;
        var it = std.mem.tokenize(u8, tc.data, "\n");
        while (it.next()) |tok| {
            const lr = try parseString(tok, &buff);
            std.log.warn("ml: {d}, sl: {d}, r: {s}, p: {s}", .{ lr.memoryLen, lr.storageLen, lr.rawStr, lr.parsedStr });
            totMemLen += lr.memoryLen;
            totStorLen += lr.storageLen;
        }
        try expectEqual(tc.expected, totStorLen - totMemLen);
    }
}

test "part2 tests" {
    std.log.warn("", .{});
    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 19,
            \\""
            \\"abc"
            \\"aaa\"aaa"
            \\"\x27"
        ),
    };

    for (tests) |tc| {
        var totMemLen: u32 = 0;
        var totStorLen: u32 = 0;
        var it = std.mem.tokenize(u8, tc.data, "\n");
        while (it.next()) |tok| {
            const lr = try bloatString(tok);
            std.log.warn("ml: {d}, sl: {d}, r: {s}, p: {s}", .{ lr.memoryLen, lr.storageLen, lr.rawStr, lr.parsedStr });
            totMemLen += lr.memoryLen;
            totStorLen += lr.storageLen;
        }
        try expectEqual(tc.expected, totStorLen - totMemLen);
    }
}
