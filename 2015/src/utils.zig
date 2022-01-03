pub fn newTest(comptime T: type, expected: T, data: []const u8) TestCase(T) {
    return .{
        .expected = expected,
        .data = data,
    };
}

pub fn TestCase(comptime T: type) type {
    return struct {
        expected: T,
        data: []const u8,
    };
}

const std = @import("std");
const expectEqual = std.testing.expectEqual;
test "util tests" {
    const doSomething = struct {
        fn run (d: []const u8) u32 {
            return @intCast(u32, d.len);
        }
    };

    const tests = [_]TestCase(u32){
        newTest(u32, 6, "abcdef"),
        newTest(u32, 5, "abcde"),
    };

    for (tests) |tc| {
        var someRes: u32 = doSomething.run(tc.data);
        try expectEqual(tc.expected, someRes);
    }
}
