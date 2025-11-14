const std = @import("std");

/// Application configuration
pub const Config = struct {
    allocator: std.mem.Allocator,
    model_path: ?[]const u8 = null,
    max_tokens: u32 = 2048,
    temperature: f32 = 0.7,
    debug: bool = false,

    pub fn init(allocator: std.mem.Allocator) Config {
        return Config{
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Config) void {
        if (self.model_path) |path| {
            self.allocator.free(path);
        }
    }

    /// Load configuration from a file (placeholder for future implementation)
    pub fn loadFromFile(self: *Config, path: []const u8) !void {
        _ = self;
        _ = path;
        // TODO: Implement configuration file loading
        return error.NotImplemented;
    }

    /// Save configuration to a file (placeholder for future implementation)
    pub fn saveToFile(self: *Config, path: []const u8) !void {
        _ = self;
        _ = path;
        // TODO: Implement configuration file saving
        return error.NotImplemented;
    }

    /// Set model path
    pub fn setModelPath(self: *Config, path: []const u8) !void {
        if (self.model_path) |old_path| {
            self.allocator.free(old_path);
        }
        self.model_path = try self.allocator.dupe(u8, path);
    }
};

test "Config init and defaults" {
    const allocator = std.testing.allocator;
    var config = Config.init(allocator);
    defer config.deinit();

    try std.testing.expect(config.model_path == null);
    try std.testing.expectEqual(@as(u32, 2048), config.max_tokens);
    try std.testing.expectEqual(@as(f32, 0.7), config.temperature);
    try std.testing.expect(!config.debug);
}

test "Config setModelPath" {
    const allocator = std.testing.allocator;
    var config = Config.init(allocator);
    defer config.deinit();

    try config.setModelPath("/path/to/model.gguf");
    try std.testing.expect(config.model_path != null);
    try std.testing.expectEqualStrings("/path/to/model.gguf", config.model_path.?);
}
