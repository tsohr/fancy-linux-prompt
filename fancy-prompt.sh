#!/usr/bin/env bash

[ -n "$BASH_VERSION" ] || return 0

[[ $- == *i* ]] || return 0


__powerline() {
    # Unicode symbols
    GIT_BRANCH_CHANGED_SYMBOL='+'
    GIT_NEED_PULL_SYMBOL='⇣'
    GIT_NEED_PUSH_SYMBOL='⇡'
    PS_SYMBOL='🐧'

    # Solarized colorscheme
    BG_BASE00="\\[$(tput setab 11)\\]"
    BG_BASE01="\\[$(tput setab 10)\\]"
    BG_BASE02="\\[$(tput setab 0)\\]"
    BG_BASE03="\\[$(tput setab 8)\\]"
    BG_BASE0="\\[$(tput setab 12)\\]"
    BG_BASE1="\\[$(tput setab 14)\\]"
    BG_BASE2="\\[$(tput setab 7)\\]"
    BG_BASE3="\\[$(tput setab 15)\\]"
    BG_BLUE="\\[$(tput setab 4)\\]"
    BG_COLOR1="\\[\\e[48;5;240m\\]"
    BG_COLOR2="\\[\\e[48;5;238m\\]"
    BG_COLOR3="\\[\\e[48;5;238m\\]"
    BG_COLOR4="\\[\\e[48;5;31m\\]"
    BG_COLOR5="\\[\\e[48;5;31m\\]"
    BG_COLOR6="\\[\\e[48;5;237m\\]"
    BG_COLOR7="\\[\\e[48;5;237m\\]"
    BG_COLOR8="\\[\\e[48;5;161m\\]"
    BG_COLOR9="\\[\\e[48;5;161m\\]"
    BG_CYAN="\\[$(tput setab 6)\\]"
    BG_GREEN="\\[$(tput setab 2)\\]"
    BG_MAGENTA="\\[$(tput setab 5)\\]"
    BG_ORANGE="\\[$(tput setab 9)\\]"
    BG_RED="\\[$(tput setab 1)\\]"
    BG_VIOLET="\\[$(tput setab 13)\\]"
    BG_YELLOW="\\[$(tput setab 3)\\]"
    BOLD="\\[$(tput bold)\\]"
    DIM="\\[$(tput dim)\\]"
    FG_BASE00="\\[$(tput setaf 11)\\]"
    FG_BASE01="\\[$(tput setaf 10)\\]"
    FG_BASE02="\\[$(tput setaf 0)\\]"
    FG_BASE03="\\[$(tput setaf 8)\\]"
    FG_BASE0="\\[$(tput setaf 12)\\]"
    FG_BASE1="\\[$(tput setaf 14)\\]"
    FG_BASE2="\\[$(tput setaf 7)\\]"
    FG_BASE3="\\[$(tput setaf 15)\\]"
    FG_BLUE="\\[$(tput setaf 4)\\]"
    FG_COLOR1="\\[\\e[38;5;250m\\]"
    FG_COLOR2="\\[\\e[38;5;240m\\]"
    FG_COLOR3="\\[\\e[38;5;250m\\]"
    FG_COLOR4="\\[\\e[38;5;238m\\]"
    FG_COLOR6="\\[\\e[38;5;31m\\]"
    FG_COLOR7="\\[\\e[38;5;250m\\]"
    FG_COLOR8="\\[\\e[38;5;237m\\]"
    FG_COLOR9="\\[\\e[38;5;161m\\]"
    FG_CYAN="\\[$(tput setaf 6)\\]"
    FG_GREEN="\\[$(tput setaf 2)\\]"
    FG_MAGENTA="\\[$(tput setaf 5)\\]"
    FG_ORANGE="\\[$(tput setaf 9)\\]"
    FG_RED="\\[$(tput setaf 1)\\]"
    FG_VIOLET="\\[$(tput setaf 13)\\]"
    FG_YELLOW="\\[$(tput setaf 3)\\]"
    RESET="\\[$(tput sgr0)\\]"
    REVERSE="\\[$(tput rev)\\]"

    __git_info() {
        # no .git directory
    	[ -d .git ] || return

        local aheadN
        local behindN
        local branch
        local marks
        local stats

        # get current branch name or short SHA1 hash for detached head
        branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        # how many commits local branch is ahead/behind of remote?
        stats="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        aheadN="$(echo "$stats" | grep -o 'ahead \d\+' | grep -o '\d\+')"
        behindN="$(echo "$stats" | grep -o 'behind \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        # branch is modified?
        if [ -n "$(git status --porcelain)" ]; then
            printf "%s" "${BG_COLOR8}$RESET$BG_COLOR8 $branch$marks $FG_COLOR9"
        else
            printf "%s" "${BG_BLUE}$RESET$BG_BLUE $branch$marks $RESET$FG_BLUE"
        fi
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ "$?" -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
            local FG_EXIT="$FG_GREEN"
        else
            local BG_EXIT="$BG_RED"
            local FG_EXIT="$FG_RED"
        fi


	if [ "$EUID" -eq 0 ]; then
          PS1="$FG_COLOR4"
          PS1+="$BG_YELLOW \\w "
          PS1+="$RESET${FG_YELLOW}"
	else
          PS1="$FG_COLOR1"
	  PS1+="$BG_COLOR5 \\w "
          PS1+="$RESET${FG_COLOR6}"
	fi
        PS1+="$(__git_info)"
        PS1+="$BG_EXIT$RESET"
        PS1+="$BG_EXIT$FG_BASE3 ${PS_SYMBOL} ${RESET}${FG_EXIT}${RESET} "
    }

    PROMPT_COMMAND=ps1
}
# Skip if not interactive shell
[[ $- == *i* ]] || return
__powerline
unset __powerline
