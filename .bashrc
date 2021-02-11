# general
export EDITOR=emacs

shopt -s nocasematch
shopt -s checkwinsize
shopt -s extglob
shopt -s no_empty_cmd_completion

set -o noclobber


# history
shopt -s histappend
shopt -s histverify
shopt -s cmdhist

export HISTSIZE=100000
export HISTCONTROL=ignorespace:ignoredups
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a'


# colours
export LESS_TERMCAP_md=$(tput bold) # bold
export LESS_TERMCAP_us=$(tput smul) # underlined
export LESS_TERMCAP_ue=$(tput rmul) # end underlined
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 1) # standout (bold yellow on red)
export LESS_TERMCAP_se=$(tput sgr 0) # end standout

export LS_COLORS='di=32:ln=35:so=34:pi=33:ex=3:bd=34;46:cd=34;43:su=41:sg=46:tw=42:ow=43'
export LSCOLORS='cxfxexdxbxegedabagacad'


# aliases
if [[ "$OSTYPE" =~ 'linux' ]]
	then lscolourflag='--color=auto'
elif [[ "$OSTYPE" =~ 'darwin' ]]
	then lscolourflag='-G'
fi

alias ls="ls -hF $lscolourflag"
alias ll='ls -loA'
alias pd='pushd'
alias pp='popd'
alias less='less -R'
alias tree='tree --dirsfirst -C'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias share='python -m SimpleHTTPServer'
alias randmac="sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')"
alias home-git="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
alias e='emacs'


# functions
function cl {
	cd "$@" && ll
}

function extract {
	case $1 in
		*.tar)		tar xvf $1 ;;
		*.tar.gz)	tar xvzf $1 ;;
		*.tar.bz2)	tar xvjf $1 ;;
		*.gz)		gunzip $1 ;;
		*.bz2)		bunzip2 $1 ;;
		*.tgz)		tar xvzf $1 ;;
		*.tbz2)		tar xvjf $1 ;;
		*.Z)		uncompress $1 ;;
		*.zip)		unzip $1 ;;
		*.rar)		rar x $1 ;;
		*.7z)		7z x $1 ;;
		*)		echo "cannot extract: $1" ;;
	esac
}

function every {
    while sleep $1
    do $2
    done
}

function git-state {
	if ! git rev-parse --git-dir &> /dev/null
		then return 0
	fi

	branch=$(git branch 2> /dev/null | sed -n '/^\*/s/^\* //p')

	if ! git diff --quiet 2> /dev/null
		then dirty='•'
	fi

	echo "($branch)$dirty"
}


# prompt
reg=$(tput sgr 0) # regular
bld=$(tput bold)  # bold
uln=$(tput smul)  # underlined

k=$reg$(tput setaf 0) # black
r=$reg$(tput setaf 1) # red
g=$reg$(tput setaf 2) # green
y=$reg$(tput setaf 3) # yellow
b=$reg$(tput setaf 4) # blue
m=$reg$(tput setaf 5) # magenta
c=$reg$(tput setaf 6) # cyan
w=$reg$(tput setaf 7) # white

bk=$reg$(tput setaf 8)  # bright black
br=$reg$(tput setaf 9)  # bright red
bg=$reg$(tput setaf 10) # bright green
by=$reg$(tput setaf 11) # bright yellow
bb=$reg$(tput setaf 12) # bright blue
bm=$reg$(tput setaf 13) # bright magenta
bc=$reg$(tput setaf 14) # bright cyan
bw=$reg$(tput setaf 15) # bright white

title='\[\e]0;'
endtitle=$(tput bel)'\]'

PS1="\n$bk$bld\t $b\h$bk:$g\w $y$bld\$(git-state)$reg\n\$ "
PS1+="$title\W$endtitle"


# completion
if [ -f /etc/bash_completion ]
	then source /etc/bash_completion
fi
if [ -f /usr/local/etc/bash_completion ]
	then source /usr/local/etc/bash_completion
fi
