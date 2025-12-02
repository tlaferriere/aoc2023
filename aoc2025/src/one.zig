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
    var sum: u32 = 0;
    const stdout = std.io.getStdOut().writer();

    lines: while (line: {
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
        // Example:
        //Game 31: 10 green, 9 blue; 5 green, 9 blue, 1 red; 1 red, 8 blue
        // Split the game id from it's content
        var iter = std.mem.splitScalar(u8, line, ':');
        // Read game id
        const game_id_offset: usize = 5; // The string "Game " is 5 characters long, so the first digit of the id is at index 5
        const game_id = try std.fmt.parseUnsigned(u32, iter.next().?[game_id_offset..], 10);
        const game_content = iter.next().?;
        var cube_sets = std.mem.splitScalar(u8, game_content, ';');
        while (cube_sets.next()) |cube_set| {
            var cube_counts = std.mem.splitScalar(u8, cube_set, ',');
            while (cube_counts.next()) |cube_count| {
                var tokens = std.mem.tokenizeScalar(u8, cube_count, ' ');
                const count = try std.fmt.parseUnsigned(u32, tokens.next().?, 10);
                const color = tokens.next().?;
                if ((count > MAX_RED and std.mem.eql(u8, color, "red")) or (count > MAX_GREEN and std.mem.eql(u8, color, "green")) or (count > MAX_BLUE and std.mem.eql(u8, color, "blue"))) {
                    continue :lines;
                }
            }
        }
        sum += game_id;
    }

    try stdout.print("{d}\n", .{sum});
}
