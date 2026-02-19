''
cld() {
  export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1
  if [ -z "$NOTIFICATIONS" ]; then
    export NOTIFICATIONS=true
  fi
  if [ "$1" = "-p" ]; then
    claude --dangerously-skip-permissions -p "$2"
  elif [ "$1" = "-r" ]; then
    claude --dangerously-skip-permissions -r
  elif [ "$1" = "-np" ]; then
    claude --dangerously-skip-permissions
  elif [ "$1" = "--noyo" ]; then
    claude --permission-mode plan
  else
    # start in plan mode, with permissions bypassed
    claude --dangerously-skip-permissions "/plan"
  fi
}
''
