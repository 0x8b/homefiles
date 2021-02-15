if [[ ! "$PATH" == */home/mkg/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/mkg/.fzf/bin"
fi

[[ $- == *i* ]] && source "/home/mkg/.fzf/shell/completion.bash" 2> /dev/null

source "/home/mkg/.fzf/shell/key-bindings.bash"

export FZF_COMPLETION_TRIGGER='~~'
