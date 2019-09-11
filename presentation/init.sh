#!/bin/bash
set -e

color_prompt=yes
alias la='ls -A'
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  tmux attach -rt 0