const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sum: u32 = 0;
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var number_map = std.StringHashMap(u32).init(arena.allocator());
    try number_map.put("one", 1);
    try number_map.put("two", 2);
    try number_map.put("three", 3);
    try number_map.put("four", 4);
    try number_map.put("five", 5);
    try number_map.put("six", 6);
    try number_map.put("seven", 7);
    try number_map.put("eight", 8);
    try number_map.put("nine", 9);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var val: u32 = 0;
        line: for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                const b = [1]u8{c};
                val += try std.fmt.parseUnsigned(u32, &b, 10) * 10;
                break;
            }
            for (2..5) |l| {
                if (i >= l) {
                    if (number_map.get(line[i - l .. i + 1])) |n| {
                        val += n * 10;
                        break :line;
                    }
                }
            }
        }

        var i: usize = line.len;
        line: while (i > 0) {
            i -= 1;
            var c = line[i];
            if (std.ascii.isDigit(c)) {
                const b = [1]u8{c};
                val += try std.fmt.parseUnsigned(u32, &b, 10);
                break;
            }
            for (3..6) |l| {
                if (line.len - i >= l) {
                    if (number_map.get(line[i .. i + l])) |n| {
                        val += n;
                        break :line;
                    }
                }
            }
        }
        // try stdout.print("{d}\n", .{val});
        sum += val;
    }

    try stdout.print("{d}\n", .{sum});
}
