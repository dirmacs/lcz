# Getting Started with lcz

## Installation

### Prerequisites

- Zig 0.15.2 or later ([download here](https://ziglang.org/download/))
- Git

### Clone the Repository

```bash
git clone https://github.com/dirmacs/lcz.git
cd lcz
```

## Quick Start

### Build the Project

```bash
zig build
```

Or using make:
```bash
make build
```

### Run the Application

```bash
zig build run
```

Or:
```bash
./zig-out/bin/lcz
```

### Run Tests

```bash
zig build test
```

Or:
```bash
make test
```

## Basic Usage

### Display Help

```bash
lcz --help
```

### Show Version

```bash
lcz --version
```

### Verbose Mode

```bash
lcz --verbose
```

## Development Workflow

### 1. Make Changes

Edit source files in the `src/` directory.

### 2. Format Code

```bash
zig fmt src/
```

Or:
```bash
make fmt
```

### 3. Build and Test

```bash
zig build test
```

### 4. Run Your Changes

```bash
zig build run
```

## Project Structure

```
lcz/
├── src/               # Source code
│   ├── main.zig      # Entry point
│   ├── root.zig      # Library root
│   ├── cli.zig       # CLI handling
│   ├── config.zig    # Configuration
│   └── llama.zig     # Llama integration
├── examples/         # Example programs
├── docs/            # Documentation
├── build.zig        # Build configuration
└── build.zig.zon    # Dependencies
```

## Next Steps

- Read the [Architecture](architecture.md) documentation
- Check out the [API Documentation](api.md)
- Explore the [Examples](../examples/)
- Contribute! See [CONTRIBUTING.md](../CONTRIBUTING.md)

## Common Issues

### Zig not found

Make sure Zig is installed and in your PATH:
```bash
zig version
```

### Build errors

Clean the build cache:
```bash
make clean
zig build
```

## Getting Help

- Check the [documentation](../docs/)
- Open an [issue](https://github.com/dirmacs/lcz/issues)
- Review [existing issues](https://github.com/dirmacs/lcz/issues)
