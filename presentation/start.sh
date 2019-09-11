#!/bin/bash
set -e

sudo HOME=/home/cybersec -u cybersec tmux new-session -d &
/usr/sbin/sshd -D

