const std = @import("std");
const aocTest = @import("helpers/testcase.zig");


const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day2.txt");

fn getBoxArea(l: u32, w: u32, h: u32) u32 {
    const lw = 2 * l * w;
    const wh = 2 * w * h;
    const hl = 2 * h * l;
    const extra = @minimum(@minimum(lw, hl), wh) / 2;

    //std.log.warn("lw: {}, hl: {}, wh: {}, ext: {}", .{lw,hl,wh,extra});

    return lw + hl + wh + extra;
}

fn getSmallestRibbonArea(l: u32, w: u32, h: u32) u32 {
    var items = [_]u32{ l, w, h };
    //std.log.warn("items before: {any}", .{items});
    std.sort.sort(u32, &items, {}, comptime std.sort.asc(u32));
    //std.log.warn("items after: {any}", .{items});

    return items[0]*2 + items[1]*2;
}

fn getBoxDims(line: []const u8) [3]u32 {
    var sizes = [3]u32{0,0,0};
    var sizeIndex: u8 = 0;
    var si = std.mem.split(u8, line, "x");
    while(si.next()) |n| {
        if (n.len == 0) continue;

        sizes[sizeIndex] = std.fmt.parseInt(u32, n, 10) catch @panic("could not parse input");
        sizeIndex += 1;
    }
    return sizes;
}

inline fn getBoxVol (l: u32, w: u32, h: u32) u32 {
    return l * w * h;
}

pub fn part1() void {
    var areaSum: u32 = 0;
    var si = std.mem.split(u8, input, "\n");
    while(si.next()) |gift| {
        var box = getBoxDims(gift);
        var area = getBoxArea(box[0], box[1], box[2]);

        areaSum += area;
    }

    std.log.info("Part1: The area of all the boxes is: {}", .{areaSum});
}

pub fn part2() void {
    var totalRibbonSum: u32 = 0;
    var si = std.mem.split(u8, input, "\n");
    while(si.next()) |gift| {
        //std.log.warn("tc: {any}", .{tc});
        var box = getBoxDims(gift);
        //std.log.warn("box: {any}", .{box});
        var area = getSmallestRibbonArea(box[0], box[1], box[2]);
        //std.log.warn("area: {any}", .{area});
        var boxVol = getBoxVol(box[0], box[1], box[2]);
        //std.log.warn("boxVol: {any}", .{boxVol});
        
        const totalRibbon = area + boxVol;
        totalRibbonSum += totalRibbon;
    }
    std.log.info("Part2: The needed ribbon for all the boxes is: {}", .{totalRibbonSum});
}

test "part1 tests" {
    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 58, "2x3x4"),
        aocTest.newTest(u32, 43, "1x1x10"),
    };

    for(tests) |tc| {
        //std.log.warn("tc: {any}", .{tc});
        var box = getBoxDims(tc.data);
        //std.log.warn("box: {any}", .{box});
        var area = getBoxArea(box[0], box[1], box[2]);
        //std.log.warn("area: {any}", .{area});
        
        try expectEqual(tc.expected, area);
    }
}

test "part2 tests" {
    const tests = [_]aocTest.TestCase(u32){
        aocTest.newTest(u32, 34, "2x3x4"),
        aocTest.newTest(u32, 14, "1x1x10"),
    };

    for(tests) |tc| {
        //std.log.warn("tc: {any}", .{tc});
        var box = getBoxDims(tc.data);
        //std.log.warn("box: {any}", .{box});
        var area = getSmallestRibbonArea(box[0], box[1], box[2]);
        //std.log.warn("area: {any}", .{area});
        var boxVol = getBoxVol(box[0], box[1], box[2]);
        //std.log.warn("boxVol: {any}", .{boxVol});
        
        const totalRibbon = area + boxVol;

        try expectEqual(tc.expected, totalRibbon);
    }
}