# =====================================================================
# ENVIRONMENT VARIABLES
# =====================================================================

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Python
export PYTHONBREAKPOINT=ipdb.set_trace

# Rust
export CARGO_HOME="$HOME/.cargo"

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"

# Example distro logic
case "$DISTRO" in

  arch)
    export BROWSER=firefox
    ;;

  debian|ubuntu)
    export BROWSER=firefox
    ;;

  opensuse*)
    export BROWSER=firefox
    ;;

esac
