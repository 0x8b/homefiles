if [[ ! "$PATH" == */home/oberon/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/oberon/.fzf/bin"
fi

[[ $- == *i* ]] && source "/home/oberon/.fzf/shell/completion.bash" 2> /dev/null

source "/home/oberon/.fzf/shell/key-bindings.bash"

export FZF_COMPLETION_TRIGGER='~~'
