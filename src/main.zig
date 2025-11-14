const std = @import("std");
const cli_mod = @import("cli.zig");

pub fn main() !void {
    // Setup allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Parse command line arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Create and parse CLI
    var cli = cli_mod.CLI.init(allocator);
    try cli.parseArgs(args);

    // Handle commands
    if (cli.help) {
        try cli.showHelp();
        return;
    }

    if (cli.version) {
        try cli.showVersion();
        return;
    }

    // Default behavior - show welcome message
    const stdout = std.io.getStdOut().writer();
    try stdout.print("lcz - Zig-based, llama.cpp powered, agentic CLI application\n", .{});
    try stdout.print("Version: 0.1.0\n\n", .{});
    
    if (cli.verbose) {
        try stdout.print("[VERBOSE] Running in verbose mode\n", .{});
    }
    
    try stdout.print("Run 'lcz --help' for more information.\n", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
