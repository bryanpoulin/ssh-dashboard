#!/bin/zsh
# ssh-status: SSH dashboard & auto-fix for macOS

ssh-status() {
  local GREEN="\033[32m"
  local RED="\033[31m"
  local RESET="\033[0m"

  local show_dashboard
  show_dashboard() {
    local missing_keys=0
    echo

    # ssh-agent process
    echo -n "▶ ssh-agent process: "
    if ps aux | grep '[s]sh-agent' >/dev/null; then
      echo -e "${GREEN}✅ Running${RESET}"
    else
      echo -e "${RED}❌ Not running${RESET}"
    fi

    # SSH_AUTH_SOCK
    echo -n "▶ SSH_AUTH_SOCK: "
    if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
      echo -e "${GREEN}✅ $SSH_AUTH_SOCK${RESET}"
    else
      echo -e "${RED}❌ Not set or socket missing${RESET}"
    fi

    echo
    echo "▶ Loaded keys:"

    local keys
    keys=$(find ~/.ssh -type f -not -name '*.pub' -not -name 'config' -not -name 'known_hosts')

    for key in $keys; do
      local comment
      comment=$(ssh-keygen -lf "$key" | awk '{print $3}')
      if ssh-add -l | grep -q "$comment"; then
        echo -e "  ${GREEN}✅${RESET} $key ($comment)"
      else
        echo -e "  ${RED}❌${RESET} $key ($comment)"
        missing_keys=$((missing_keys + 1))
      fi
    done

    return $missing_keys
  }

  # Show dashboard and store missing keys count
  show_dashboard
  local missing=$?

  # Summary line at top
  if [ $missing -eq 0 ]; then
    echo -e "${GREEN}✅ All keys loaded${RESET}"
  else
    echo -e "${RED}❌ Some keys missing${RESET}"
    echo
    echo -e "${RED}Running ssh-fix to reload missing keys...${RESET}"
    ssh-fix
    # Refresh dashboard
    show_dashboard
  fi
}

ssh-fix() {
  echo "🔑 Reloading all SSH private keys into macOS Keychain..."
  local keys
  keys=$(find ~/.ssh -type f -not -name '*.pub' -not -name 'config' -not -name 'known_hosts')

  if [ -z "$keys" ]; then
    echo "❌ No private keys found in ~/.ssh"
    return 1
  fi

  for key in $keys; do
    echo "→ Adding $key..."
    ssh-add --apple-use-keychain "$key" 2>/dev/null
  done

  echo
  echo "▶ Loaded keys:"
  ssh-add -l || echo "❌ No keys loaded"
}
