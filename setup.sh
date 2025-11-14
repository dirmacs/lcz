#!/usr/bin/env bash

# Setup script for lcz Zig project
# Helps with initial project setup and Zig installation

set -e

echo "=== lcz Setup Script ==="
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
fi

echo "Detected OS: $OS"
echo ""

# Check if Zig is already installed
if command -v zig &> /dev/null; then
    ZIG_VERSION=$(zig version)
    echo "✓ Zig is already installed: $ZIG_VERSION"
    echo ""
    
    read -p "Do you want to continue with setup anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
else
    echo "Zig is not installed. Installation instructions:"
    echo ""
    
    case $OS in
        linux)
            echo "For Linux:"
            echo "  1. Download from: https://ziglang.org/download/"
            echo "  2. Extract: tar xf zig-linux-*.tar.xz"
            echo "  3. Add to PATH: export PATH=\$PATH:/path/to/zig"
            echo ""
            echo "Or use snap (if available):"
            echo "  sudo snap install zig --classic --beta"
            ;;
        macos)
            echo "For macOS:"
            echo "  1. Using Homebrew: brew install zig"
            echo "  2. Or download from: https://ziglang.org/download/"
            ;;
        windows)
            echo "For Windows:"
            echo "  1. Download from: https://ziglang.org/download/"
            echo "  2. Extract to C:\\zig"
            echo "  3. Add C:\\zig to your PATH"
            echo ""
            echo "Or use winget:"
            echo "  winget install -e --id zig.zig"
            ;;
        *)
            echo "Please visit: https://ziglang.org/download/"
            ;;
    esac
    
    echo ""
    read -p "Press Enter after installing Zig to continue..."
fi

echo ""
echo "Verifying Zig installation..."
if command -v zig &> /dev/null; then
    zig version
    echo "✓ Zig is ready!"
else
    echo "✗ Zig not found. Please install Zig and try again."
    exit 1
fi

echo ""
echo "Building the project..."
if zig build; then
    echo "✓ Build successful!"
else
    echo "✗ Build failed. Please check the error messages above."
    exit 1
fi

echo ""
echo "Running tests..."
if zig build test; then
    echo "✓ Tests passed!"
else
    echo "✗ Tests failed. Please check the error messages above."
    exit 1
fi

echo ""
echo "==================================="
echo "✓ Setup complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "  - Run the app: zig build run"
echo "  - Run with args: zig build run -- --help"
echo "  - Run tests: zig build test"
echo "  - Format code: zig fmt src/"
echo "  - Read docs: docs/getting-started.md"
echo ""
echo "Happy coding!"
