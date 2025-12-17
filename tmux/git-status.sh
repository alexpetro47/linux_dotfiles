#!/bin/bash
# Combined git branch + status for tmux status-right
# Usage: git-status.sh /path/to/dir
cd "$1" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

# Single git status -sb gives branch + status in one call
status=$(git status -sb 2>/dev/null) || exit 0

# Extract branch from first line: "## branch...tracking"
branch=$(echo "$status" | head -1 | sed 's/^## //;s/\.\.\..*//;s/No commits yet on //')

# Count status indicators from remaining lines
counts=$(echo "$status" | tail -n +2 | awk '
  /^.M/||/^M/{m++} /^A|^.A/{a++} /^.D|^D/{d++} /^\?\?/{u++}
  END{s=""; if(m)s=s" ~"m; if(a)s=s" +"a; if(d)s=s" -"d; if(u)s=s" ?"u; print s}')

[ -n "$branch" ] && printf " %s%s" "$branch" "$counts"
