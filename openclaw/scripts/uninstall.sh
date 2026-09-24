#!/usr/bin/env bash
# Gỡ OpenClaw.
#
# Cách dùng:
#   ./uninstall.sh          # gỡ gateway service + CLI, GIỮ dữ liệu ~/.openclaw
#   ./uninstall.sh --purge  # xóa luôn ~/.openclaw (có sao lưu .tgz trước)
set -euo pipefail

PURGE=0
[ "${1:-}" = "--purge" ] && PURGE=1

read -r -p "Gỡ OpenClaw khỏi máy này? [y/N] " ans
[[ "$ans" =~ ^[Yy]$ ]] || { echo "Đã hủy."; exit 0; }

SERVICE=openclaw-gateway.service
systemctl --user disable --now "$SERVICE" 2>/dev/null || true
rm -f "$HOME/.config/systemd/user/$SERVICE"
systemctl --user daemon-reload

npm uninstall -g openclaw || true

if [ "$PURGE" -eq 1 ] && [ -d "$HOME/.openclaw" ]; then
  BACKUP="$HOME/openclaw-backups/openclaw-full-$(date +%Y%m%d-%H%M%S).tgz"
  mkdir -p "$(dirname "$BACKUP")"
  tar -czf "$BACKUP" -C "$HOME" .openclaw
  rm -rf "$HOME/.openclaw"
  echo "Đã xóa ~/.openclaw (bản sao lưu: $BACKUP)"
fi

echo "Đã gỡ OpenClaw."
