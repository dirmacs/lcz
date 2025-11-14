const std = @import("std");
const lcz = @import("lcz");

/// Example: Using configuration
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create and configure
    var config = lcz.Config.init(allocator);
    defer config.deinit();

    try config.setModelPath("/path/to/model.gguf");
    config.max_tokens = 4096;
    config.temperature = 0.8;
    config.debug = true;

    std.debug.print("Configuration:\n", .{});
    std.debug.print("  Model Path: {s}\n", .{config.model_path.?});
    std.debug.print("  Max Tokens: {d}\n", .{config.max_tokens});
    std.debug.print("  Temperature: {d}\n", .{config.temperature});
    std.debug.print("  Debug: {}\n", .{config.debug});
}
