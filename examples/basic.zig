const std = @import("std");
const lcz = @import("lcz");

/// Example: Basic usage of the lcz library
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create an agent
    var agent = try lcz.Agent.init(allocator, "example-agent");
    defer agent.deinit();

    std.debug.print("Created agent: {s}\n", .{agent.name});
    try agent.execute();

    // Use the greet function
    try lcz.greet("World");
}
