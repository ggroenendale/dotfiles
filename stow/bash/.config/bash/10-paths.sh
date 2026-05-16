# ==================================================================================================
# PATH CONFIGURATION
# ==================================================================================================

# Neovim
export PATH="/opt/nvim/bin:$PATH"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# User scripts and Pipx / user python tools
export PATH="$HOME/.local/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Might need these other configurations?
#echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc

# Legacy bash profile configs
#echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
#echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
#echo 'eval "$(pyenv init - bash)"' >> ~/.bash_profile


