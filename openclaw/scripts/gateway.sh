#!/usr/bin/env bash
# Quản lý gateway OpenClaw (systemd user service).
#
# Cách dùng: ./gateway.sh <start|stop|restart|status|logs|dashboard|reinstall>
#   logs       theo dõi log realtime
#   dashboard  mở Control UI (http://127.0.0.1:18789/)
#   reinstall  cài lại service file (sửa cảnh báo "service config out of date")
set -euo pipefail

SERVICE=openclaw-gateway.service

case "${1:-}" in
  start|stop|restart)
    systemctl --user "$1" "$SERVICE"
    systemctl --user --no-pager status "$SERVICE" | head -5
    ;;
  status)    openclaw gateway status ;;
  logs)      journalctl --user -u "$SERVICE" -f -n 100 ;;
  dashboard) openclaw dashboard ;;
  reinstall)
    openclaw gateway install --force
    systemctl --user restart "$SERVICE"
    openclaw gateway status
    ;;
  *) sed -n '2,7p' "$0"; exit 2 ;;
esac
