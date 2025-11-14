# Tests

This directory can contain integration and end-to-end tests.

Unit tests are typically located alongside the source code in `src/` files.

## Test Organization

- **Unit Tests**: In source files (`src/*.zig`)
- **Integration Tests**: In `test/` directory (this location)
- **Example Tests**: In `examples/` with test blocks

## Running Tests

```bash
# All tests
zig build test

# Or with make
make test
```

## Writing Tests

### Unit Tests (in source files)

```zig
const std = @import("std");

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "add function" {
    try std.testing.expectEqual(@as(i32, 5), add(2, 3));
}
```

### Integration Tests (in test/ directory)

Integration tests can be added here and included in `build.zig`:

```zig
const integration_tests = b.addTest(.{
    .root_source_file = b.path("test/integration_test.zig"),
    .target = target,
    .optimize = optimize,
});

const run_integration_tests = b.addRunArtifact(integration_tests);
test_step.dependOn(&run_integration_tests.step);
```

## Test Coverage

While Zig doesn't have built-in coverage tools yet, you can:
1. Write comprehensive unit tests
2. Test edge cases
3. Test error conditions
4. Use `std.testing` assertions

## Best Practices

- Test public APIs thoroughly
- Test error conditions
- Use descriptive test names
- Keep tests fast and isolated
- Clean up resources (use `defer`)
