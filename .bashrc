# prompt
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

x='\e[0m' # uncoloured
y='\e[33m' # yellow
g='\e[32m' # green
b='\e[34m' # blue
lb='\e[90m' # light black
titlestart='\e]0;'
titleend='\a'

PS1="\n\[$lb\t $b\h$lb:$g\w $y\$(git-short-status)$x\]\n\$ "
PS1="$titlestart\W$titleend$PS1"


# general
export EDITOR=emacs

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


# completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix
	then . /etc/bash_completion
fi


# colours
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
alias tree='tree --dirsfirst  -C'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias share='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias git-home="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"


# functions
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
		*)	       	echo "cannot extract: $1" ;;
	esac
}
