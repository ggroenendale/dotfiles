---
title: "Lessons Learned"
description: "Collection of insights, best practices, and lessons learned from working with the dotfiles repository and its components"
tags: [lessons, best-practices, insights, troubleshooting, optimization]
category: "Knowledge Base"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Living Document"
---

# Lessons Learned

## Overview
This document serves as a living collection of insights, best practices, and lessons learned from working with the dotfiles repository and its various components. It captures both technical knowledge and workflow improvements that have emerged through experience.

## How to Use This Document
- **Add new lessons** as they are discovered
- **Reference this document** when facing similar challenges
- **Update existing lessons** as better approaches are found
- **Use as a knowledge base** for onboarding and training

## Table of Contents
- [System Configuration](#system-configuration)
- [Neovim and Development](#neovim-and-development)
- [AI Integration](#ai-integration)
- [Screen Capture System](#screen-capture-system)
- [Hyprland and Wayland](#hyprland-and-wayland)
- [Workflow and Productivity](#workflow-and-productivity)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## System Configuration

### Lesson 1: Modular Configuration Design
**Insight**: Keeping configurations modular and separated by concern dramatically improves maintainability.

**Details**:
- Each component (Neovim, Hyprland, Bash) has its own directory
- Environment variables are centralized in `.env` files
- Common patterns are abstracted into reusable functions
- Changes can be tested in isolation before integration

**Example**: Neovim configuration is split into `core/`, `plugins/`, and `lsp/` directories.

### Lesson 2: Version Control for Dotfiles
**Insight**: Git is essential for dotfiles management, but requires careful `.gitignore` configuration.

**Details**:
- Use `.stow-local-ignore` for GNU Stow compatibility
- Never commit API keys or sensitive information
- Use descriptive commit messages that explain "why" not just "what"
- AGENTS.md provides valuable historical context

### Lesson 3: Environment Variable Management
**Insight**: Centralized environment variable management prevents configuration drift.

**Details**:
- Store API keys in `.config/nvim/.env`
- Use dotenv.nvim plugin for automatic loading
- Document required environment variables in README files
- Test environment variable loading during system setup

## Neovim and Development

### Lesson 4: Plugin Management Strategy
**Insight**: Careful plugin selection and lazy loading are crucial for Neovim performance.

**Details**:
- Use lazy.nvim for efficient plugin loading
- Limit plugins to those that provide real value
- Regularly update plugins but test changes
- Monitor startup time with `:StartupTime`

### Lesson 5: LSP Configuration
**Insight**: Proper LSP setup requires understanding both server capabilities and client configuration.

**Details**:
- Use mason.nvim for easy LSP server management
- Configure formatters and linters separately from LSP
- Set up keymaps consistently across all LSP servers
- Monitor LSP logs for debugging (`:LspLog`)

### Lesson 6: Debugging Workflow
**Insight**: A systematic debugging approach saves time and reduces frustration.

**Details**:
1. Reproduce the issue in minimal configuration
2. Check `:messages` for error output
3. Use `:LspInfo` and `:LspLog` for LSP issues
4. Test with specific filetypes and buffer states
5. Document findings for future reference

## AI Integration

### Lesson 7: RAG Service Compatibility
**Insight**: avante.nvim's RAG service has compatibility issues with podman that require workarounds.

**Details**:
- avante.nvim hardcodes "docker" commands
- Solution: Create symlink `~/.local/bin/docker -> /usr/bin/podman`
- Additional fix: Patch avante.nvim to treat "podman" as "docker"
- Manual container startup works when automatic fails

### Lesson 8: API Cost Management
**Insight**: Monitoring AI API usage is essential to avoid unexpected costs.

**Details**:
- Created DeepSeek budget plugin for status bar display
- Set color-coded warnings (green/yellow/red)
- Implement caching to reduce API calls
- Regular review of usage patterns and costs

### Lesson 9: Rule-Based Guidance
**Insight**: Hierarchical rules provide context-aware AI assistance.

**Details**:
- Global rules in `~/.config/nvim/avante/rules/`
- Project rules in `.avante/rules/` override global rules
- Rules auto-load when avante.nvim starts
- Project-specific guidance improves AI responses

## Screen Capture System

### Lesson 10: Wayland Tool Compatibility
**Insight**: Wayland requires specific tools that differ from X11 equivalents.

**Details**:
- Use `grim` instead of `scrot` or `maim`
- `slurp` provides region selection for Wayland
- `wf-recorder` works for screen recording
- `wl-clipboard` handles clipboard operations

### Lesson 11: Waybar Integration
**Insight**: Custom Waybar modules provide quick access to frequently used functions.

**Details**:
- Single button with dual-click functionality (left/right)
- Tooltips explain button functionality
- Consistent styling with existing modules
- Falls back to terminal menus if GUI unavailable

### Lesson 12: Organized Storage
**Insight**: Automatic organization of captured media reduces clutter.

**Details**:
- Date-based file naming: `YYYY-MM-DD_HH-MM-SS_description.ext`
- Separate directories: `~/Pictures/Screenshots/` and `~/Videos/ScreenRecordings/`
- Regular cleanup of old files (optional)
- Easy retrieval for documentation and sharing

## Hyprland and Wayland

### Lesson 13: Wayland Transition
**Insight**: Transitioning from X11 to Wayland requires understanding new paradigms.

**Details**:
- No global hotkeys in traditional sense
- Each compositor has its own configuration
- Clipboard management differs
- Screen sharing requires portal integration

### Lesson 14: Hyprland Performance
**Insight**: Hyprland performance depends on proper configuration.

**Details**:
- Adjust animation settings based on hardware
- Monitor-specific configurations prevent issues
- Proper graphics driver configuration is essential
- Regular updates include performance improvements

### Lesson 15: Workspace Strategy
**Insight**: Intentional workspace organization improves workflow efficiency.

**Details**:
- Dedicated workspaces for specific tasks
- Consistent keybindings across workspaces
- Window rules automate application placement
- Workspace switching becomes muscle memory

## Workflow and Productivity

### Lesson 16: Context Documentation
**Insight**: Comprehensive context documentation enables effective AI assistance.

**Details**:
- `.avante/context/` structure provides project understanding
- Metadata templates ensure consistency
- Regular updates keep documentation current
- Cross-references between documents create knowledge network

### Lesson 17: Session Logging
**Insight**: Systematic session logging captures decisions and learnings.

**Details**:
- Timestamped session files create historical record
- Template ensures consistent information capture
- Action items and decisions are documented
- Lessons learned feed back into this document

### Lesson 18: Project Tracking
**Insight**: Structured project tracking improves focus and accountability.

**Details**:
- Use Proj-XXX IDs for project identification
- `current.md` tracks active work only
- `project-plan.md` handles comprehensive planning
- Regular review and adjustment of priorities

## Troubleshooting

### Lesson 19: Systematic Approach
**Insight**: A systematic troubleshooting approach is more effective than random attempts.

**Details**:
1. **Reproduce**: Can you consistently reproduce the issue?
2. **Isolate**: What's the minimal configuration that exhibits the problem?
3. **Research**: Has this been encountered before? Check logs and documentation.
4. **Test**: Try one change at a time and observe results.
5. **Document**: Record the solution for future reference.

### Lesson 20: Log Analysis
**Insight**: Proper log analysis often reveals the root cause.

**Details**:
- Neovim: `:messages`, `:LspLog`, `:checkhealth`
- System: `journalctl`, `dmesg`, service logs
- AI Services: Container logs, API response logs
- Application-specific logs and debug modes

### Lesson 21: Community Resources
**Insight**: Leveraging community knowledge accelerates problem-solving.

**Details**:
- GitHub issues for specific tools
- Arch Linux forums and Wiki
- Reddit communities (r/neovim, r/hyprland, r/wayland)
- Official documentation and man pages

## Best Practices

### Lesson 22: Incremental Changes
**Insight**: Small, incremental changes are safer than large rewrites.

**Details**:
- Test each change before committing
- Use git to track changes and enable rollback
- Document changes in AGENTS.md
- Consider impact on other system components

### Lesson 23: Regular Review
**Insight**: Regular system review prevents technical debt accumulation.

**Details**:
- Weekly: Review plugin updates and configuration changes
- Monthly: Assess system performance and AI costs
- Quarterly: Evaluate tool effectiveness and consider alternatives
- Annually: Major review of system architecture and goals

### Lesson 24: Knowledge Sharing
**Insight**: Documenting knowledge benefits future self and others.

**Details**:
- Update context documents as system evolves
- Share insights in LESSONS_LEARNED.md
- Create reproducible examples for common tasks
- Maintain comprehensive README files

### Lesson 25: Balance Automation and Control
**Insight**: The right balance between automation and manual control depends on the task.

**Details**:
- Automate repetitive tasks (screenshots, updates)
- Maintain manual control for creative work
- Use AI assistance for research and problem-solving
- Keep final decision-making authority

## Adding New Lessons

### Template for New Lessons
```markdown
### Lesson [Number]: [Brief Description]
**Insight**: [One-sentence summary of the lesson]

**Details**:
- [Specific detail 1]
- [Specific detail 2]
- [Specific detail 3]

**Example**: [Concrete example or code snippet]

**Date Learned**: [YYYY-MM-DD]
**Context**: [What situation led to this learning]
```

### Review Process
1. **Propose**: Add new lesson in appropriate section
2. **Review**: Periodically review lessons for accuracy
3. **Update**: Modify lessons as better approaches are found
4. **Archive**: Move outdated lessons to historical section if needed

## Related Documents
- [Session Logs](./sessions/) - Individual session records
- [INDEX.md](./INDEX.md) - Main repository overview
- [AGENTS.md](../AGENTS.md) - Historical agent operations
- [Development Workflow](./development-workflow.md) - Daily processes

## Revision History
| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-19 | Initial version with 25 lessons |
| 1.1 | [Future Date] | [Description of changes] |

---

*This document evolves as new insights are gained. Regular review and updates ensure it remains a valuable knowledge resource. Last updated: 2026-04-19*

