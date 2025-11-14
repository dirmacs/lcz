# API Documentation

## Core Modules

### Agent

The Agent struct represents an autonomous agent capable of executing tasks.

```zig
const Agent = struct {
    name: []const u8,
    allocator: std.mem.Allocator,
};
```

#### Methods

**`init(allocator: std.mem.Allocator, name: []const u8) !Agent`**
- Creates a new agent with the given name
- Parameters:
  - `allocator`: Memory allocator for the agent
  - `name`: Name of the agent
- Returns: New Agent instance

**`deinit(self: *Agent) void`**
- Cleans up agent resources

**`execute(self: *Agent) !void`**
- Executes the agent's task

### CLI

Command-line interface parser and handler.

```zig
const CLI = struct {
    allocator: std.mem.Allocator,
    help: bool = false,
    version: bool = false,
    verbose: bool = false,
};
```

#### Methods

**`init(allocator: std.mem.Allocator) CLI`**
- Creates a new CLI instance

**`parseArgs(self: *CLI, args: []const []const u8) !void`**
- Parses command-line arguments

**`showHelp(self: *CLI) !void`**
- Displays help information

**`showVersion(self: *CLI) !void`**
- Displays version information

### Config

Application configuration management.

```zig
const Config = struct {
    allocator: std.mem.Allocator,
    model_path: ?[]const u8 = null,
    max_tokens: u32 = 2048,
    temperature: f32 = 0.7,
    debug: bool = false,
};
```

#### Methods

**`init(allocator: std.mem.Allocator) Config`**
- Creates a new configuration instance

**`deinit(self: *Config) void`**
- Cleans up configuration resources

**`setModelPath(self: *Config, path: []const u8) !void`**
- Sets the model file path

**`loadFromFile(self: *Config, path: []const u8) !void`**
- Loads configuration from a file (not yet implemented)

**`saveToFile(self: *Config, path: []const u8) !void`**
- Saves configuration to a file (not yet implemented)

### LlamaContext

Integration with llama.cpp for LLM inference.

```zig
const LlamaContext = struct {
    allocator: std.mem.Allocator,
    model_path: []const u8,
    initialized: bool = false,
};
```

#### Methods

**`init(allocator: std.mem.Allocator, model_path: []const u8) !LlamaContext`**
- Creates a new llama context
- Parameters:
  - `allocator`: Memory allocator
  - `model_path`: Path to the GGUF model file

**`deinit(self: *LlamaContext) void`**
- Cleans up llama context resources

**`load(self: *LlamaContext) !void`**
- Loads the model (placeholder implementation)

**`complete(self: *LlamaContext, prompt: []const u8) ![]const u8`**
- Generates text completion for the given prompt
- Returns: Allocated string with the completion

## Utility Functions

**`greet(name: []const u8) !void`**
- Simple greeting utility function
- Prints a greeting message to debug output
