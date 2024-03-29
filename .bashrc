# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) bind '"\e[A": history-search-backward'
       bind '"\e[B": history-search-forward'
       ;;
    *) return
       ;;
esac

# a command name that is the name of a directory is executed as if
# it were the argument to the `cd` command.
shopt -s autocd

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [[ "$color_prompt" = yes ]]; then
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
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

EDITOR=nano

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/.local/bin" ]] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]] ; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -d "$HOME/.rbenv/bin" ]] ; then
  PATH="$HOME/.rbenv/bin:$PATH"
fi

function config {
  case $1 in
    "edit" | "modify")
      if path="$(config list-tracked-files | fzf -e -i)" ; then
        [ -f "$path" ] && nvim "$path"
      fi
      ;;
    "search" | "find")
      rg "$2" $(config list-tracked-files)
      ;;
    "publish" | "backup")
      local -r message="$2"
      config commit -m "${message:-update}"
      config push -u origin master
      ;;
    "list-tracked-files")
      config ls-tree -r master --full-tree --name-only | sed -e "s/^/\/home\/$USER\//"
      ;;
    *)
      /usr/bin/git --git-dir=$HOME/.homefiles/ --work-tree=$HOME "$@"
      ;;
  esac
}

function mkcd {
  mkdir -pv -- "$1" && cd -- "$1"
}

function gitpeek {
  if [[ -n "$1" ]] ; then
    local repo="$1"
    local tmpdname="$(mktemp -d)"

    if [[ ! "$repo" =~ ^https ]] ; then
      repo="https://github.com/${repo}"
    fi

    git clone --depth 1 "$repo" "$tmpdname" || return

    echo "${tmpdname} # ${repo}" >> ~/.git-peek

    cd "$tmpdname" # undo by `cd -`

    return
  fi

  if [[ -f ~/.git-peek ]] ; then
    alive=$(mktemp)

    while read -r dname ; do
      [[ -d ${dname%% *} ]] && echo $dname >> $alive
    done < ~/.git-peek

    cp $alive ~/.git-peek

    if dname="$(cat ~/.git-peek | fzf -i --select-1 --exit-0)" ; then
      cd ${dname%% *}
    fi
  fi

  return
}

[[ -f ~/.fzf.bash ]] && . ~/.fzf.bash

export RBENV_VERSION=3.0.0
eval "$(rbenv init -)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

[[ -f ~/.cargo/env ]] && . ~/.cargo/env

export RIPGREP_CONFIG_PATH=~/.config/ripgrep/rc

eval "$(zoxide init bash)"
eval "$(starship init bash)"

. ~/.config/broot/launcher/bash/br

function finish {
  echo "$PWD" > ~/.oldpwd
}

[[ -f ~/.oldpwd ]] && export OLDPWD="$(cat ~/.oldpwd)"

trap finish EXIT
