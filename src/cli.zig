const std = @import("std");

/// Command-line interface configuration and parsing
pub const CLI = struct {
    allocator: std.mem.Allocator,
    help: bool = false,
    version: bool = false,
    verbose: bool = false,

    pub fn init(allocator: std.mem.Allocator) CLI {
        return CLI{
            .allocator = allocator,
        };
    }

    pub fn parseArgs(self: *CLI, args: []const []const u8) !void {
        for (args[1..]) |arg| {
            if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
                self.help = true;
            } else if (std.mem.eql(u8, arg, "--version") or std.mem.eql(u8, arg, "-v")) {
                self.version = true;
            } else if (std.mem.eql(u8, arg, "--verbose")) {
                self.verbose = true;
            }
        }
    }

    pub fn showHelp(self: *CLI) !void {
        _ = self;
        const stdout = std.io.getStdOut().writer();
        try stdout.print("lcz - Zig-based, llama.cpp powered, agentic CLI application\n\n", .{});
        try stdout.print("Usage: lcz [options]\n\n", .{});
        try stdout.print("Options:\n", .{});
        try stdout.print("  --help, -h     Show this help message\n", .{});
        try stdout.print("  --version, -v  Show version information\n", .{});
        try stdout.print("  --verbose      Enable verbose output\n", .{});
    }

    pub fn showVersion(self: *CLI) !void {
        _ = self;
        const stdout = std.io.getStdOut().writer();
        try stdout.print("lcz version 0.1.0\n", .{});
    }
};

test "CLI parsing" {
    const allocator = std.testing.allocator;
    var cli = CLI.init(allocator);

    const test_args = [_][]const u8{ "lcz", "--help", "--verbose" };
    try cli.parseArgs(&test_args);

    try std.testing.expect(cli.help);
    try std.testing.expect(cli.verbose);
    try std.testing.expect(!cli.version);
}
