#!/usr/bin/env bash
# Kiểm tra sức khỏe OpenClaw.
#
# Cách dùng:
#   ./status.sh        # version + gateway status + doctor (chỉ đọc)
#   ./status.sh --fix  # chạy thêm 'openclaw doctor --fix' để tự sửa lỗi
set -uo pipefail

echo "== Version =="
openclaw --version
openclaw update status 2>/dev/null | head -10

echo
echo "== Gateway =="
systemctl --user --no-pager status openclaw-gateway.service | head -5
openclaw gateway status

echo
echo "== Doctor =="
if [ "${1:-}" = "--fix" ]; then
  openclaw doctor --fix
else
  openclaw doctor --json >/dev/null && echo "doctor: OK" || openclaw doctor
fi
