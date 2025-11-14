# Contributing to lcz

Thank you for your interest in contributing to lcz!

## Development Setup

1. Install Zig 0.13.0 or later from [ziglang.org](https://ziglang.org/download/)
2. Clone the repository:
   ```bash
   git clone https://github.com/dirmacs/lcz.git
   cd lcz
   ```
3. Build the project:
   ```bash
   zig build
   ```

## Building and Testing

### Build
```bash
zig build
```

### Run
```bash
zig build run
```

### Test
```bash
zig build test
```

## Code Style

- Follow the Zig style guide
- Run `zig fmt` before committing:
  ```bash
  zig fmt src/
  zig fmt build.zig
  ```

## Project Structure

- `src/main.zig` - CLI application entry point
- `src/root.zig` - Library root module
- `src/cli.zig` - Command-line argument parsing
- `src/config.zig` - Configuration management
- `src/llama.zig` - llama.cpp integration (planned)
- `build.zig` - Build configuration
- `build.zig.zon` - Package dependencies

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`zig build test`)
5. Format your code (`zig fmt src/`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## Reporting Issues

When reporting issues, please include:
- Zig version (`zig version`)
- Operating system
- Steps to reproduce
- Expected behavior
- Actual behavior

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help make the community welcoming for everyone
