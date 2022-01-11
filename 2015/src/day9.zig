const std = @import("std");
const permutate = @import("permutate");
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day9.txt");

inline fn printTowns(towns: [][]const u8) void {
    var first = true;
    for (towns) |town| {
        if (!first) {
            std.debug.print(" -> ", .{});
        }
        first = false;
        std.debug.print("{s}", .{town});
    }
    std.debug.print("\n", .{});
}

pub fn part1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var distances_arraylist = std.ArrayList(Distance).init(allocator);
    defer distances_arraylist.deinit();

    var townsMap = std.StringHashMap(bool).init(allocator);
    defer townsMap.deinit();

    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        const d = try parse(line);

        try distances_arraylist.append(d);

        try townsMap.put(d.from, true);
        try townsMap.put(d.to, true);
    }

    var townsList = std.ArrayList([]const u8).init(allocator);
    defer townsList.deinit();

    var tkit = townsMap.keyIterator();
    while (tkit.next()) |town| {
        try townsList.append(town.*);
    }

    var distances = distances_arraylist.toOwnedSlice();
    var towns = townsList.toOwnedSlice();
    defer allocator.free(distances);
    defer allocator.free(towns);

    for (towns) |town| {
        std.debug.print("Town: {s}\n", .{town});
    }

    for (distances) |dist| {
        std.debug.print("Dist: {s} -> {s} = {d}\n", .{ dist.from, dist.to, dist.dist });
    }

    var shortestPath: usize = std.math.maxInt(usize);
    var pit = try permutate.permutate([]const u8, towns);
    while (pit.next()) |p| {
        var distSum: usize = 0;
        var i: usize = 0;
        while (i < p.len - 1) : (i += 1) {
            const pd = getDistance(distances, p[i], p[i + 1]);

            //std.debug.print("{s}", .{p[i]});
            //std.debug.print(" --({d})> ", .{pd});
            //std.debug.print("{s}\n", .{p[i + 1]});

            distSum += pd;
        }
        shortestPath = @minimum(distSum, shortestPath);
    }

    std.log.info("Part1: Shortest path is {}", .{shortestPath});
}

pub fn part2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var distances_arraylist = std.ArrayList(Distance).init(allocator);
    defer distances_arraylist.deinit();

    var townsMap = std.StringHashMap(bool).init(allocator);
    defer townsMap.deinit();

    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        const d = try parse(line);

        try distances_arraylist.append(d);

        try townsMap.put(d.from, true);
        try townsMap.put(d.to, true);
    }

    var townsList = std.ArrayList([]const u8).init(allocator);
    defer townsList.deinit();

    var tkit = townsMap.keyIterator();
    while (tkit.next()) |town| {
        try townsList.append(town.*);
    }

    var distances = distances_arraylist.toOwnedSlice();
    var towns = townsList.toOwnedSlice();
    defer allocator.free(distances);
    defer allocator.free(towns);

    var longestPath: usize = 0;
    var pit = try permutate.permutate([]const u8, towns);
    while (pit.next()) |p| {
        var distSum: usize = 0;
        var i: usize = 0;
        while (i < p.len - 1) : (i += 1) {
            const pd = getDistance(distances, p[i], p[i + 1]);

            //std.debug.print("{s}", .{p[i]});
            //std.debug.print(" --({d})> ", .{pd});
            //std.debug.print("{s}\n", .{p[i + 1]});

            distSum += pd;
        }
        longestPath = @maximum(distSum, longestPath);
    }

    std.log.info("Part2: Longest path is {}", .{longestPath});

}

fn parse(line: []const u8) !Distance {
    var it = std.mem.tokenize(u8, line, " =");
    const from = it.next().?;
    _ = it.next(); // skip the "to"
    const to = it.next().?;
    const dist = try std.fmt.parseInt(u32, it.next().?, 10);

    return Distance{
        .from = from,
        .to = to,
        .dist = dist,
    };
}

fn getDistance(dists: []Distance, a: []const u8, b: []const u8) u32 {
    for (dists) |d| {
        if (std.mem.eql(u8, d.from, a) and std.mem.eql(u8, d.to, b)) {
            return d.dist;
        }

        if (std.mem.eql(u8, d.from, b) and std.mem.eql(u8, d.to, a)) {
            return d.dist;
        }
    }

    @panic("invalid pair");
}

const Distance = struct {
    from: []const u8,
    to: []const u8,

    dist: u32,
};

test "part1 tests" {
    std.log.warn("", .{});

    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 0, "abc"),
    };

    for (tests) |tc| {
        try expectEqual(tc.expected, 0);
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
