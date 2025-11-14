#!/usr/bin/env bash

# Validation script for lcz Zig project
# This script validates the project setup and build system

set -e

echo "=== lcz Project Validation ==="
echo ""

# Check if Zig is installed
echo "1. Checking Zig installation..."
if command -v zig &> /dev/null; then
    ZIG_VERSION=$(zig version)
    echo "   ✓ Zig is installed: $ZIG_VERSION"
    
    # Check minimum version (0.13.0)
    REQUIRED_VERSION="0.13.0"
    if [[ "$ZIG_VERSION" < "$REQUIRED_VERSION" ]]; then
        echo "   ⚠ Warning: Zig $REQUIRED_VERSION or later is recommended"
        echo "   Current version: $ZIG_VERSION"
    fi
else
    echo "   ✗ Zig is not installed"
    echo "   Please install Zig from: https://ziglang.org/download/"
    exit 1
fi

echo ""

# Check project structure
echo "2. Checking project structure..."
REQUIRED_FILES=(
    "build.zig"
    "build.zig.zon"
    "src/main.zig"
    "src/root.zig"
    "src/cli.zig"
    "src/config.zig"
    "src/llama.zig"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file exists"
    else
        echo "   ✗ $file is missing"
        exit 1
    fi
done

echo ""

# Format check
echo "3. Checking code formatting..."
if zig fmt --check src/ build.zig 2>/dev/null; then
    echo "   ✓ Code is properly formatted"
else
    echo "   ⚠ Code needs formatting. Run: zig fmt src/ build.zig"
fi

echo ""

# Build project
echo "4. Building project..."
if zig build 2>&1 | tail -5; then
    echo "   ✓ Build successful"
else
    echo "   ✗ Build failed"
    exit 1
fi

echo ""

# Run tests
echo "5. Running tests..."
if zig build test 2>&1 | tail -10; then
    echo "   ✓ All tests passed"
else
    echo "   ✗ Tests failed"
    exit 1
fi

echo ""

# Check if executable exists
echo "6. Checking executable..."
if [ -f "zig-out/bin/lcz" ]; then
    echo "   ✓ Executable created: zig-out/bin/lcz"
    
    # Try to run it with --version
    echo ""
    echo "7. Running executable..."
    if ./zig-out/bin/lcz --version; then
        echo "   ✓ Executable runs successfully"
    else
        echo "   ✗ Executable failed to run"
        exit 1
    fi
else
    echo "   ✗ Executable not found"
    exit 1
fi

echo ""
echo "==================================="
echo "✓ All validations passed!"
echo "==================================="
echo ""
echo "Project is ready for development!"
echo "Run 'zig build run' to start the application"
echo "Run 'zig build test' to run tests"
