const std = @import("std");
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day6.txt");

pub fn part1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var g = try Grid.init(allocator, 1000, 1000);
    defer allocator.free(g.grid);

    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        const instr = parseLine(line);
        //std.log.warn("{any}", .{instr});

        switch (instr.action) {
            .on => g.turnOnRect(instr.rect),
            .off => g.turnOffRect(instr.rect),
            .toggle => g.toggleRect(instr.rect),
        }
    }

    std.log.info("Part1: Turned on bulbs are {}", .{g.count()});
}

pub fn part2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var g = try Grid.init(allocator, 1000, 1000);
    defer allocator.free(g.grid);

    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| {
        const instr = parseLine(line);
        //std.log.warn("{any}", .{instr});
        g.changeRect(instr.rect, instr.action);
    }
    //Nope: 43698573946
    //      43704190930
    std.log.info("Part2: Sum of bulb values are {}", .{g.sum()});
}

fn parseLine(line: []const u8) Instruction {
    var i = Instruction{ .rect = Rect{ .x1 = 0, .y1 = 0, .x2 = 0, .y2 = 0 }, .action = Action.on };
    var it = std.mem.tokenize(u8, line, " ,");
    while (it.next()) |tok| {
        i.action = std.meta.stringToEnum(Action, tok) orelse continue;

        i.rect.x1 = std.fmt.parseInt(u32, it.next() orelse @panic("could not get val for rect.x1"), 10) catch @panic("unable to parse rect.x1");
        i.rect.y1 = std.fmt.parseInt(u32, it.next() orelse @panic("could not get val for rect.y1"), 10) catch @panic("unable to parse rect.y1");

        _ = it.next();

        i.rect.x2 = std.fmt.parseInt(u32, it.next() orelse @panic("could not get val for rect.x2"), 10) catch @panic("unable to parse rect.x2");
        i.rect.y2 = std.fmt.parseInt(u32, it.next() orelse @panic("could not get val for rect.y2"), 10) catch @panic("unable to parse rect.y2");
    }
    return i;
}

const Instruction = struct {
    action: Action,
    rect: Rect,
};

const Action = enum { on, off, toggle };

const Rect = struct {
    x1: u32,
    y1: u32,
    x2: u32,
    y2: u32,
};

const Grid = struct {
    width: u32,
    height: u32,

    grid: []u64,

    /// Caller must free the .grid field after use.
    pub fn init(allocator: std.mem.Allocator, w: u32, h: u32) !Grid {
        const g = Grid{
            .width = w,
            .height = h,
            .grid = try allocator.alloc(u64, w * h),
        };
        std.mem.set(u64, g.grid, 0);
        return g;
    }

    pub fn changeRect(self: Grid, rect: Rect, act: Action) void {
        var ym = rect.y1;
        while (ym <= rect.y2) : (ym += 1) {
            var xm = rect.x1;
            while (xm <= rect.x2) : (xm += 1) {
                switch (act) {
                    .on => self.grid[xm + (ym * self.width)] += 1,
                    .toggle => self.grid[xm + (ym * self.width)] += 2,
                    .off => {
                        if (self.grid[xm + (ym * self.width)] < 1) {
                            self.grid[xm + (ym * self.width)] = 0;
                        } else {
                            //std.log.debug("val at pos {},{} is {}", .{ xm, ym, self.grid[xm + (ym * self.width)] });
                            self.grid[xm + (ym * self.width)] -= 1;
                        }
                    },
                }
            }
        }
    }

    pub fn turnOnRect(self: Grid, rect: Rect) void {
        var ym = rect.y1;
        while (ym <= rect.y2) : (ym += 1) {
            var xm = rect.x1;
            while (xm <= rect.x2) : (xm += 1) {
                self.grid[xm + (ym * self.width)] = 1;
            }
        }
    }

    pub fn turnOffRect(self: Grid, rect: Rect) void {
        var ym = rect.y1;
        while (ym <= rect.y2) : (ym += 1) {
            var xm = rect.x1;
            while (xm <= rect.x2) : (xm += 1) {
                self.grid[xm + (ym * self.width)] = 0;
            }
        }
    }

    pub fn toggle(self: Grid, x: u32, y: u32) void {
        self.grid[x + (y * self.width)] = if (self.grid[x + (y * self.width)] == 0) 1 else 0;
    }

    pub fn toggleRect(self: Grid, rect: Rect) void {
        var ym = rect.y1;
        while (ym <= rect.y2) : (ym += 1) {
            var xm = rect.x1;
            while (xm <= rect.x2) : (xm += 1) {
                self.grid[xm + (ym * self.width)] = if (self.grid[xm + (ym * self.width)] == 0) 1 else 0;
            }
        }
    }

    pub fn count(self: Grid) u32 {
        var res: u32 = 0;
        for (self.grid) |cell| {
            if (cell == 1) {
                res += 1;
            }
        }
        return res;
    }

    pub fn sum(self: Grid) u64 {
        var res: u64 = 0;
        for (self.grid) |cell| {
            res += cell;
        }
        return res;
    }
};

test "part1 tests" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    const tests = [_]TestCase(u32){
        newTest(u32, 998996,
            \\turn on 0,0 through 999,999
            \\toggle 0,0 through 999,0
            \\turn off 499,499 through 500,500
        ),
    };

    for (tests) |tc| {
        var g = try Grid.init(allocator, 1000, 1000);
        defer allocator.free(g.grid);

        var it = std.mem.tokenize(u8, tc.data, "\n");
        while (it.next()) |line| {
            const instr = parseLine(line);
            //std.log.warn("{any}", .{instr});

            switch (instr.action) {
                .on => g.turnOnRect(instr.rect),
                .off => g.turnOffRect(instr.rect),
                .toggle => g.toggleRect(instr.rect),
            }
        }

        try expectEqual(tc.expected, g.count());
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
