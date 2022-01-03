const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day3.txt");

const Coord = struct {
    x: u32,
    y: u32,

    pub fn init(x: u32, y: u32) Coord {
        return .{
            .x = x,
            .y = y,
        };
    }

    pub fn getCalculatedIndex(me: Coord, w: u32) u32 {
        return me.x + (me.y * w);
    }
};

pub fn part1() !void {
    const r = try solve(input, 1);
    std.log.info("Part1: Result is {}", .{r});
}

pub fn part2() !void {
    const r = try solve(input, 2);
    std.log.info("Part2: Result is {}", .{r});
}

fn solve(inp: []const u8, num_santas: u8) !u32 {
    const width = 20000;
    const height = width;
    const offset = width / 2;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var grid = try allocator.alloc(u32, width * height);
    defer allocator.free(grid);
    std.mem.set(u32, grid, 0);

    var santa_coords = try allocator.alloc(Coord, num_santas);
    defer allocator.free(santa_coords);

    var sc: u32 = 0;
    while (sc < num_santas) : (sc += 1) {
        santa_coords[sc] = Coord.init(offset, offset);
        //std.log.warn("coord: {}: {}", .{ sc, santa_coords[sc] });

        grid[santa_coords[sc % num_santas].getCalculatedIndex(width)] += 1;
    }

    for (inp) |b| {
        const c: *Coord = &santa_coords[sc % num_santas];
        //std.log.warn("index before: {c}: {},{}", .{ b, santa_coords[sc % num_santas].x, santa_coords[sc % num_santas].y });
        switch (b) {
            '^' => c.y -= 1,
            '>' => c.x += 1,
            'v' => c.y += 1,
            '<' => c.x -= 1,
            else => {},
        }
        grid[c.getCalculatedIndex(width)] += 1;
        sc += 1;
        //std.log.warn("index  after: {c}: {},{}", .{ b, santa_coords[sc % num_santas].x, santa_coords[sc % num_santas].y });
    }

    var res: u32 = 0;
    for (grid) |v| {
        //std.log.warn("count: {}: {}", .{i, v});
        if (0 < v) {
            res += 1;
        }
    }

    return res;
}

test "part1 tests" {
    const tests = [_]TestCase(u32){
        newTest(u32, 2, ">"),
        newTest(u32, 4, "^>v<"),
        newTest(u32, 2, "^v^v^v^v^v"),
    };

    for (tests) |tc| {
        const r = try solve(tc.data, 1);
        try expectEqual(tc.expected, r);
    }
}

test "part2 tests" {
    const tests = [_]TestCase(u32){
        newTest(u32, 3, "^v"),
        newTest(u32, 3, "^>v<"),
        newTest(u32, 11, "^v^v^v^v^v"),
    };

    for (tests) |tc| {
        const r = try solve(tc.data, 2);
        try expectEqual(tc.expected, r);
    }
}
