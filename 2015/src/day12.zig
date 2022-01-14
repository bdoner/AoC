const std = @import("std");
const json = std.json;
const aocTest = @import("helpers/testcase.zig");

const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day12.txt");

pub fn part1() !void {
    var res: isize = 0;
    var it = std.mem.tokenize(u8, input, ",:[]{} ");
    while (it.next()) |t| {
        const pi = std.fmt.parseInt(isize, t, 10) catch continue;
        res += pi;
    }
    std.debug.print("Part1: Sum of book is {d}\n", .{res});
}

pub fn part2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var JsonParser = std.json.Parser.init(allocator, false);
    defer JsonParser.deinit();

    var valueTree = try JsonParser.parse(input);
    defer valueTree.deinit();

    var res: isize = 0;
    const treeRoot = valueTree.root;
    traverse(treeRoot, &res);

    std.debug.print("Part2: Sum of (correct) book is {d}\n", .{res});
}

fn traverse(value: std.json.Value, sum: *isize) void {
    switch (value) {
        std.json.Value.Object => {
            for (value.Object.values()) |v| {
                switch (v) {
                    std.json.Value.String => {
                        if (std.mem.eql(u8, "red", v.String)) {
                            return;
                        }
                    },
                    else => {},
                }
            }
            for (value.Object.values()) |v| {
                traverse(v, sum);
            }
        },
        std.json.Value.Array => {
            for (value.Array.items) |v| {
                traverse(v, sum);
            }
        },
        std.json.Value.Integer => {
            sum.* += value.Integer;
        },
        // TODO: Skip primitives
        else => {},
    }
}

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

    const tests = [_]aocTest.TestCase(isize){
        aocTest.newTest(isize, 6, 
            \\[1,2,3]
        ),
        aocTest.newTest(isize, 4,
            \\[1,{"c":"red","b":2},3]
        ),
        aocTest.newTest(isize, 0,
            \\{"d":"red","e":[1,2,3,4],"f":5}
        ),
        aocTest.newTest(isize, 6,
            \\[1,"red",5]
        ),
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    for (tests) |tc| {
        var JsonParser = std.json.Parser.init(allocator, false);
        defer JsonParser.deinit();
        var valueTree = try JsonParser.parse(tc.data);
        defer valueTree.deinit();

        var res: isize = 0;
        const treeRoot = valueTree.root;

        traverse(treeRoot, &res);
        try expectEqual(tc.expected, res);
    }
}
