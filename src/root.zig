const std = @import("std");
const testing = std.testing;

/// Root module for the lcz library
/// This module can be imported by other Zig projects

// Export sub-modules
pub const CLI = @import("cli.zig").CLI;
pub const Config = @import("config.zig").Config;
pub const LlamaContext = @import("llama.zig").LlamaContext;

/// Represents a basic agent structure
pub const Agent = struct {
    name: []const u8,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, name: []const u8) !Agent {
        return Agent{
            .name = name,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Agent) void {
        _ = self;
        // Cleanup resources if needed
    }

    pub fn execute(self: *Agent) !void {
        std.debug.print("Agent '{s}' executing...\n", .{self.name});
    }
};

/// Utility function to greet
pub fn greet(name: []const u8) !void {
    std.debug.print("Hello, {s}!\n", .{name});
}

// Tests
test "Agent init and execute" {
    const allocator = testing.allocator;
    var agent = try Agent.init(allocator, "test-agent");
    defer agent.deinit();

    try testing.expectEqualStrings("test-agent", agent.name);
}

test "greet function" {
    try greet("Zig");
}

// Import all sub-module tests
test {
    @import("std").testing.refAllDecls(@This());
}

