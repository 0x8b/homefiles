alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

for name in ls {,v}dir {,f,e}grep ; do alias $name="$name --color=auto"; done

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rm='rm -i'
alias mv='mv -i'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias youtube-dl-mp3='youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0 --output "~/Music/%(title)s.%(ext)s"'

alias gitpeek='source ~/.local/bin/gitpeek'
alias lastgitpeek='cd $LAST_GIT_PEEK'

alias ce='config edit'
alias ca='config add -u'
