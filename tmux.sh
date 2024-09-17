#!/bin/bash

tmux split-window -h
tmux resize-pane -R 30
tmux split-window -v
tmux select-pane -t 0
nvim

