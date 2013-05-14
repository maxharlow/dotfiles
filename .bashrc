# general
export EDITOR=emacs
export LESSOPEN="| lesspipe %s"

shopt -s nocasematch
shopt -s checkwinsize
shopt -s extglob
shopt -s no_empty_cmd_completion


# history
shopt -s histappend
shopt -s histverify
shopt -s cmdhist

export HISTSIZE=100000
export HISTCONTROL=ignorespace:ignoredups
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
alias tree='tree --dirsfirst -C'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias share='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias home-git="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"


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

function git-short-status {
	if ! git rev-parse --git-dir &> /dev/null
		then return 0
	fi

	gitbranch=$(git branch 2> /dev/null | sed -n '/^\*/s/^\* //p')

	if ! git diff --quiet 2> /dev/null
		then gitdirty='*'
	fi

	echo "($gitbranch)$gitdirty"
}


# prompt
norm=$(tput sgr0) # normal text

k=$(tput setaf 0) # black
r=$(tput setaf 1) # red
g=$(tput setaf 2) # green
y=$(tput setaf 3) # yellow
b=$(tput setaf 4) # blue
m=$(tput setaf 5) # magenta
c=$(tput setaf 6) # cyan
w=$(tput setaf 7) # white

lk='\e[90m' # light black

title='\e]0;'
endtitle=$(tput bel)

PS1="\n$lk\t $b\h$lk:$g\w $y\$(git-short-status)$norm\n\$ "
PS1+="$title\W$endtitle"


# completion
if [ -f /etc/bash_completion ]
	then source /etc/bash_completion
fi
if [ -f /usr/local/etc/bash_completion ]
	then source /usr/local/etc/bash_completion
fi
