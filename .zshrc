# general
export EDITOR=emacs
setopt NOCLOBBER # don't overwrite existing files


# colours
export LESS_TERMCAP_md=$(tput bold) # bold
export LESS_TERMCAP_us=$(tput smul) # underlined
export LESS_TERMCAP_ue=$(tput rmul) # end underlined
export LESS_TERMCAP_so=$(tput bold; tput setaf 0; tput setab 6) # standout (bold black on cyan)
export LESS_TERMCAP_se=$(tput sgr 0) # end standout

export LS_COLORS='di=32:ln=35:so=34:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export LSCOLORS='cxfxexdxbxegedabagacad'


# history
export HISTSIZE=100000 # lines to keep in memory
export SAVEHIST=100000 # lines to save to disc
export HISTTIMEFORMAT='%F %T '
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS


# general keys
bindkey -e
bindkey '^q' push-line # stash current command and come back to it after


# move by word
autoload -U select-word-style
select-word-style bash # only alphanumerics are words
bindkey '[C' forward-word
bindkey '[D' backward-word


# incremental search
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward


# edit commands
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line


# aliases
alias ls='ls -hFG'
alias ll='ls -loA'
alias less='less -R'
alias tree='tree --dirsfirst -C'
alias grep='grep --color=auto'
alias home-git="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
alias e='emacs'


# completion
export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' expand prefix suffix 
zstyle ':completion:*' list-colors $LS_COLORS


# prompt
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '•'
zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:git*' formats ' (%b)%u'

precmd() {
    vcs_info
    echo -ne "\e]0;${$(basename $PWD)//$(basename $HOME)/~}\a"
}

PROMPT='
%B%*%b %F{green}%~%f%B%F{yellow}${vcs_info_msg_0_}%f%b%(0?..%(130?.. %F{blue}{%?}%f))
$ '
