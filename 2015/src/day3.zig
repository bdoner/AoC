const std = @import("std");
const expect = std.testing.expect;
const TestCase = @import("utils.zig").TestCase;
const input = @embedFile("input/day3.txt");

pub fn part1() !void{
    const r = try solve(input);
    std.log.info("Part1: Result is {}", .{r});
}


pub fn part2() void{

}

fn solve(inp: []const u8) !u32 {
    const width = 20000;
    const height = width; 
    const offset = width / 2;
    var allocator = std.heap.page_allocator;
    
    var grid = try allocator.alloc(u32, width*height); //~40kb
    std.mem.set(u32, grid, 0);

    var x: u32 = offset;
    var y: u32 = offset;
    grid[x + (y * width)] += 1;


    for(inp) |b| {
        //std.log.warn("index before: {c}: {},{}", .{b, x, y});
        switch(b) {
            '^' => y -= 1,
            '>' => x += 1,
            'v' => y += 1,
            '<' => x -= 1,
            else => {},
        }
        grid[x + (y * width)] += 1;
        //std.log.warn("index  after: {c}: {},{}", .{b, x, y});

    }

    var res: u32 = 0;
    for(grid) |v| {
        //std.log.warn("count: {}: {}", .{i, v});
        if(0 < v) {
            res += 1;
        }
    }

    return res;
}

test "part1 examples" {
    const tests = [_]TestCase {
        .{ .expected = 2, .data = ">" },
        .{ .expected = 4, .data = "^>v<" },
        .{ .expected = 2, .data = "^v^v^v^v^v" },
    };

    for(tests) |tc| {
        const r = try solve(tc.data);
        try expect(r == tc.expected);
    }
}


test "part2 examples" {

}


