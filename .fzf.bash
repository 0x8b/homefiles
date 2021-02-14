# Setup fzf
# ---------
if [[ ! "$PATH" == */home/oberon/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/oberon/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/oberon/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/oberon/.fzf/shell/key-bindings.bash"
