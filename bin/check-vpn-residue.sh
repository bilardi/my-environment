#!/usr/bin/env bash
# check-vpn-residue.sh: check (and optionally fix) VPN residue in WiFi profiles
#
# Usage:
#   bash check-vpn-residue.sh          # report only
#   bash check-vpn-residue.sh --fix    # report + fix + reload NM

set -euo pipefail

# Safety check: if VPN is active, don't touch DNS
if ip link show ppp0 &>/dev/null; then
  echo "WARNING: ppp0 (VPN) is active — disconnect first before fixing WiFi DNS"
  exit 1
fi

CONNECTIONS=(
  "/etc/NetworkManager/system-connections/zorma-ti-ga-sbaglia-linea.nmconnection"
  "/etc/NetworkManager/system-connections/xorma-ti-ga-sbaglia-linea 1.nmconnection"
)

FIX=false
if [[ "${1:-}" == "--fix" ]]; then
  FIX=true
fi

DIRTY=false

for conn in "${CONNECTIONS[@]}"; do
  name=$(basename "$conn")
  echo "--- $name ---"

  if [[ ! -f "$conn" ]]; then
    echo "  file not found, skipping"
    echo
    continue
  fi

  dns=$(grep -E "^dns=" "$conn" | head -1 || true)
  dns_search=$(grep -E "^dns-search=" "$conn" | head -1 || true)
  ignore_auto=$(grep -E "^ignore-auto-dns=" "$conn" || true)

  echo "  dns:              ${dns:-<not set>}"
  echo "  dns-search:       ${dns_search:-<not set>}"
  echo "  ignore-auto-dns:  ${ignore_auto:-<not set>}"

  issues=()
  if [[ -n "$dns" && "$dns" != "dns=" ]]; then
    issues+=("dns has VPN servers")
  fi
  if [[ -n "$dns_search" && "$dns_search" != "dns-search=" && "$dns_search" != "dns-search=;" ]]; then
    issues+=("dns-search has VPN domain")
  fi
  if echo "$ignore_auto" | grep -q "ignore-auto-dns=true"; then
    issues+=("ignore-auto-dns is true")
  fi

  if [[ ${#issues[@]} -eq 0 ]]; then
    echo "  status: clean"
  else
    DIRTY=true
    for issue in "${issues[@]}"; do
      echo "  RESIDUE: $issue"
    done

    if $FIX; then
      echo "  fixing..."
      sudo sed -i 's/^dns=.*/dns=/' "$conn"
      sudo sed -i 's/^dns-search=.*/dns-search=/' "$conn"
      sudo sed -i 's/^ignore-auto-dns=true/ignore-auto-dns=false/' "$conn"
      echo "  done"
    fi
  fi
  echo
done

if $FIX && $DIRTY; then
  echo "reloading NetworkManager..."
  sudo nmcli connection reload
  echo "done"
  echo
  echo "reconnect to WiFi or run: sudo nmcli connection up <name>"
fi

if ! $FIX && $DIRTY; then
  echo "run with --fix to clean up"
fi