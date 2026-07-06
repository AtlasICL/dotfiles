#!/usr/bin/env bash

# Some custom functions for working with tmux.
# This file needs to be sourced in bash/zsh rc file.
# **Requires:** fzf.

# Create a new session (with optional name)
tnew() {
    tmux new-session ${1:+-s "$1"}
}

# List sessions in aligned columns
tls() {
    local tab out table header rule
    tab=$(printf '\t')
    # tmux does not interpret \t in -F, so pass a real tab via $tab and let
    # `column` align on it (spaces within fields are preserved).
    out=$(tmux list-sessions -F "#{session_name}${tab}#{session_windows}${tab}#{?session_attached,attached,-}" 2>/dev/null)
    if [ -z "$out" ]; then
        echo "No tmux sessions."
        return
    fi
    table=$({ printf "SESSION${tab}WINDOWS${tab}STATUS\n"; printf '%s\n' "$out"; } | column -t -s "$tab")
    header=${table%%$'\n'*}                        # first (header) line
    rule=$(printf '%s' "$header" | tr '[:print:]' '-')  # dashed rule, full width
    # header, top rule, session rows, bottom rule
    printf '%s\n%s\n%s\n%s\n' "$header" "$rule" "${table#*$'\n'}" "$rule"
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
