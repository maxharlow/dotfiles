# colours
standard=0
bold=1
underlined=4
blinking=5
inversed=7
hidden=8

black=30
red=31
green=32
yellow=33
blue=34
magenta=35
cyan=36
white=37
lightblack=90
lightred=91
lightgreen=92
lightyellow=93
lightblue=94
lightmagenta=95
lightcyan=96
lightwhite=97

onblack=40
onred=41
ongreen=42
onyellow=43
onblue=44
onmagenta=45
oncyan=46
onwhite=47
onlightblack=100
onlightred=101
onlightgreen=102
onlightyellow=103
onlightblue=104
onlightmagenta=105
onlightcyan=106
onlightwhite=107


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

end="\e[${standard}m"
project="\e[${yellow}m"
path="\e[${green}m"
host="\e[${blue}m"
unimportant="\e[${lightblack}m"

PS1="\n\[$unimportant\t $host\h$unimportant:$path\w $project\$(git-short-status)$end\]\n\$ "
PS1="\e]0;\W\a$PS1"


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
filecolours="\
:no=$standard\
:fi=$lightblack\
:di=$underlined;$green\
:ln=$magenta\
:or=$blinking;$white;$onred\
:mi=$blinking;$white;$onred\
:ex=$bold;$red\
:*.app=$bold;$red\
:*.txt=$standard:*.md=$standard\
:*.sh=$yellow:*.h=$yellow:*.c=$yellow:*.cpp=$yellow:*.pl=$yellow:*.py=$yellow:*.rb=$yellow:*.php=$yellow:*.java=$yellow:*.scala=$yellow:*.sbt=$yellow:*.xml=$yellow:*.xsl=$yellow:*.html=$yellow:*.css=$yellow:*.js=$yellow:*.tex=$yellow:*.log=$yellow:*.properties=$yellow\
:*.zip=$bold;$magenta:*.rar=$bold;$magenta:*.tar=$bold;$magenta:*.gz=$bold;$magenta:*.bz=$bold;$magenta:*.bz2=$bold;$magenta:*.7z=$bold;$magenta:*.jar=$bold;$magenta:*.war=$bold;$magenta:*.iso=$bold;$magenta:*.dmg=$bold;$magenta:\
:*.rtf=$bold;$cyan:*.csv=$bold;$cyan:*.doc=$bold;$cyan:*.docx=$bold;$cyan:*.dot=$bold;$cyan:*.dotx=$bold;$cyan:*.xls=$bold;$cyan:*.xlsx=$bold;$cyan:*.ppt=$bold;$cyan:*.pptx=$bold;$cyan\
:*.bmp=$cyan:*.png=$cyan:*.jpeg=$cyan:*.jpg=$cyan:*.gif=$cyan:*.tiff=$cyan:*.svg=$cyan:*.svgz=$cyan:*.ps=$cyan:*.eps=$cyan:*.psd=$cyan\
:*.wav=$cyan:*.midi=$cyan:*.flac=$cyan:*.mka=$cyan:*.ogg=$cyan:*.mp3=$cyan:*.m4a=$cyan\
:*.mpeg=$cyan:*.mpg=$cyan:*.mp4=$cyan:*.m4v=$cyan:*.mkv=$cyan:*.ogv=$cyan"

if [[ "$OSTYPE" =~ 'linux' ]]
        then export LS_COLORS=$filecolours
elif [[ "$OSTYPE" =~ 'darwin' ]]
        then export LSCOLORS=$filecolours
fi


# aliases
if [[ "$OSTYPE" =~ 'linux' ]]
	then lscolourflag='--color=auto'
elif [[ "$OSTYPE" =~ 'darwin' ]]
	then lscolourflag='-G'
fi

alias ls="ls -hF --group-directories-first $lscolourflag"
alias ll='ls -loA'
alias tree='tree --dirsfirst  -C'
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
