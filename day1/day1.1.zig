const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sum: u32 = 0;
    const stdout = std.io.getStdOut().writer();
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var val: u32 = 0;
        for (line) |c| {
            if (std.ascii.isDigit(c)) {
                const b = [1]u8{c};
                val += try std.fmt.parseUnsigned(u32, &b, 10) * 10;
                break;
            }
        }

        var i: usize = line.len;
        while (i > 0) {
            i -= 1;
            var c = line[i];
            if (std.ascii.isDigit(c)) {
                const b = [1]u8{c};
                val += try std.fmt.parseUnsigned(u32, &b, 10);
                break;
            }
        }
        try stdout.print("{d}\n", .{val});
        sum += val;
    }

    try stdout.print("{d}\n", .{sum});
}
