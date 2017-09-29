#!/usr/bin/env zsh
# https://www.zsh.org/

###############################################################################
# LOCAL                                                                       #
###############################################################################

HIST_STAMPS=dd.mm.yyyy

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en
export LESSCHARSET=utf-8

###############################################################################
# PATH                                                                        #
###############################################################################

# directories to be prepended to $PATH
declare -a dirs_to_prepend
dirs_to_prepend=(
  "/usr/local/sbin"
  "/usr/local/git/bin"
  "/usr/local/"
  "/usr/local/mysql/bin"
  "/sw/bin/"
  "$HOME/bin"
  "$HOME/.rvm/bin"
  "/usr/local/opt/ruby/bin" # brew ruby
  "/usr/local/opt/coreutils/libexec/gnubin" # brew coreutils
	"/usr/local/opt/findutils/libexec/gnubin" # brew findutils
  "/usr/local/share/npm/bin" # brew npm
)

# explicitly configured $PATH
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

for dir in ${(k)dirs_to_prepend[@]}
do
  if [ -d ${dir} ]; then
    # if directory exist, then prepend to existing PATH
    PATH="${dir}:$PATH"
  fi
done

unset dirs_to_prepend

###############################################################################
# OPTIONS                                                                     #
###############################################################################

autoload -U colors && colors
eval "$(dircolors -b)"

# history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

# color mode
export TERM="xterm-256color"
export CLICOLOR=1
# vim as standard editor
export EDITOR="vim"
export USE_EDITOR=$EDITOR
# Visual Studio Code as standard visual editor
export VISUAL="code"
# less as standard pager
export PAGER="less"
# better file timestamp formatting
export TIME_STYLE="long-iso"
# MySQL promt: 'username@hostname [database]> '
export MYSQL_PS1="\u@\h [\d]> "

# don't beep
setopt no_beep
setopt no_hup

# assume "cd" when command is directory
setopt auto_cd

# don't run background jobs at lower priority
setopt no_bg_nice

# enable autocomplete within a word
setopt complete_in_word
# move the cursor to the end after autocomplete
setopt always_to_end
# don't beep if there is no autocompletion
setopt no_list_beep

# append to history, don't override
setopt append_history
# immediately append to history instead of waiting for shell exit
setopt inc_append_history
# same history for all shells
setopt share_history
# don't append immediate (difference to 'hist_ignore_all_dups') duplicates to history
setopt hist_ignore_dups
# remove commands starting with a space from history after next command is entered
setopt hist_ignore_space
# don't show duplicates when moving up history
setopt hist_find_no_dups
# remove duplicates in favor of unique last item in history
setopt hist_expire_dups_first
# remove blanks from commands before appending
setopt hist_reduce_blanks
# remove 'history' command from history after next command is entered
setopt hist_no_store
# don't immediately execute history commands
setopt hist_verify
# dont't beep if history entry does not exist
setopt no_hist_beep

# definitely ask for rm *
setopt no_rm_star_silent

###############################################################################
# COMPLETIONS                                                                 #
###############################################################################

autoload -Uz compinit
# check .zcompdump cache only once per day for speed
typeset -i updated_at=$(date +"%j" -r $HOME/.zcompdump 2>/dev/null || /usr/bin/stat -f "%Sm" -t "%j" $HOME/.zcompdump 2>/dev/null)
if [ $(date +"%j") != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
unset updated_at

# use completion cache
zstyle ':completion::complete:*' use-cache on
# set cache directory
zstyle ':completion::complete:*' cache-path $HOME/.zsh/cache

# completion functions
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
# text indicating the type
zstyle ':completion:*' format '--- %d ---'
# show completions listed by type
zstyle ':completion:*' group-name ''
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# menu completion if more than 1 match and matches don't fit screen
zstyle ':completion:*' menu select=2 select=long
# colored output
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
# first case-sensitive matches, then case-insensitive matches, then partial word matches
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# underline next different char
zstyle ':completion:*' show-ambiguity true
# complete users
zstyle ':completion:*' users root alexanderbast
# show command descriptions
zstyle ':completion:*' verbose true

# style’s value will be the description for options not described by functions
zstyle ':completion:*:options' auto-description '%d'

# pretty messages during pagination
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# nicer format for completion messages
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{202}%BSorry, no matches for: %F{214}%d%b'

# prettier completion for processes
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,args -w -w'

# cd only completes paths
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# cd ignores parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# ignore what is already selected for specific commands
zstyle ':completion::*:(git|less|rm|trash|cp|kill|diff|scp)' ignore-line true

# prettier completion for ssh and ssh-based services
zstyle ':completion:*:(ssh|scp|sshfs|sshrc):*' sort false
zstyle ':completion:*:(ssh|scp|sshfs|sshrc):*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:(scp|sshfs):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|sshfs):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:(ssh|sshrc):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(ssh|sshrc):*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|sshfs|sshrc):*:hosts-host' ignored-patterns '*(.|:)*' loopback localhost broadcasthost 'ip6-*'
zstyle ':completion:*:(ssh|scp|sshfs|sshrc):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|sshfs|sshrc):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.*' '255.255.255.255' '::1' 'fe80::*' 'ff02::*'

# search through history matching everything up to current cursor position
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

###############################################################################
# PLUGINS                                                                     #
###############################################################################

# use antibody - fastest
# https://getantibody.github.io/
source <(antibody init)

# pure promt
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure
# safe pasting
antibody bundle oz/safe-paste
# colored man
antibody bundle zuxfoucault/colored-man-pages_mod
# missing completions
antibody bundle zsh-users/zsh-completions
# better npm completions
antibody bundle lukechilds/zsh-better-npm-completion
# fish shell-like autosuggestions
antibody bundle zsh-users/zsh-autosuggestions
# fish shell-like syntax highlighting
antibody bundle zdharma/fast-syntax-highlighting
# fish shell-like history search
antibody bundle zdharma/history-search-multi-word

###############################################################################
# FUNCTIONS                                                                   #
###############################################################################

function extract {
  echo Extracting $1 ...
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1 ;;
      *.tar.gz)   tar xzf $1 ;;
      *.bz2)      bunzip2 $1 ;;
      *.rar)      rar x $1 ;;
      *.gz)       gunzip $1 ;;
      *.tar)      tar xf $1 ;;
      *.tbz2)     tar xjf $1 ;;
      *.tgz)      tar xzf $1 ;;
      *.zip)      unzip $1 ;;
      *.Z)        uncompress $1 ;;
      *.7z)       7z x $1 ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

###############################################################################
# ALIASES                                                                     #
###############################################################################

# expand sudo aliases
alias sudo="sudo "

# rm puts in trash
alias rm="trash"

# use sshrc for ssh
alias ssh="sshrc"

# npm and yarn list only top level
alias npml="npm list --depth=0"
alias yarnl="yarn list --depth=0"

# colors
alias ls="ls -F --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias less="less -nRq"

# misc
alias zshconfig="vim $HOME/.zshrc"
alias zshreload="source $HOME/.zshrc"
alias vimconfig="vim $HOME/.vimrc"
alias macupdate="softwareupdate -i -a; brew update; brew upgrade; brew cleanup; brew prune; npm outdated -g --parseable=true | cut -d : -f 4 | xargs -n 1 npm install -g; antibody update; brew cu -a -y; brew bundle dump --force --global;"
alias rni="kill $(lsof -t -i:8081); rm -rf ios/build/; react-native run-ios"
