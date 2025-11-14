.PHONY: build run test clean fmt help

# Default target
help:
	@echo "lcz - Zig-based CLI application"
	@echo ""
	@echo "Available targets:"
	@echo "  build       - Build the application"
	@echo "  run         - Run the application"
	@echo "  test        - Run tests"
	@echo "  fmt         - Format code"
	@echo "  clean       - Clean build artifacts"
	@echo "  help        - Show this help message"

# Build the application
build:
	zig build

# Run the application
run:
	zig build run

# Run tests
test:
	zig build test

# Format code
fmt:
	zig fmt src/
	zig fmt build.zig

# Clean build artifacts
clean:
	rm -rf zig-out .zig-cache

# Build for release
release:
	zig build -Doptimize=ReleaseFast
