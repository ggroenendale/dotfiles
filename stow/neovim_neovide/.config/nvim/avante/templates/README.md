# avante.nvim Templates

This directory contains templates for the standardized `.avante/` folder structure used for AI-assisted development consistency across projects.

## Available Templates

### `INDEX.md`
**Location:** `.avante/context/INDEX.md`
**Purpose:** Central index of project information
**Usage:** Copy to `.avante/context/` directory in your project
**Contents:** Project overview, architecture, key files, dependencies, setup instructions, testing strategy, deployment, monitoring, security, troubleshooting

### `ARCHITECTURE.md`
**Location:** `.avante/context/ARCHITECTURE.md`
**Purpose:** Detailed technical architecture documentation
**Usage:** Copy to `.avante/context/` directory in your project
**Contents:** Architectural principles, high-level architecture, component architecture, data flow, technology stack, directory structure, configuration management, security architecture, performance considerations, scalability, monitoring, future directions
**Note:** This is a REQUIRED file per global avante rules - provides comprehensive technical architecture documentation

### `current.md`
**Location:** `.avante/plans/current.md`
**Purpose:** Active work log with project tracking
**Usage:** Copy to `.avante/plans/` directory in your project
**Contents:** Active projects with IDs (Proj-001 style), phase tracking, work log, AI agent guidelines
**Note:** Validation requirements, testing requirements, risks/issues, completed projects, and project queue are managed in the project plan document, not in current.md

### `project-plan.md`
**Location:** `.avante/plans/project-plan.md` (or specific project name)
**Purpose:** Comprehensive project planning document
**Usage:** Create for each major project in `.avante/plans/` directory
**Contents:** Project overview, scope, timeline, team, validation requirements, testing requirements, risks/issues, dependencies, communication plan, change management, completed projects, project queue
**Note:** This document handles the comprehensive planning aspects while current.md focuses on active work tracking

## How to Use

### For New Projects
1. Create `.avante/` directory at project root
2. Create subdirectories: `context/`, `plans/`, `rules/`
3. Copy `INDEX.md` to `.avante/context/`
4. Copy `current.md` to `.avante/plans/`
5. Customize both files with your project information

### For Existing Projects
1. Check if `.avante/` structure exists
2. If missing, create the structure as above
3. If partial, add missing folders/files
4. Update existing files to follow the template structure

## Integration with avante.nvim

### Global Rule
The `project-consistency.avanterules` global rule provides:
- Guidance on the required folder structure
- Instructions for using the templates
- Best practices for maintaining consistency
- Integration guidelines for avante.nvim

### Automatic Detection
avante.nvim will:
1. Auto-load the global rule from `~/.config/nvim/avante/rules/`
2. Check for project-specific rules in `.avante/rules/`
3. Reference the `.avante/` structure when providing AI assistance

## Best Practices

1. **Consistency**: Use the same structure across all projects
2. **Version Control**: Include `.avante/` in version control (except sensitive data)
3. **Regular Updates**: Keep `INDEX.md` and `current.md` updated
4. **Project IDs**: Use consistent ID format (Proj-001, Proj-002, etc.)
5. **Context First**: Always check `INDEX.md` for project context before starting work
6. **Plan Tracking**: Update `current.md` with work progress and next steps

## Customization

You can customize the templates for your specific needs:

1. **Project-specific sections**: Add sections relevant to your project type
2. **Team workflows**: Adapt to your team's development process
3. **Tool integration**: Add sections for specific tools you use
4. **Compliance requirements**: Include compliance-specific sections

## Troubleshooting

### Missing `.avante/` Structure
If avante.nvim doesn't detect the structure:
1. Check if the global rule is loaded
2. Verify the `.avante/` directory exists at project root
3. Ensure all three subdirectories exist
4. Check that required files exist with correct names

### Template Issues
If templates don't work as expected:
1. Verify file permissions
2. Check for syntax errors in markdown
3. Ensure proper indentation and formatting
4. Test with a simple project first

## Related Files

- `~/.config/nvim/avante/rules/project-consistency.avanterules`: Global rule for project consistency
- `~/.config/nvim/lua/geoff/plugins/avante.lua`: avante.nvim configuration
- `.avante/rules/`: Project-specific rules directory

## Support

For issues with the templates or `.avante/` structure:
1. Check the global rule for guidance
2. Review this README
3. Consult avante.nvim documentation
4. Update templates as needed for your workflow

