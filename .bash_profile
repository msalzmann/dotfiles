# .bash_profile

# Exports
export LSCOLORS=Dxfxcxdxbxegedabagacad
export TERM=xterm-256color
export EDITOR=vim
export SVNEDITOR=vim
# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"
# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'
# Keep plenty of history.
export HISTSIZE=1000000
export HISTFILESIZE=${HISTSIZE}
exportHISTCONTROL=ignoreboth
# Shortcut to the dotfiles path
export DOTF=$HOME/.dotfiles
# rbenv initiation (done before next PATH statement!)
if which rbenv >/dev/null 2>&1; then
   eval "$(rbenv init -)"
fi

# Always append to histroy...
shopt -s histappend
# ... and write it down after each command
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Incremental search in history using up/down keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# colored ls output
alias ls='ls -G'
# setup alias vi instead of using /usr/bin/vi
# due to exit code issues on macOS
alias vi="vim"
# brewup onliner to keep things up2date
alias brewup='brew update && brew upgrade && brew cleanup; brew doctor'
# ssh connect to jumphost
alias syslp='ssh syslp.unibe.ch -l admmasalzmann'
# ssh connect to moon
alias moon='ssh moonlp.linkpc.net -l heimdall'

# source bash completion installed by homebrew if available
if hash brew 2>/dev/null; then
    BREW_COMP_DIR=`brew --prefix`/etc/bash_completion.d
    if [[ -d $BREW_COMP_DIR && -r $BREW_COMP_DIR && \
        -x $BREW_COMP_DIR ]]; then
        for i in $(LC_ALL=C command ls "$BREW_COMP_DIR"); do
            i=$BREW_COMP_DIR/$i
            [[ -f $i && -r $i ]] && . "$i"
        done
    fi
fi

# gopath initialization
if which go >/dev/null 2>&1
then
   export GOPATH=$HOME/Developer/go
   export PATH=$GOPATH/bin:$PATH
fi


GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto verbose"

# build command prompt
ps1_prompt() {
    local ps1_exit=$?
    local ps1_status="\!"
    local YELLOW="\[\033[1;33m\]"
    local GREEN="\[\033[32m\]"
    local RED="\[\033[31m\]"
    local NOCLR="\[\033[0m\]"

    # define user/hosts and directory string
    if [ $UID -eq 0 ]; then
        local HOSTCOLOR=$RED
        local PSEND="#"
    else
        local HOSTCOLOR=$GREEN
        local PSEND="\$"
    fi
    local ps1_host=" ${HOSTCOLOR}\u@\h${NOCLR}"
    local ps1_dir=" ${YELLOW}\W${NOCLR}"

    # setup exit status string
    if [ $ps1_exit -ne 0 ]; then
        local ps1_status="${RED}\!${NOCLR}"
    fi

    # setup git repo string
    ps1_git=""
    if test "$(type -t __git_ps1)" = "function"; then
        ps1_git="${RED}"$(__git_ps1)"${NOCLR}"
    fi

    PS1="${ps1_status}${ps1_host}${ps1_dir}${ps1_git} \$ "
}
# preserve earlier PROMPT_COMMAND entries
PROMPT_COMMAND="ps1_prompt;$PROMPT_COMMAND"

# Build path
export PATH=bin:$DOTF/bin:$PATH

