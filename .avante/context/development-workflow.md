---
title: "Development Workflow"
description: "Daily development processes and workflows using the dotfiles repository tools, Neovim with AI integration, and system utilities"
tags: [workflow, development, neovim, ai, productivity, tools]
category: "Development Tools"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Development Workflow

## Overview
This document describes the daily development workflows and processes using the tools and configurations in the dotfiles repository. The workflow integrates Neovim with AI assistance, Hyprland window management, screen capture tools, and system utilities for a seamless development experience.

## Daily Startup Routine

### 1. System Initialization
```bash
# Start Hyprland (if not already running)
# System automatically starts:
# - Waybar (status bar)
# - Network manager applet
# - Bluetooth manager
# - Polkit authentication agent
```

### 2. Development Environment Setup
```bash
# Open terminal (SUPER + Return)
# Navigate to project directory
cd ~/projects/current-project

# Check project context
ls -la .avante/  # Check for project AI structure
cat .avante/context/INDEX.md  # Review project overview
cat .avante/plans/current.md  # Check active work
```

### 3. Neovim Session
```bash
# Start Neovim with project context
nvim .

# Or use Neovide for GUI version
neovide .
```

## Neovim Development Workflow

### Project Navigation
```
<Leader>ff      # Find files in project (Telescope)
<Leader>fg      # Live grep in project
<Leader>fb      # Find buffers
<Leader>fh      # Find help tags
gd              # Go to definition (LSP)
gr              # Find references (LSP)
<C-o>           # Go back
<C-i>           # Go forward
```

### Code Editing Patterns
1. **Open File**: `<Leader>ff` to find and open file
2. **Navigate Code**: `gd` for definitions, `gr` for references
3. **Refactor**: Use LSP rename (`<Leader>rn`) and code actions (`<Leader>ca`)
4. **Debug**: Use nvim-dap for debugging with breakpoints
5. **Test**: Run tests with built-in test runners or custom commands

### AI-Assisted Development

#### Code Generation and Review
```
/ai Write a function to parse JSON with error handling
/acp gemini Review this code for security issues
/rag How do I implement authentication in FastAPI?
```

#### Custom Tool Usage
```
/tool neovim_messages          # Check recent messages
/tool dotfiles_stow operation=status  # Check dotfiles status
```

#### Context-Aware Assistance
- AI automatically references project rules from `.avante/rules/`
- Uses RAG service for enhanced context retrieval
- Follows project-specific guidelines from rule files

### Git Integration
```
<Leader>gg      # Open lazygit
<Leader>gh      # Show git hunk diff
<Leader>gp      # Preview hunk
<Leader>gs      # Stage hunk
<Leader>gu      # Undo stage hunk
```

## Screen Capture Workflow

### Documentation and Communication
1. **Capture Issue**: `PRINT` for full screenshot, `SHIFT+PRINT` for region
2. **Record Demo**: `SUPER+ALT+R` for recording menu
3. **Annotate**: Open in image editor if needed
4. **Share**: Copy to clipboard or save to organized directories

### Integration with Development
```bash
# Quick screenshot for documentation
ss-region  # Select relevant UI portion

# Record feature demonstration
sr-full    # Record entire screen demo

# Insert into documentation
# Screenshots automatically saved to ~/Pictures/Screenshots/
# Recordings saved to ~/Videos/ScreenRecordings/
```

## Window Management Workflow

### Workspace Strategy
- **Workspace 1**: Terminal and shell (SUPER+1)
- **Workspace 2**: Browser and research (SUPER+2)
- **Workspace 3**: Neovim and code editing (SUPER+3)
- **Workspace 4**: Communication tools (SUPER+4)
- **Workspace 5+**: Project-specific workspaces

### Window Navigation
```
SUPER+H/J/K/L    # Move focus between windows
SUPER+SHIFT+H/J/K/L  # Move windows between positions
SUPER+Space      # Toggle floating window
SUPER+F          # Toggle fullscreen
```

### Multi-Monitor Workflow
- Drag windows between monitors
- Workspace-per-monitor configuration
- Focus follows mouse or keyboard navigation

## Bash and Shell Workflow

### Common Aliases and Functions
```bash
# Project navigation
cdp() { cd ~/projects/"$1"; }  # Quick project access
cdf() { cd "$(find ~/projects -type d -name "*$1*" | head -1)"; }

# Git shortcuts
gst() { git status; }
gco() { git checkout "$1"; }
gcm() { git commit -m "$1"; }
gp() { git push; }

# System management
update() { sudo pacman -Syu; }
clean() { sudo pacman -Sc; }

# Screen capture shortcuts
ss-full    # Full screenshot
ss-region  # Region screenshot
sr-full    # Full screen recording
sr-stop    # Stop recording
```

### Shell Productivity
- Tab completion for commands and paths
- History search with `Ctrl+R`
- Custom prompt with git status
- Environment variable management

## AI Integration Workflow

### Daily AI Tasks
1. **Code Review**: Use `/ai` or `/acp` for code review
2. **Debugging Assistance**: Describe issues to AI for suggestions
3. **Documentation**: Generate documentation from code
4. **Learning**: Ask questions about new technologies
5. **Planning**: Use AI for project planning and task breakdown

### RAG Service Usage
- Automatically enhances context for AI queries
- References project documentation and code
- Provides more accurate and relevant responses
- Runs in podman container on port 20250

### Provider Selection Strategy
- **DeepSeek**: Primary for general coding and questions
- **Gemini**: Alternative for different perspectives
- **Claude Code**: Specialized for code review
- **Multiple Providers**: Compare responses for complex issues

## Project Management Workflow

### .avante/ Structure Usage
```
.avante/
├── context/           # Project information
│   └── INDEX.md      # Always check first
├── plans/            # Project tracking
│   ├── current.md    # Log daily work here
│   └── project-plan.md # Comprehensive planning
└── rules/            # AI guidance
    └── *.avanterules # Project-specific rules
```

### Daily Logging
1. **Morning**: Check `current.md` for active projects
2. **Work Session**: Log activities with timestamps
3. **Issues**: Note problems and solutions
4. **Completion**: Update phase steps as completed
5. **Evening**: Review day's work and plan next steps

### Project Tracking
- Use Proj-XXX IDs for project identification
- Track phases and steps within each project
- Note dependencies and blockers
- Regular review and adjustment of priorities

## Communication and Collaboration

### Internal Documentation
- Update context documents as system evolves
- Document significant changes in AGENTS.md
- Maintain README files for each component
- Use screenshots and recordings for visual documentation

### External Communication
- Screenshots for bug reports
- Screen recordings for feature demonstrations
- Code snippets with proper context
- Project documentation in context folders

## Troubleshooting Workflow

### Systematic Debugging
1. **Identify**: Clearly define the problem
2. **Isolate**: Reproduce in minimal environment
3. **Investigate**: Check logs and error messages
4. **Hypothesize**: Form theories about cause
5. **Test**: Try potential solutions
6. **Document**: Record findings and solutions

### Common Tools
```bash
# System diagnostics
journalctl -xe          # System logs
dmesg | tail -20        # Kernel messages
systemctl status <service>  # Service status

# Neovim debugging
:messages               # View message history
:LspLog                 # LSP server logs
:Lazy profile           # Plugin performance

# AI service debugging
podman ps               # Check RAG container
curl localhost:20250/health  # Test RAG service
```

### AI-Assisted Troubleshooting
```
/ai I'm getting error X when doing Y, here are the logs...
/acp gemini What could cause this specific error pattern?
/rag Search documentation for this error message
```

## Performance Optimization

### Daily Performance Checks
1. **Startup Time**: Monitor Neovim startup with `:StartupTime`
2. **Memory Usage**: Check with `htop` or `free -h`
3. **Disk Space**: Regular cleanup of temporary files
4. **Network**: Test API connectivity for AI services

### Optimization Strategies
- Lazy loading of Neovim plugins
- Efficient Hyprland compositor settings
- Regular system updates and cleanup
- Monitoring of AI service costs and usage

## Backup and Recovery

### Daily Backup Routine
```bash
# Git commits for configuration changes
git add .
git commit -m "Daily update: [description]"

# Optional: Backup critical files
cp -r ~/.config/nvim/ ~/backups/nvim-$(date +%Y%m%d)
```

### Recovery Procedures
1. **Configuration Loss**: Restore from git repository
2. **System Failure**: Use Ansible provisioning scripts
3. **Data Corruption**: Restore from backups
4. **API Key Issues**: Regenerate and update `.env` files

## Continuous Improvement

### Weekly Review
1. **Tool Evaluation**: Are current tools still effective?
2. **Workflow Analysis**: Identify bottlenecks or inefficiencies
3. **Learning Integration**: Incorporate new techniques or tools
4. **Documentation Update**: Keep context documents current

### Monthly Assessment
1. **System Performance**: Review and optimize configurations
2. **Cost Management**: Analyze AI service usage and costs
3. **Skill Development**: Identify areas for learning and growth
4. **Project Progress**: Review completed work and future plans

## Integration Points

### Tool Chain Integration
- Neovim → AI → Screen Capture → Documentation
- Bash → Git → Project Management → Communication
- Hyprland → Waybar → Notifications → Workflow

### Cross-Component Workflows
1. **Code → Documentation**: Write code, capture examples, document
2. **Debug → Fix → Record**: Debug issue, implement fix, record solution
3. **Plan → Implement → Review**: Project planning, implementation, code review

## Source Code References

### Workflow Tools
- **Neovim**: https://github.com/neovim/neovim
- **Hyprland**: https://github.com/hyprwm/Hyprland
- **Waybar**: https://github.com/Alexays/Waybar
- **Git**: https://git-scm.com/

### AI and Productivity
- **avante.nvim**: https://github.com/yetone/avante.nvim
- **DeepSeek**: https://platform.deepseek.com/
- **RAG Service**: https://quay.io/yetoneful/avante-rag-service

### Screen Capture
- **grim/slurp**: https://github.com/emersion/grim
- **wf-recorder**: https://github.com/ammen99/wf-recorder
- **wl-clipboard**: https://github.com/bugaevc/wl-clipboard

## Related Documents
- [Neovim Configuration](./neovim-configuration.md) - Editor setup details
- [avante.nvim Setup](./avante-nvim-setup.md) - AI assistant configuration
- [Screen Capture System](./screen-capture-system.md) - Screenshot/recording tools
- [Hyprland Configuration](./hyprland-configuration.md) - Desktop environment
- [System Overview](./system-overview.md) - Overall architecture

---

*This development workflow integrates all components of the dotfiles repository into a cohesive, efficient system for AI-assisted development on Arch Linux with Hyprland. The workflow emphasizes productivity, documentation, and continuous improvement. Last updated: 2026-04-19*

