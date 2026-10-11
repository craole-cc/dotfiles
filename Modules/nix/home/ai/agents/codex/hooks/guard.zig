const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.io.getStdIn().reader();
    const input = stdin.readAllAlloc(allocator, 1024 * 1024) catch return;
    defer allocator.free(input);

    var parsed = std.json.parseFromSlice(std.json.Value, allocator, input, .{}) catch return;
    defer parsed.deinit();

    const root = parsed.value;
    const tool_input = root.object.get("tool_input") orelse return;
    const cmd_val = tool_input.object.get("command") orelse return;
    if (cmd_val != .string) return;
    const cmd = cmd_val.string;

    if (isDestructive(cmd)) {
        std.debug.print("Blocked by codex-guard-destructive: matched dangerous pattern\n", .{});
        std.process.exit(2);
    }
}

fn isDestructive(cmd: []const u8) bool {
    if (containsRmDangerous(cmd)) return true;
    if (std.mem.indexOf(u8, cmd, "mkfs") != null) return true;
    if (std.mem.indexOf(u8, cmd, "dd") != null and std.mem.indexOf(u8, cmd, "of=/dev/") != null) return true;
    return false;
}

fn containsRmDangerous(cmd: []const u8) bool {
    var it = std.mem.splitScalar(u8, cmd, ' ');
    var found_rm = false;
    while (it.next()) |token| {
        if (!found_rm) {
            if (std.mem.eql(u8, token, "rm") or std.mem.startsWith(u8, token, "rm")) {
                found_rm = true;
            }
        } else {
            if (std.mem.eql(u8, token, "/") or
                std.mem.eql(u8, token, "~") or
                std.mem.eql(u8, token, "$HOME") or
                std.mem.eql(u8, token, "/*"))
            {
                return true;
            }
        }
    }
    return false;
}
