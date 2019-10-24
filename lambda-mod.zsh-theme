#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[green]%}λ,%{$fg_bold[red]%}λ)"
local XI="%(?,%{$fg_bold[green]%}Ξ,%{$fg_bold[red]%}Ξ)"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="yellow"; fi

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [[ -z $(git_prompt_info 2> /dev/null) ]]; then
      echo "%{$fg[blue]%}detached-head%{$reset_color%}) $(git_prompt_status)\n$(print_end)"
    else
      echo "$(git_prompt_info 2> /dev/null) $(git_prompt_status)\n$(print_end)"
    fi
  else
    echo "$(print_end)"
  fi
}

function print_end() {
  echo "%{$fg_bold[cyan]%}→ "
}

function print_virtual_env_info() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo " %{$fg_bold[yellow]%}$(virtualenv_prompt_info)"
  fi
}

function print_username() {
  if [[ "$ZSH_THEME_PRINT_USERNAME" == true ]]; then
    echo -n " %{$fg_bold[$USERCOLOR]%}%n"
  fi
}

function print_machine() {
  if [[ "$ZSH_THEME_PRINT_MACHINE" == true ]]; then
    echo -n " %{$fg_bold[green]%}[%m]"
  fi
}

function print_jobs() {
  if [[ "$ZSH_THEME_PRINT_JOBS" == true ]]; then
    local jobs_pwd="%{$fg_bold[cyan]%}%(1j. ( %j ).)"
    echo -n "$jobs_pwd"
  fi
}

function print_cwd() {
  if [[ "$ZSH_THEME_PRINT_CWD" == true ]]; then
    echo -n " %{$fg_bold[magenta]%}[%3~]"
  fi
}

function get_left_prompt() {
  if [[ ! -z "$SSH_CLIENT" ]]; then
    # ssh session, different prompt (robbyrussel)
    local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
    ret_status+="%{$fg[cyan]%}%c%{$reset_color%}$(print_virtual_env_info) $(check_git_prompt_info)%{$reset_color%}"
    # echo "\n$ret_status"
    echo "\n$XI %{$fg[cyan]%}%c%{$reset_color%}$(print_virtual_env_info) $(check_git_prompt_info)%{$reset_color%}"
  else
    echo "\n$LAMBDA$(print_username)$(print_machine)$(print_jobs)$(print_cwd)$(print_virtual_env_info) $(check_git_prompt_info)%{$reset_color%}"
  fi
}

function get_right_prompt() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -n "$(git_prompt_short_sha)%{$reset_color%}"
  else
    echo -n "%{$reset_color%}"
  fi
}

PROMPT='$(get_left_prompt)'

# RPROMPT='$(get_right_prompt)'

# Theme config
ZSH_THEME_PRINT_USERNAME=false
ZSH_THEME_PRINT_MACHINE=false
ZSH_THEME_PRINT_JOBS=true
ZSH_THEME_PRINT_CWD=true

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="at %{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"
