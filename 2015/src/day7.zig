const std = @import("std");
const meta = std.meta;
const newTest = @import("utils.zig").newTest;
const TestCase = @import("utils.zig").TestCase;
const expectEqual = std.testing.expectEqual;

const input = @embedFile("input/day7.txt");

pub fn part1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var nodes = std.StringHashMap(Node).init(allocator);
    defer nodes.deinit();
    // defer {
    //     var nk = nodes.keyIterator();
    //     while (nk.next()) |k| {
    //         allocator.free(k.*);
    //     }
    //     nodes.deinit();
    // }

    var i: usize = 0;
    var it = std.mem.tokenize(u8, input, "\n");
    while (it.next()) |line| : (i += 1) {
        const n = try parseNode(line);
        try nodes.put(n.name, n);
    }

    const res: u16 = try getNodeValue(nodes.getPtr("a").?, &nodes);

    var nit = nodes.iterator();
    while (nit.next()) |n| {
        std.log.warn("{s}: {d} ({s} {s} {s})", .{ n.key_ptr.*, n.value_ptr.value, n.value_ptr.left, n.value_ptr.op, n.value_ptr.right });
    }

    std.log.info("Part1: Result is {}", .{res});
}

pub fn part2() void {
    std.log.info("Part2: Result is {}", .{0});
}

fn getNodeValue(node: *Node, nodes: *std.StringHashMap(Node)) std.fmt.ParseIntError!u16 {
    if (node.value) |v| {
        return v;
    }

    var lVal: u16 = 0;
    if (node.left) |ln| {
        const lNode = nodes.getPtr(ln);

        if (lNode) |n| {
            lVal = try getNodeValue(n, nodes);
        } else {
            lVal = try std.fmt.parseInt(u16, ln, 10);
        }
    }

    var rVal: u16 = 0;
    if (node.right) |rn| {
        const rNode = nodes.getPtr(rn);

        if (rNode) |n| {
            rVal = try getNodeValue(n, nodes);
        } else {
            rVal = try std.fmt.parseInt(u16, rn, 10);
        }
    }

    switch (node.op) {
        .AND => {
            node.*.value = rVal & rVal;
            return node.*.value.?;
        },
        .OR => {
            node.*.value = lVal | rVal;
            return node.*.value.?;
        },
        .RSHIFT => {
            node.*.value = lVal >> @truncate(u4, rVal);
            return node.*.value.?;
        },
        .LSHIFT => {
            node.*.value = lVal << @truncate(u4, rVal);
            return node.*.value.?;
        },
        .NOT => {
            node.*.value = ~rVal;
            return node.*.value.?;
        },
        // special cases
        .input => {
            return node.*.value.?;
        },
        .assign => {
            node.*.value = lVal;
            return node.*.value.?;
        },
    }

    @panic("Why are you here?!");
}

fn parseNode(line: []const u8) !Node {
    var n = Node{ .left = null, .right = null, .name = "", .value = null, .op = Operation.assign };

    var it = std.mem.tokenize(u8, line, " ");
    const tok = it.next() orelse @panic("Could not tokenize line");

    // Case for prefix op, NOT.
    if (std.mem.eql(u8, "NOT", tok)) {
        n.op = Operation.NOT;
        n.right = it.next();
        _ = it.next(); // skip the ->
        n.name = it.next() orelse @panic("no out wire found for NOT op");

        return n;
    }

    // The rest
    n.left = tok;
    const ops = it.next() orelse @panic("no op found");
    if (std.mem.eql(u8, "->", ops)) {
        n.op = Operation.assign;
        n.name = it.next() orelse @panic("no out wire found for assign op");

        // Case for a number
        var inputRawValue = std.fmt.parseInt(u16, n.left.?, 10) catch null;
        if (inputRawValue) |inp| {
            n.value = inp;
            n.op = Operation.input;
        }
    } else {
        n.op = meta.stringToEnum(Operation, ops) orelse @panic("Unknown operator");
        n.right = it.next();
        _ = it.next(); // skip the ->
        n.name = it.next() orelse @panic("no out wire found for op");
    }

    return n;
}

const Node = struct {
    left: ?[]const u8,
    right: ?[]const u8,
    name: []const u8,
    value: ?u16,
    op: Operation,
};

const Operation = enum {
    AND,
    OR,
    RSHIFT,
    LSHIFT,
    NOT,

    // special cases
    input,
    assign,
};

test "part1 tests" {
    const tests = [_]TestCase(u32){
        newTest(u32, 65079, // wire i
            \\123 -> x
            \\456 -> y
            \\x AND y -> d
            \\x OR y -> e
            \\x LSHIFT 2 -> f
            \\y RSHIFT 2 -> g
            \\NOT x -> h
            \\NOT y -> i
        ),
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    var nodes = std.StringHashMap(Node).init(allocator);
    defer {
        var nk = nodes.keyIterator();
        while (nk.next()) |k| {
            allocator.free(k.*);
        }
        nodes.deinit();
    }

    std.log.warn("", .{});
    for (tests) |tc| {
        var it = std.mem.tokenize(u8, tc.data, "\n");
        while (it.next()) |line| {
            const n = try parseNode(line);
            try nodes.put(n.name, n);
        }
        const res: u16 = try getNodeValue(nodes.getPtr("i").?, &nodes);

        var nit = nodes.iterator();
        while (nit.next()) |n| {
            std.log.warn("{s}: {d} ({s} {s} {s})", .{ n.key_ptr.*, n.value_ptr.value, n.value_ptr.left, n.value_ptr.op, n.value_ptr.right });

            std.log.info("Part1: Result is {}", .{res});
        }
        try expectEqual(tc.expected, nodes.get("i").?.value.?);
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
