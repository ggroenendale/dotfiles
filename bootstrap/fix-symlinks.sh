#!/usr/bin/env bash
# =============================================================================
# Fix Symlinks Script
#
# Purpose:
#   Recreates all stow symlinks after the repository restructure.
#   Removes old/broken symlinks pointing to the old .config/ and .local/
#   locations and replaces them with proper symlinks to stow/ packages.
#
# Usage:
#   ./bootstrap/fix-symlinks.sh              # Normal mode (prompts before removing)
#   ./bootstrap/fix-symlinks.sh --force      # Force mode (no prompts)
#   ./bootstrap/fix-symlinks.sh --dry-run    # Preview only, no changes
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STOW_DIR="$DOTFILES_DIR/stow"
FORCE=false
DRY_RUN=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    --dry-run) DRY_RUN=true ;;
  esac
done

echo "=== Fixing Stow Symlinks ==="
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Stow directory: $STOW_DIR"
echo "Mode: $([ "$DRY_RUN" = true ] && echo "DRY RUN (no changes)" || echo "LIVE")"
echo ""

# List of stow packages to process
PACKAGES=(
  "neovim_neovide"
  "desktop_environment"
  "bash"
  "app_desktop_files"
  "aur_helper"
)

# Collect all paths that need fixing
# These are files/dirs in $HOME that either:
#   a) Are symlinks pointing to old .dotfiles/.config/ or .dotfiles/.local/ paths
#   b) Are real files (not symlinks) conflicting with stow
CONFLICTS=()
for pkg in "${PACKAGES[@]}"; do
  # Use find with -print0 and null-delimited reads to handle spaces in filenames
  while IFS= read -r -d '' rel; do
    # Strip leading ./
    rel="${rel#./}"
    [ -z "$rel" ] && continue
    target="$HOME/$rel"
    if [ -L "$target" ]; then
      # It's a symlink — check where it points
      link_target="$(readlink "$target")"
      # Old paths look like: ../.dotfiles/.config/... or ../../.dotfiles/.config/...
      # New stow paths should look like: .dotfiles/stow/<package>/...
      if echo "$link_target" | grep -q "\.dotfiles/\.config\|\.dotfiles/\.local"; then
        CONFLICTS+=("$rel")
      fi
    elif [ -e "$target" ]; then
      # It's a real file — conflict
      CONFLICTS+=("$rel")
    fi
  done < <(cd "$STOW_DIR/$pkg" && find . -type f -o -type l -print0)
done

# Also check for directory-level symlinks that stow needs to create
# (e.g., .config/nvim, .config/neovide, .config/waybar, .config/fuzzel, etc.)
for pkg in "${PACKAGES[@]}"; do
  while IFS= read -r -d '' dir_rel; do
    dir_rel="${dir_rel#./}"
    [ -z "$dir_rel" ] && continue
    target="$HOME/$dir_rel"
    if [ -L "$target" ]; then
      link_target="$(readlink "$target")"
      if echo "$link_target" | grep -q "\.dotfiles/\.config\|\.dotfiles/\.local"; then
        CONFLICTS+=("$dir_rel")
      fi
    fi
  done < <(cd "$STOW_DIR/$pkg" && find . -type d -print0)
done

# Remove duplicates while preserving order
CONFLICTS=($(printf "%s\n" "${CONFLICTS[@]}" | awk '!seen[$0]++'))

if [ ${#CONFLICTS[@]} -eq 0 ]; then
  echo "✓ No conflicts found. All symlinks are correct."
  exit 0
fi

echo "Found ${#CONFLICTS[@]} paths that need fixing:"
for conflict in "${CONFLICTS[@]}"; do
  target="$HOME/$conflict"
  if [ -L "$target" ]; then
    echo "  ~/$conflict -> $(readlink "$target")  [needs update]"
  else
    echo "  ~/$conflict  [conflict - real file]"
  fi
done
echo ""

# Confirm before proceeding
if [ "$FORCE" != true ] && [ "$DRY_RUN" != true ]; then
  read -rp "Remove these and replace with stow symlinks? [y/N] " confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Aborted."
    exit 1
  fi
fi

# Remove conflicting paths
echo ""
echo "Removing old symlinks and conflicting files..."
for conflict in "${CONFLICTS[@]}"; do
  target="$HOME/$conflict"
  if [ -L "$target" ] || [ -e "$target" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "  [DRY RUN] Would remove: ~/$conflict"
    else
      rm -rf "$target"
      echo "  Removed: ~/$conflict"
    fi
  fi
done

# Run stow for each package
echo ""
echo "Creating symlinks..."
for pkg in "${PACKAGES[@]}"; do
  if [ "$DRY_RUN" = true ]; then
    echo "  [DRY RUN] Would stow package: $pkg"
    stow --no -v -d "$STOW_DIR" -t "$HOME" "$pkg" 2>&1 | sed 's/^/    /'
  else
    echo "  Stowing package: $pkg"
    stow -v -d "$STOW_DIR" -t "$HOME" "$pkg" 2>&1 | sed 's/^/    /'
  fi
done

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "=== Dry run complete. No changes were made. ==="
else
  echo "=== Symlinks fixed! ==="
  echo "Run 'stow --no -v -d $STOW_DIR -t \$HOME <package>' to verify."
fi

