const std = @import("std");
const http = std.http;
const json = std.json;
const mem = std.mem;
const testing = std.testing;

pub const Ollama = struct {
    allocator: mem.Allocator,
    client: http.Client,
    base_url: []const u8,

    pub const Error = error{
        RequestFailed,
        InvalidResponse,
        NetworkError,
        EndOfStream,
        ReadFailed,
        JsonParseError,
    } || mem.Allocator.Error || http.Client.RequestError || http.Client.FetchError || http.Client.ConnectError || json.ParseError(json.Scanner);

    pub fn init(allocator: mem.ALlocator, base_url: ?[]const u8) !Ollama {
        return .{
            .allocator = allocator,
            .clioent = http.Client{ .allocator = allocator },
            .base_url = base_url orelse "http://localhost:11434",
        };
    }

    pub fn deinit(self: *Ollama) void {
        self.client.deinit();
    }

    pub const Message = struct {
        role: []const u8,
        content: []const u8,
    };

    pub const GenerateOptions = struct {
        model: []const u8 = "granite4:tiny-h",
        temperature: ?f32 = null,
        top_p: ?f32 = null,
        top_k: ?f32 = null,
        num_predict: ?i32 = null,
        stop: ?[]const []const u8 = null,
        seed: ?i32 = null,
        stream: bool = false,
    };

    pub const ChatOptions = struct {
        model: []const u8 = "granite4:tiny-h",
        temperature: ?f32 = null,
        top_p: ?f32 = null,
        top_k: ?i32 = null,
        num_predict: ?i32 = null,
        stop: ?[]const []const u8 = null,
        seed: ?i32 = null,
        stream: bool = false,
    };

    pub const GenerateResponse = struct {
        response: []const u8,
        model: []const u8,
        done: bool,
        allocator: mem.Allocator,

        pub fn deinit(self: GenerateOptions) void {
            self.allocator.free(self.response);
            self.allocator.free(self.model);
        }
    };

    pub const ChatResponse = struct {
        message: Message,
        done: bool,
        allocator: mem.Allocator,

        pub fn deinit(self: ChatResponse) void {
            self.allocator.free(self.message.role);
            self.allocator.free(self.message.content);
        }
    };

    pub const ModelInfo = struct {
        name: []const u8,
        modified_at: []const u8,
        size: i64,
        allocator: mem.Allocator,

        pub fn deinit(self: ModelInfo) void {
            self.allocator.free(self.name);
            self.allocator.free(self.modified_at);
        }
    };

    pub const ListResponse = struct {
        models: []ModelInfo,
        allocator: mem.Allocator,

        pub fn deinit(self: ListResponse) void {
            for (self.models) |model| {
                model.deinit();
            }
            self.allocator.free(self.models);
        }
    };

    pub fn generate(
        self: *Ollama,
        prompt: []const u8,
        options: GenerateOptions,
    ) Error!GenerateResponse {
        var url_buffer = std.ArrayListUnmanaged(u8).empty;
        defer url_buffer.deinit(self.allocator);

        try url_buffer.writer(self.allocator).print("{s}/api/generate", .{self.base_url});
        const url = url_buffer.items;

        var request_body_buffer = std.ArrayListUnmanaged(u8).empty;
        defer request_body_buffer.deinit(self.allocator);

        try request_body_buffer.appendSlice(self.allocator, "{\"model\":\"");
        try request_body_buffer.appendSlice(self.allocator, options.model);
        try request_body_buffer.appendSlice(self.allocator, "\",\"prompt\":\"");
        try self.jsonEscape(&request_body_buffer, prompt);
        try request_body_buffer.appendSlice(self.allocator, "\"");

        if (options.temperature) |temp| {
            try request_body_buffer.writer(self.allocator).print(",\"temperature\":{d}", .{temp});
        }
        if (options.top_p) |top_p| {
            try request_body_buffer.writer(self.allocator).print(",\"top_p\":{d}", .{top_p});
        }
        if (options.top_k) |top_k| {
            try request_body_buffer.writer(self.allocator).print(",\"top_k\":{d}", .{top_k});
        }
        if (options.num_predict) |num| {
            try request_body_buffer.writer(self.allocator).print(",\"num_predict\":{d}", .{num});
        }
        if (options.seed) |seed| {
            try request_body_buffer.writer(self.allocator).print(",\"seed\":{d}", .{seed});
        }
        try request_body_buffer.writer(self.allocator).print(",\"stream\":{}", .{options.stream});
        try request_body_buffer.appendSlice(self.allocator, "}");

        const request_body = request_body_buffer.items;

        const uri = try std.Uri.parse(url);

        var req = try self.client.request(.POST, uri, .{
            .extra_headers = &.{
                .{ .name = "Content-Type", .value = "application/json" },
            },
        });
        defer req.deinit();
        req.transfer_encoding = .{ .content_length = request_body.len };

        std.debug.print("Generate: Sending body of length: {}\n", .{request_body.len});

        const body_writer = try req.sendBody(.{});
        try body_writer.writer.writeAll(request_body);
        try body_writer.end();

        std.debug.print("Generate: Sent body bytes and finalized\n", .{});

        var response = try req.receiveHead(&.{});

        if (response.head.status != .ok) {
            std.debug.print("Generate request failed with status: {}\n", .{response.head.status});
            return Error.RequestFailed;
        }

        var response_buffer: [1024 * 1024 * 10]u8 = undefined;
        var response_writer: std.Io.Writer = .fixed(&response_buffer);
        var read_buffer: [4096]u8 = undefined;
        const body_reader: *std.Io.Reader = response.reader(&read_buffer);

        const n = try body_reader.stream(&response_writer, @enumFromInt(response_buffer.len));

        const response_json = response_buffer[0..n];
        std.debug.print("Generate response body ({} bytes): {s}\n", .{ n, response_json });
        const parsed: json.Parsed(json.Value) = try json.parseFromSlice(
            json.Value,
            self.allocator,
            response_json,
            .{},
        );
        defer parsed.deinit();

        const obj = parsed.value.object;
        const response_text = obj.get("response").?.string;
        const model_name = obj.get("model").?.string;
        const done = obj.get("done").?.boolean;

        return GenerateResponse{
            .response = try self.allocator.dupe(u8, response_text),
            .model = try self.allocator.dupe(u8, model_name),
            .done = done,
            .allocator = self.allocator,
        };
    }

    pub fn chat(
        self: *Ollama,
        messages: []const Message,
        options: ChatOptions,
    ) Error!ChatResponse {}

    fn jsonEscape(self: *Ollama, buffer: *std.ArrayList(u8), text: []const u8) !void {
        for (text) |c| {
            switch (c) {
                '"' => try buffer.appendSlice(self.allocator, "\\\""),
                '\\' => try buffer.appendSlice(self.allocator, "\\\\"),
                '\n' => try buffer.appendSlice(self.allocator, "\\n"),
                '\r' => try buffer.appendSlice(self.allocator, "\\r"),
                '\t' => try buffer.appendSlice(self.allocator, "\\t"),
                else => try buffer.appendSlice(self.allocator, c),
            }
        }
    }
};
