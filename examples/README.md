# Examples

This directory contains example programs demonstrating how to use the lcz library.

## Running Examples

To build and run examples, you'll need to add them to the `build.zig` file or compile them directly:

```bash
# Compile an example
zig build-exe examples/basic.zig -I src/

# Or if integrated into build.zig
zig build example-basic
```

## Available Examples

### basic.zig
Demonstrates basic usage of the Agent struct and utility functions.

### config.zig
Shows how to use the configuration module to manage application settings.

## Adding Examples to Build

To make examples easier to run, you can add them to `build.zig`:

```zig
// Add to build.zig
const basic_example = b.addExecutable(.{
    .name = "example-basic",
    .root_source_file = b.path("examples/basic.zig"),
    .target = target,
    .optimize = optimize,
});

const run_basic = b.addRunArtifact(basic_example);
const basic_step = b.step("example-basic", "Run basic example");
basic_step.dependOn(&run_basic.step);
```
