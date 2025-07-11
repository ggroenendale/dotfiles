# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

eval "$(starship init bash)"


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability;
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# =================================================================================================
# =================================================================================================
# Customization scripts begin here
# =================================================================================================
# =================================================================================================

# ---------------------------------
# Bash Spinner
# ---------------------------------
# This should load my spinner script in the background
nohup ~/.my_scripts/spinner.sh > /dev/null 2>&1 &

# ---------------------------------
# Neovim Customizations
# ---------------------------------

# Make nvim available anywhere by adding it to the path
export PATH="/opt/nvim/bin:$PATH"
# Update visual editor values for nvim
export VISUAL=nvim
export EDITOR=nvim

# ---------------------------------
# NodeJS, NVM, NPM Customizations
# ---------------------------------

# Set the NVM home directory
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ---------------------------------
# Rust or Ruby stuff
# ---------------------------------

# Make cargo available anywhere by adding it to path
export PATH="/home/geoff/.cargo/bin:$PATH"

# ---------------------------------
# I don't know what this is for but 
# its important apparently
# ---------------------------------

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# ---------------------------------
# Config (.cfg) editing scripts
# ---------------------------------
# https://stackoverflow.com/a/2464883
# Usage: config_set filename key value
function config_set() {
  local file=$1
  local key=$2
  local val=${@:3}

  ensureConfigFileExists "${file}"

  # create key if not exists
  if ! grep -q "^${key}=" ${file}; then
    # insert a newline just in case the file does not end with one
    printf "\n${key}=" >> ${file}
  fi

  chc "$file" "$key" "$val"
}

function ensureConfigFileExists() {
  if [ ! -e "$1" ] ; then
    if [ -e "$1.example" ]; then
      cp "$1.example" "$1";
    else
      touch "$1"
    fi
  fi
}

# thanks to ixz in #bash on irc.freenode.net
function chc() { gawk -v OFS== -v FS== -e 'BEGIN { ARGC = 1 } $1 == ARGV[2] { print ARGV[4] ? ARGV[4] : $1, ARGV[3]; next } 1' "$@" <"$1" >"$1.1"; mv "$1"{.1,}; }

# https://unix.stackexchange.com/a/331965/312709
# Usage: local myvar="$(config_get myvar)"
function config_get() {
    val="$(config_read_file ${CONFIG_FILE} "${1}")";
    if [ "${val}" = "__UNDEFINED__" ]; then
        val="$(config_read_file ${CONFIG_FILE}.example "${1}")";
    fi
    printf -- "%s" "${val}";
}
function config_read_file() {
    (grep -E "^${2}=" -m 1 "${1}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-;
}

# Created by `pipx` on 2025-07-08 22:26:44
export PATH="$PATH:/home/geoff/.local/bin"
