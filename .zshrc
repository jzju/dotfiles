HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt RM_STAR_SILENT
setopt autocd
setopt extendedglob
setopt interactivecomments
setopt nocaseglob
setopt prompt_subst
autoload -U colors
bindkey \^U backward-kill-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source ~/.zsh_alias

# eval "$(ssh-agent -s)" > /dev/null && ssh-add ~/.ssh/id_rsa 2> /dev/null
# export SSH_AUTH_SOCK=$(ls -t /tmp/ssh-**/* | head -1)

if [ -f ~/.zsh_local ]; then
  source ~/.zsh_local
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

git_info() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="$(git branch 2> /dev/null | awk '/^\*/ { print $2 }')"
  local untracked_files="Untracked files:"
  local not_staged="Changes not staged for commit:"
  local staged="Changes to be committed:"
  local ahead="Your branch is ahead of"
  local behind="Your branch is behind"

  local msg="%F{blue}$on_branch"
  if [[ $git_status =~ $untracked_files
    || $git_status =~ $not_staged
    || $git_status =~ $staged
    || $git_status =~ $ahead
    || $git_status =~ $behind ]]; then
    msg+=" "
    if [[ $git_status =~ $untracked_files ]]; then
      msg+="%F{white}U"
    fi
    if [[ $git_status =~ $not_staged ]]; then
      msg+="%F{red}N"
    fi
    if [[ $git_status =~ $staged ]]; then
      msg+="%F{green}S"
    fi
  fi
  if [[ $git_status =~ $ahead ]]; then
    msg+="%F{yellow}A"
  fi
  if [[ $git_status =~ $behind ]]; then
    msg+="%F{yellow}B"
  fi
  echo -e "%B$msg%b"
}

PROMPT='%F{yellow}%0~%f% %(#~%F{red}#~%F{green}$)%f '
RPROMPT='$(git_info)%b %F{green}%m%f'
