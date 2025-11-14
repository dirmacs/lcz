# Architecture

## Overview

lcz is a Zig-based CLI application designed to integrate with llama.cpp for agentic AI capabilities.

## Components

### CLI Layer (`src/cli.zig`)
- Command-line argument parsing
- User interaction handling
- Help and version display

### Configuration (`src/config.zig`)
- Application settings management
- Model configuration
- Runtime parameters

### Llama Integration (`src/llama.zig`)
- Interface to llama.cpp
- Model loading and inference
- Text generation capabilities

### Agent System (`src/root.zig`)
- Agent abstraction
- Task execution
- Agentic behaviors

## Data Flow

```
User Input (CLI)
    ↓
CLI Parser (cli.zig)
    ↓
Configuration (config.zig)
    ↓
Agent (root.zig)
    ↓
Llama Context (llama.zig)
    ↓
Output
```

## Module Dependencies

```
main.zig
  ├── cli.zig
  └── root.zig
      ├── config.zig
      └── llama.zig
```

## Future Enhancements

1. **llama.cpp Integration**
   - Link to llama.cpp C library
   - Implement model loading
   - Add inference capabilities

2. **Agent Capabilities**
   - Tool calling
   - Memory management
   - Multi-turn conversations

3. **Configuration**
   - TOML/JSON config file support
   - Environment variable support
   - Runtime configuration updates

4. **CLI Features**
   - Interactive mode
   - Batch processing
   - Streaming output
