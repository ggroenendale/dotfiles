---
title: "avante.nvim AI Assistant Setup"
description: "Configuration and usage of avante.nvim AI assistant with DeepSeek integration, RAG service, and custom tools"
tags: [ai, avante-nvim, deepseek, rag, llm, neovim]
category: "AI Integration"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Published"
---

# avante.nvim AI Assistant Setup

## Overview
avante.nvim is a comprehensive AI assistant plugin for Neovim that integrates multiple LLM providers, RAG (Retrieval-Augmented Generation) service, and custom tools. This document details the configuration, usage, and troubleshooting of the AI assistant setup.

## Architecture

### Core Components
1. **Primary LLM Provider**: DeepSeek via OpenAI-compatible API
2. **ACP Providers**: Multiple alternative providers (Gemini, Claude, Goose, Codex, Kimi)
3. **RAG Service**: Context retrieval with DeepSeek embeddings
4. **Rules System**: Hierarchical rules for project-specific guidance
5. **Custom Tools**: Extended functionality for debugging and system management

### System Flow
```
User Request → avante.nvim → Provider Selection → LLM API → Response
                    ↓
              RAG Service (optional)
                    ↓
              Context Retrieval → Enhanced Response
```

## Configuration Details

### Main Configuration (.config/nvim/lua/geoff/plugins/avante.lua)
```lua
return {
  "yetone/avante.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    enabled = true,

    -- Primary provider configuration
    provider = "deepseek",
    api_key = os.getenv("DEEPSEEK_API_KEY"),
    model = "deepseek-chat",

    -- ACP (Alternative Completion Provider) configuration
    acp = {
      enabled = true,
      providers = {
        "gemini-cli",
        "claude-code",
        "goose",
        "codex",
        "kimi-cli"
      }
    },

    -- RAG service configuration
    rag_service = {
      enabled = true,
      runner = "podman",  -- Fixed to work with podman
      image = "quay.io/yetoneful/avante-rag-service:0.0.11",
      port = 20250,
      environment = {
        DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY"),
        OPENAI_API_KEY = os.getenv("DEEPSEEK_API_KEY")
      }
    },

    -- Rules system configuration
    rules = {
      enabled = true,
      global_rules_dir = vim.fn.stdpath("config") .. "/avante/rules",
      project_rules_dir = ".avante/rules",
      auto_load = true
    },

    -- Custom tools configuration
    custom_tools = {
      "neovim_messages",
      "neovim_echo",
      "dotfiles_stow"
    },

    -- UI configuration
    ui = {
      border = "rounded",
      width = 0.8,
      height = 0.8
    }
  }
}
```

## RAG Service Implementation

### Service Architecture
- **Container Runtime**: Podman (with docker compatibility layer)
- **Image**: `quay.io/yetoneful/avante-rag-service:0.0.11`
- **Port**: 20250
- **Embeddings**: DeepSeek embeddings via OpenAI-compatible API

### Fix for Podman Compatibility
Due to avante.nvim's hardcoded docker commands:

1. **Code Patch**: Modified `get_rag_service_runner()` function in avante.nvim to treat "podman" as "docker"
2. **Symlink Creation**: `~/.local/bin/docker -> /usr/bin/podman`
3. **Manual Startup**: Can start service manually if needed:
   ```bash
   podman run -d --name avante-rag-service \
     -p 20250:20250 \
     -e DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY \
     -e OPENAI_API_KEY=$DEEPSEEK_API_KEY \
     quay.io/yetoneful/avante-rag-service:0.0.11
   ```

### Verification Commands
```bash
# Check if container is running
podman ps | grep avante-rag-service

# Check container logs
podman logs avante-rag-service

# Test service connectivity
curl http://localhost:20250/health
```

## Rules System

### Hierarchical Rule Loading
1. **Global Rules**: `~/.config/nvim/avante/rules/` (applies to all projects)
2. **Project Rules**: `.avante/rules/` (overrides global rules for specific project)
3. **Auto-loading**: Rules automatically load when avante starts

### Global Rule Files
1. **neovim-general.avanterules**: General Neovim development guidelines
2. **ai-development.avanterules**: AI/LLM development best practices
3. **debugging.avanterules**: Systematic debugging methodology
4. **project-consistency.avanterules**: Standardized .avante/ folder structure

### Project-Specific Rules (this repository)
1. **dotfiles.avanterules**: Repository-specific guidance
2. **stow-management.avanterules**: GNU Stow usage for dotfiles
3. **nvim-config.avanterules**: Neovim configuration guidance
4. **debug.avanterules**: Debugging tools and techniques

### Rule File Structure
```jinja
{# Rule file template #}
{% block custom_prompt %}
[Context-specific guidance for AI assistant]
{% endblock %}

{% block extra_prompt %}
[Additional instructions and constraints]
{% endblock %}
```

## Custom Tools

### 1. neovim_messages
- **Purpose**: View Neovim message history
- **Usage**: Access via avante.nvim interface
- **Equivalent to**: `:messages` command

### 2. neovim_echo
- **Purpose**: Test echo functionality for debugging
- **Usage**: Send test messages to verify Neovim communication
- **Example**: `:lua require("neovim_echo").echo("Test message")`

### 3. dotfiles_stow
- **Purpose**: Manage dotfiles with GNU Stow
- **Parameters**:
  - `operation`: 'stow', 'unstow', 'restow', 'status', 'help'
  - `target`: Specific directory to stow (default: '.')
  - `dry_run`: Boolean flag for dry run mode
- **Features**:
  - Project context detection (only works in dotfiles repositories)
  - Proper ignore patterns for repository files
  - Desktop notifications for completed operations
  - Installation check with helpful error messages

## AI Providers Configuration

### DeepSeek (Primary Provider)
- **API Endpoint**: OpenAI-compatible API
- **Model**: deepseek-chat
- **Key Location**: `.config/nvim/.env` (DEEPSEEK_API_KEY)
- **Budget Monitoring**: Deepseek-budget plugin in status bar

### Alternative Providers (ACP)
1. **gemini-cli**: Google Gemini via command line
2. **claude-code**: Anthropic Claude for code
3. **goose**: Local/alternative provider
4. **codex**: OpenAI Codex
5. **kimi-cli**: Kimi AI via command line

## Usage Examples

### Basic AI Interaction
```
/ai [prompt]           # Send prompt to primary provider
/acp [provider] [prompt] # Use specific ACP provider
/rag [prompt]          # Use RAG-enhanced context
```

### Custom Tool Usage
```
/tool neovim_messages  # View message history
/tool dotfiles_stow operation=stow target=. # Run stow
```

### Rule-Based Guidance
- AI automatically references relevant rules based on context
- Project-specific rules override global rules
- Rules provide context-aware guidance for different scenarios

## Environment Setup

### Required Environment Variables
Create `.config/nvim/.env`:
```
DEEPSEEK_API_KEY=your_deepseek_api_key_here
TAVILY_API_KEY=your_tavily_api_key_here  # Optional, for web search
```

### API Key Security
- Store API keys in `.env` file (excluded from version control)
- Load automatically via dotenv.nvim plugin
- Never commit API keys to repository

## Troubleshooting

### Common Issues

#### 1. RAG Service Not Starting
```bash
# Check podman installation
podman --version

# Check docker symlink
ls -la ~/.local/bin/docker

# Manual start
podman run [as shown above]
```

#### 2. API Connection Issues
```bash
# Test DeepSeek API connectivity
curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer $DEEPSEEK_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"test"}]}'
```

#### 3. Rule Loading Problems
```bash
# Check rule file syntax
# Rule files use Jinja2 templating syntax
# Ensure proper block structure
```

### Debug Commands
```lua
-- Check avante.nvim status
:lua require("avante").status()

-- Test provider connectivity
:lua require("avante").test_provider("deepseek")

-- Reload rules
:lua require("avante").reload_rules()
```

## Source Code References

### Primary Repositories
- **avante.nvim**: https://github.com/yetone/avante.nvim
- **RAG Service**: https://quay.io/yetoneful/avante-rag-service
- **DeepSeek API**: https://platform.deepseek.com/api-docs

### Related Tools
- **Podman**: https://podman.io/
- **OpenAI API**: https://platform.openai.com/docs/api-reference
- **Jinja2**: https://jinja.palletsprojects.com/ (rule file templating)

## Performance Optimization

### Startup Time
- Lazy loading of AI components
- Async initialization where possible
- Cache frequently used embeddings

### Memory Usage
- Monitor RAG service memory consumption
- Clean up unused embeddings
- Configure appropriate model sizes

### API Cost Management
- Use DeepSeek budget plugin for cost monitoring
- Implement caching for frequent queries
- Use local models where appropriate

## Related Documents
- [Neovim Configuration](./neovim-configuration.md) - Overall editor setup
- [AI Providers](./ai-providers.md) - Detailed provider configurations
- [RAG Service](./rag-service.md) - Context retrieval system details
- [Development Workflow](./development-workflow.md) - Integration with daily work

---

*This AI assistant setup provides comprehensive AI capabilities within Neovim, optimized for development workflows with proper cost management and context awareness. Last updated: 2026-04-19*

