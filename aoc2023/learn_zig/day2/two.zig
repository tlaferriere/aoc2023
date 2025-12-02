const std = @import("std");

const MAX_RED = 12;
const MAX_GREEN = 13;
const MAX_BLUE = 14;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [256]u8 = undefined;
    var sum: u64 = 0;
    const stdout = std.io.getStdOut().writer();

    while (line: {
        var fixed_buf = std.io.fixedBufferStream(&buf);
        if (in_stream.streamUntilDelimiter(fixed_buf.writer(), '\n', buf.len)) {
            break :line fixed_buf.getWritten();
        } else |err| switch (err) {
            error.EndOfStream => {
                break :line null;
            },
            else => |leftover_err| return leftover_err,
        }
    }) |line| {
        // Split the game id from it's content
        var iter = std.mem.splitScalar(u8, line, ':');
        // Read game id
        _ = iter.next().?; // Discard game id
        const game_content = iter.next().?;
        var max_red: u64 = 0;
        var max_green: u64 = 0;
        var max_blue: u64 = 0;
        var cube_sets = std.mem.splitScalar(u8, game_content, ';');
        while (cube_sets.next()) |cube_set| {
            var cube_counts = std.mem.splitScalar(u8, cube_set, ',');
            while (cube_counts.next()) |cube_count| {
                var tokens = std.mem.tokenizeScalar(u8, cube_count, ' ');
                const count = try std.fmt.parseUnsigned(u64, tokens.next().?, 10);
                const color = tokens.next().?;
                if (count > max_red and std.mem.eql(u8, color, "red")) {
                    max_red = count;
                } else if (count > max_green and std.mem.eql(u8, color, "green")) {
                    max_green = count;
                } else if ((count > max_blue and std.mem.eql(u8, color, "blue"))) {
                    max_blue = count;
                }
            }
        }
        sum += max_red * max_blue * max_green;
    }

    try stdout.print("{d}\n", .{sum});
}
