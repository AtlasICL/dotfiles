#!/usr/bin/env bash

# Some custom functions for working with tmux.
# This file needs to be sourced in bash/zsh rc file.
# **Requires:** fzf.

# Create a new session (with optional name)
tnew() {
    tmux new-session ${1:+-s "$1"}
}

# List sessions with nice formatting
tls() {
    tmux list-sessions -F '#{session_name}: #{session_windows} window(s)#{?session_attached, (attached),}' 2>/dev/null \
        || echo "No tmux sessions."
}

# Kill specific session by name (using fzf)
tkill(){
    local session
    session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --no-sort --prompt 'kill session > ') || return
    [ -n "$session" ] && tmux kill-session -t "$session"
}

# Kill all sessions
tkillall(){
    tmux kill-server 2>/dev/null && echo "All tmux sessions killed." \
        || echo "No tmux server running."
}

# Attach to session by name (using fzf)
tattach() {
    local session
    session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --no-sort --prompt 'attach > ') || return
    [ -n "$session" ] && tmux attach-session -t "$session"
}
