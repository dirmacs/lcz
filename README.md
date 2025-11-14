# lcz

Zig-based, llama.cpp powered, agentic CLI application

## Quick Start

### Automated Setup

Run the setup script to get started quickly:

```bash
./setup.sh
```

This will guide you through installing Zig (if needed) and building the project.

### Manual Setup

## Requirements

- Zig 0.15.2 or later ([download here](https://ziglang.org/download/))

## Installation

1. Install Zig 0.15.2 or later
2. Clone the repository:
   ```bash
   git clone https://github.com/dirmacs/lcz.git
   cd lcz
   ```
3. Build the project:
   ```bash
   zig build
   ```

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

To validate the entire project setup:

```bash
./validate.sh
```

## Project Structure

```
lcz/
├── build.zig           # Build configuration
├── build.zig.zon       # Package dependencies
├── src/                # Source code
│   ├── main.zig        # CLI entry point
│   ├── root.zig        # Library root module
│   ├── cli.zig         # Command-line parsing
│   ├── config.zig      # Configuration management
│   └── llama.zig       # llama.cpp integration
├── docs/               # Documentation
├── examples/           # Example programs
├── test/               # Test files
├── .github/            # GitHub Actions workflows
├── .gitignore
├── LICENSE
└── README.md
```

## Development

### Quick Commands

Using Make:
```bash
make build      # Build the project
make run        # Run the application
make test       # Run tests
make fmt        # Format code
make clean      # Clean build artifacts
```

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

### Code Formatting

Format your code before committing:

```bash
zig fmt src/
zig fmt build.zig
```

Or use make:
```bash
make fmt
```

## Documentation

- [Getting Started](docs/getting-started.md) - Detailed setup and usage guide
- [Architecture](docs/architecture.md) - Project architecture overview
- [API Documentation](docs/api.md) - API reference
- [Examples](examples/) - Example programs

## Features

### Current
- ✅ CLI argument parsing
- ✅ Configuration management
- ✅ Basic agent structure
- ✅ Comprehensive test suite

### Planned
- [ ] llama.cpp integration
- [ ] Agentic capabilities
- [ ] Interactive mode
- [ ] Streaming output

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

See LICENSE file for details.
