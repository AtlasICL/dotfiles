#!/usr/bin/env bash

# Some custom functions for git.
# Needs to be sourced in rc file.

# Oh My Zsh's git plugin (and similar) define some of these names as aliases.
# zsh refuses to define a function whose name is an existing alias, so remove
# any conflicting aliases first. No-op in bash or if the alias is absent.
# Note: `gb` is intentionally omitted so Oh My Zsh's `gb='git branch'` survives.
unalias gbw rbm squash git_main_branch 2>/dev/null || true

# Get main branch name (main or master)
git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return 1
    if git show-ref -q --verify refs/heads/main; then
        echo main
    elif git show-ref -q --verify refs/heads/master; then
        echo master
    else
        echo "Neither 'main' nor 'master' branch found." >&2
        return 1
    fi
}

# List branches and worktrees (gb is left to Oh My Zsh's `git branch` alias)
gbw() {
    echo "=== Branches ==="
    git branch -v
    echo ""
    echo "=== Worktrees ==="
    git worktree list
}

# Rebase the current branch onto the main branch
rbm() {
    local branch
    branch=$(git_main_branch) || return 1
    git rebase "$branch"
}

# Soft-reset to the merge-base with main, staging all commits since divergence for a single squash commit
squash() {
    local branch
    branch=$(git_main_branch) || return 1
    printf "Squashing with %s as head\n" "$branch"
    git reset --soft "$(git merge-base "$branch" "$(git branch --show-current)")"
    echo "Remember to git commit -m 'Commit message'"
}
