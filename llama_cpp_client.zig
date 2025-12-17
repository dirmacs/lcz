const std = @import("std");

const LLMResponse = struct {
    id: []const u8,
    object: []const u8,
    created: u32,
    model: []const u8,
    usage: ?struct {
        prompt_tokens: u32,
        completion_tokens: u32,
        total_tokens: u32,
    } = null,
    timings: ?struct {
        prompt_p: u32,
        prompt_ms: f64,
        prompt_per_token_ms: f64,
        prompt_per_second: f64,
        predicted_n: u32,
        predicted_ms: f64,
        predicted_per_token_ms: f64,
        predicted_per_second: f64,
    } = null,
    choices: []struct {
        message: struct {
            role: []const u8,
            content: []const u8,
        },
        logprobs: ?struct {
            content: []struct {
                token: []const u8,
                logprob: f64,
                bytes: []const u8,
                top_logprobs: ?[]struct {
                    token: []const u8,
                    logprob: f64,
                },
            },
        } = null,
        finish_reason: []const u8,
        index: u32,
    },
    system_fingerprint: []const u8,
};

const Message = struct {
    role: []const u8,
    content: []const u8,
};

const RequestPayload = struct {
    model: []const u8,
    messages: []Message,
};

pub fn formatTemplate(allocator: std.mem.Allocator, template: []const u8, substitutions: []const []const u8) ![]u8 {
    var result = std.ArrayList(u8).empty;
    errdefer result.deinit(allocator);

    var index: usize = 0;
    var line_iter = std.mem.splitScalar(u8, template, "");
    while (line_iter.next()) |line| {
        var parts = std.mem.splitSequence(u8, line, "{s}");
        try result.writer().print("{s}", .{parts.next().?});

        while (parts.next()) |part| {
            if (index < substitutions.len) {
                try result.writer().print("{s}", .{substitutions[index]});
                index += 1;
            }
            try result.writer().print("{s}", .{part});
        }
        try result.writer().writeByte('\n');
    }
    _ = result.pop();

    return result.toOwnedSlice();
}

pub fn llmCall(allocator: std.mem.Allocator, system_prompt: []const u8, user_prompt: []const u8) !std.json.Parsed(LLMResponse) {
    var request_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer request_arena.deinit();

    const request_arena_allocator = request_arena.allocator();

    var client = std.http.Client{ .allocator = request_arena_allocator };
    var body = std.ArrayList(u8).empty;
    const uri = try std.Uri.parse("http://127.0.0.1:1337/v1/chat/completions");

    var messages = [_]Message{
        Message{ .role = "system", .content = system_prompt },
        Message{ .role = "user", .content = user_prompt },
    };
    const request_payload = RequestPayload{
        .model = "granite-4_0-h-350m-IQ4_XS",
        .messages = &messages,
    };

    const payload = try std.json.Stringify.valueAlloc(request_arena_allocator, request_payload, .{});
    std.debug.print("{s}\n", .{"=" ** 50});
    std.debug.print("Payload: {s}\n", .{payload});

    var req = try client.request(.POST, uri, .{
        .extra_headers = &.{
            .{ .name = "Content-Type", .value = "application/json" },
        },
    });
    defer req.deinit();

    req.transfer_encoding = .{ .content_length = payload.len };

    var body_writer = try req.sendBody(&.{});
    try body_writer.writer.writeAll(payload);
    try body_writer.end();

    var response = try req.receiveHead(&.{});
    const response_buffer = try request_arena_allocator.alloc(u8, 10 * 1024 * 1024);
    defer request_arena_allocator.free(response_buffer);
    var response_writer: std.Io.Writer = .fixed(response_buffer);
    var read_buffer: [4096]u8 = undefined;
    const body_reader: *std.Io.Reader = response.reader(&read_buffer);

    const n = try body_reader.streamRemaining(&response_writer);

    const response_json = response_buffer[0..n];
    std.debug.print("{s}\n", .{"=" ** 50});
    std.debug.print("Response status: {}\n", .{response.head.status});

    if (response.head.status != .ok) {
        std.debug.print("HTTP Error: {}\n", .{response.head.status});
        std.debug.print("Response body: {s}\n", .{body.items});
        std.debug.print("Error connecting to llama-server: {s}\n", .{body.items});
    }

    const parsed = try std.json.parseFromSlice(
        LLMResponse,
        allocator,
        body.items,
        .{
            .allocate = .alloc_always,
            .parse_numbers = true,
            .ignore_unknown_fields = true,
            .duplicate_field_behavior = .use_last,
        },
    );

    return parsed;
}
