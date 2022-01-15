const std = @import("std");
const aocTest = @import("helpers/testcase.zig");
const permutate = @import("permutate");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day13.txt");

pub fn part1() !void {
    const res = try solvePt1(input);
    std.debug.print("Part1: The optimal happiness score is {d:1}\n", .{res});
}

pub fn part2() !void {
    std.debug.print("Part2: Result is {}\n", .{0});
}

const HappyRule = struct {
    person: []const u8,
    score: i32,
    otherPerson: []const u8,
};

const ScoreSign = enum {
    gain,
    lose,
};

fn parseLine(line: []const u8) HappyRule {
    var it = std.mem.tokenize(u8, line, " .");
    while (it.next()) |op| {
        _ = it.next();
        const sign_txt = it.next().?;
        const score_txt = it.next().?;
        var i: usize = 0;
        while (i < 6) : (i += 1) {
            _ = it.next();
        }
        const othp = it.next().?;

        const sign = std.meta.stringToEnum(ScoreSign, sign_txt).?;
        var score = std.fmt.parseInt(i32, score_txt, 10) catch @panic("could not parse score");

        score = switch (sign) {
            .gain => score,
            .lose => score * -1,
        };

        return HappyRule{
            .person = op,
            .score = score,
            .otherPerson = othp,
        };
    }

    unreachable;
}

fn getScore(rules: std.ArrayList(HappyRule), a: []const u8, b: []const u8) i32 {
    for (rules.items) |r| {
        if (std.mem.eql(u8, r.person, a) and std.mem.eql(u8, r.otherPerson, b)) {
            return r.score;
        }
    }
    unreachable;
}

fn solvePt1(inp: []const u8) !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var scores = std.ArrayList(HappyRule).init(allocator);
    defer scores.deinit();

    var map = std.StringHashMap(bool).init(allocator);
    defer map.deinit();

    try map.put("me", false);

    std.debug.print("\n====== Rules ======\n", .{});
    var it = std.mem.tokenize(u8, inp, "\n");
    while (it.next()) |line| {
        const l = parseLine(line);
        std.debug.print("{s} => {s} = {d:1}\n", .{ l.person, l.otherPerson, l.score });
        try map.put(l.person, false);
        try map.put(l.otherPerson, false);

        try scores.append(l);
    }

    var nameList = std.ArrayList([]const u8).init(allocator);
    defer nameList.deinit();
    var nameIt = map.keyIterator();
    while (nameIt.next()) |n| {
        try nameList.append(n.*);

        const p_me_score = HappyRule{ .person = n.*, .otherPerson = "me", .score = 0 };
        const me_p_score = HappyRule{ .person = "me", .otherPerson = n.*, .score = 0 };

        try scores.append(p_me_score);
        try scores.append(me_p_score);
    }

    var names = nameList.toOwnedSlice();
    defer allocator.free(names);

    std.debug.print("====== Perms ======\n", .{});

    var maxHappy: i32 = 0;
    var permIt = try permutate.permutate([]const u8, names);
    while (permIt.next()) |perm| {
        //std.debug.print("------ Next ------\n", .{});

        var totScore: i32 = 0;
        var i: usize = 0;
        while (i < perm.len - 1) : (i += 1) {
            const sf = getScore(scores, perm[i], perm[i + 1]);
            const sr = getScore(scores, perm[i + 1], perm[i]);
            totScore += sf;
            totScore += sr;
            //std.debug.print("{s} -> {s} = {d:1}\n", .{ perm[i], perm[i + 1], sf });
            //std.debug.print("{s} -> {s} = {d:1}\n", .{ perm[i + 1], perm[i], sr });
        }
        {
            const sf = getScore(scores, perm[perm.len - 1], perm[0]);
            const sr = getScore(scores, perm[0], perm[perm.len - 1]);
            totScore += sf;
            totScore += sr;
            //std.debug.print("{s} -> {s} = {d:1}\n", .{ perm[perm.len - 1], perm[0], sf });
            //std.debug.print("{s} -> {s} = {d:1}\n", .{ perm[0], perm[perm.len - 1], sr });
        }
        maxHappy = @maximum(maxHappy, totScore);
    }

    return maxHappy;
}

test "part1 tests" {
    const sample =
        \\Alice would gain 54 happiness units by sitting next to Bob.
        \\Alice would lose 79 happiness units by sitting next to Carol.
        \\Alice would lose 2 happiness units by sitting next to David.
        \\Bob would gain 83 happiness units by sitting next to Alice.
        \\Bob would lose 7 happiness units by sitting next to Carol.
        \\Bob would lose 63 happiness units by sitting next to David.
        \\Carol would lose 62 happiness units by sitting next to Alice.
        \\Carol would gain 60 happiness units by sitting next to Bob.
        \\Carol would gain 55 happiness units by sitting next to David.
        \\David would gain 46 happiness units by sitting next to Alice.
        \\David would lose 7 happiness units by sitting next to Bob.
        \\David would gain 41 happiness units by sitting next to Carol.
    ;

    const tests = [_]aocTest.TestCase(i32){
        aocTest.newTest(i32, 330, sample),
    };

    for (tests) |tc| {
        const res = try solvePt1(tc.data);
        try expectEqual(tc.expected, res);
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
