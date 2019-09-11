#!/bin/bash

color_prompt=yes
export HOME=/home/cybersec
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
cd $HOME

alias la='ls -A'
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

tmux unbind-key d

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  tmux attach -rt 0
else
  echo "start";
fi

