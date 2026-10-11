const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const input = std.fs.File.stdin().readToEndAlloc(allocator, 1024 * 1024) catch return;
    const parsed = std.json.parseFromSlice(std.json.Value, allocator, input, .{}) catch return;
    defer parsed.deinit();

    if (parsed.value != .object) return;
    const tool_input = parsed.value.object.get("tool_input") orelse return;
    if (tool_input != .object) return;
    const command = tool_input.object.get("command") orelse return;
    if (command != .string) return;

    if (isDestructive(command.string)) {
        std.debug.print("Blocked by codex-guard-destructive: matched dangerous pattern\n", .{});
        std.process.exit(2);
    }
}

fn isDestructive(command: []const u8) bool {
    var segments = std.mem.tokenizeAny(u8, command, ";|&\n");
    while (segments.next()) |segment| {
        if (segmentIsDestructive(segment)) return true;
    }
    return false;
}

fn segmentIsDestructive(segment: []const u8) bool {
    const dangerous_targets = [_][]const u8{ "/", "/*", "~", "~/", "$HOME", "$HOME/", "${HOME}" };

    var tokens = std.mem.tokenizeAny(u8, segment, " \t\"'()");
    var after_rm = false;
    var after_dd = false;

    while (tokens.next()) |token| {
        const name = std.fs.path.basename(token);

        if (std.mem.eql(u8, name, "rm")) {
            after_rm = true;
            continue;
        }
        if (std.mem.eql(u8, name, "dd")) {
            after_dd = true;
            continue;
        }
        if (std.mem.startsWith(u8, name, "mkfs")) return true;

        if (after_dd and std.mem.startsWith(u8, token, "of=/dev/")) return true;

        if (after_rm) {
            for (dangerous_targets) |target| {
                if (std.mem.eql(u8, token, target)) return true;
            }
        }
    }
    return false;
}
