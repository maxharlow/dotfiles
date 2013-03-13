# colours
colouroff='\e[0m'

black='\e[0;30m'
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'
cyan='\e[0;36m'
white='\e[0;37m'
lightblack='\e[0;90m'
lightred='\e[0;91m'
lightgreen='\e[0;92m'
lightyellow='\e[0;93m'
lightblue='\e[0;94m'
lightpurple='\e[0;95m'
lightcyan='\e[0;96m'
lightwhite='\e[0;97m'

boldblack='\e[1;30m' 
boldred='\e[1;31m'
boldgreen='\e[1;32m'
boldyellow='\e[1;33m'
boldblue='\e[1;34m'
boldpurple='\e[1;35m'
boldcyan='\e[1;36m'
boldwhite='\e[1;37m'
boldlightblack='\e[1;90m'
boldlightred='\e[1;91m'
boldlightgreen='\e[1;92m'
boldlightyellow='\e[1;93m'
boldlightblue='\e[1;94m'
boldlightpurple='\e[1;95m'
boldlightcyan='\e[1;96m'
boldlightwhite='\e[1;97m'

onblack='\e[40m'
onred='\e[41m'
ongreen='\e[42m'
onyellow='\e[43m'
onblue='\e[44m'
onpurple='\e[45m'
oncyan='\e[46m'
onwhite='\e[47m'
onlightblack='\e[0;100m'
onlightred='\e[0;101m'
onlightgreen='\e[0;102m'
onlightyellow='\e[0;103m'
onlightblue='\e[0;104m'
onlightpurple='\e[0;105m'
onlightcyan='\e[0;106m'
onlightwhite='\e[0;107m'


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

PS1="\n\[$lightblack\t $blue\h$lightblack:$green\w $yellow\$(git-short-status)$colouroff\]\n\$ "
PS1="\e]0;\W\a$PS1"


# general
shopt -s nocasematch
shopt -s checkwinsize


# history
shopt -s histappend
shopt -s cmdhist

export HISTSIZE=100000
export HISTCONTROL=ignorespace:ignoredups


# autocompletion
if [ -f /etc/bash_completion ] && ! shopt -oq posix
	then . /etc/bash_completion
fi


# aliases
if [[ "$OSTYPE" =~ 'linux' ]]
	then lscolourflag='--color=auto'
elif [[ "$OSTYPE" =~ 'darwin' ]]
	then lscolourflag='-G'
fi

alias ls="ls -hF $lscolourflag"
alias ll='ls -la'
alias grep='grep --color=auto'
alias hgrep='history | grep '
alias share='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'


# functions
function extract {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xvjf $1   ;;
			*.tar.gz)  tar xvzf $1   ;;
			*.bz2)     bunzip2 $1    ;;
			*.rar)     rar x $1      ;;
			*.gz)      gunzip $1     ;;
			*.tar)     tar xvf $1    ;;
			*.tbz2)    tar xvjf $1   ;;
			*.tgz)     tar xvzf $1   ;;
			*.zip)     unzip $1      ;;
			*.Z)       uncompress $1 ;;
			*.7z)      7z x $1       ;;
			*)         echo "cannot extract '$1'" ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}
