#!/usr/bin/env bash
# VMware host-only static IP workaround (hashicorp/vagrant#5000)
set -euo pipefail

IP="${1:?missing ip argument}"

mapfile -t IFACES < <(ip -o link show | awk -F': ' '!/lo/ {gsub(/@.*/, "", $2); print $2}')
TARGET_IFACE=""

for iface in "${IFACES[@]}"; do
  if ! ip -4 addr show "${iface}" 2>/dev/null | grep -q 'inet '; then
    TARGET_IFACE="${iface}"
    break
  fi
done

if [ -z "${TARGET_IFACE}" ] && [ "${#IFACES[@]}" -ge 2 ]; then
  TARGET_IFACE="${IFACES[1]}"
elif [ -z "${TARGET_IFACE}" ] && [ "${#IFACES[@]}" -ge 1 ]; then
  TARGET_IFACE="${IFACES[0]}"
fi

if [ -z "${TARGET_IFACE}" ]; then
  echo "No network interface found for static IP ${IP}" >&2
  exit 1
fi

ip addr flush dev "${TARGET_IFACE}" 2>/dev/null || true
ip addr add "${IP}/24" dev "${TARGET_IFACE}"
ip link set "${TARGET_IFACE}" up
