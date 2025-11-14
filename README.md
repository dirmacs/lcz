# lcz

Zig-based, llama.cpp powered, agentic CLI application

## Requirements

- Zig 0.13.0 or later

## Building

To build the project:

```bash
zig build
```

To run the application:

```bash
zig build run
```

To run with arguments:

```bash
zig build run -- --help
```

## Testing

To run all tests:

```bash
zig build test
```

## Project Structure

```
lcz/
├── build.zig           # Build configuration
├── build.zig.zon       # Package dependencies
├── src/
│   ├── main.zig        # CLI entry point
│   └── root.zig        # Library root module
├── .gitignore
├── LICENSE
└── README.md
```

## Development

### Building for Release

```bash
zig build -Doptimize=ReleaseFast
```

### Other Build Options

- `zig build -Doptimize=Debug` - Debug build (default)
- `zig build -Doptimize=ReleaseSafe` - Release with safety checks
- `zig build -Doptimize=ReleaseSmall` - Optimized for size

### Cross-Compilation

Zig supports easy cross-compilation. For example:

```bash
# Build for Windows
zig build -Dtarget=x86_64-windows

# Build for macOS
zig build -Dtarget=aarch64-macos

# Build for Linux ARM
zig build -Dtarget=aarch64-linux
```

## Features (Planned)

- [ ] llama.cpp integration
- [ ] Agentic capabilities
- [ ] CLI interface
- [ ] Configuration management

## License

See LICENSE file for details.
