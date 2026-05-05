# ==================================================================================================
#  ~/.bashrc
#  Loader for Bash configuration stored in ~/.config/bash
# ==================================================================================================

# Load main bash configuration
if [[ -f "$HOME/.config/bash/bashrc" ]]; then
    source "$HOME/.config/bash/bashrc"
fi


# Load zoxide here?
eval "$(zoxide init bash)"
