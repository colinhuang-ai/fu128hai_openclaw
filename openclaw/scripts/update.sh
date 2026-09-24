#!/usr/bin/env bash
# Cập nhật OpenClaw lên bản mới nhất (tự restart gateway).
#
# Cách dùng:
#   ./update.sh            # cập nhật
#   ./update.sh --dry-run  # xem trước, không thay đổi gì
set -euo pipefail

echo "Phiên bản hiện tại: $(openclaw --version)"
openclaw update status || true

if [ "${1:-}" = "--dry-run" ]; then
  openclaw update --dry-run
  exit 0
fi

# Sao lưu cấu hình trước khi cập nhật
BACKUP_DIR="$HOME/openclaw-backups"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/openclaw-config-$(date +%Y%m%d-%H%M%S).tgz" -C "$HOME" .openclaw/openclaw.json
echo "Đã sao lưu openclaw.json vào $BACKUP_DIR"

if ! openclaw update --yes; then
  # Fallback: 'openclaw update' có thể lỗi ở bước "global install swap" do npm 11+
  # chặn install scripts (postinstall bundled plugins, koffi native build).
  # Cài thẳng bằng npm, cho phép scripts của các package cần thiết, rồi repair.
  echo "openclaw update thất bại — chuyển sang cài trực tiếp bằng npm..."
  systemctl --user stop openclaw-gateway.service || true
  npm install -g openclaw@latest --allow-scripts=@google/genai,koffi,protobufjs,openclaw
  hash -r
  openclaw update repair --yes
  systemctl --user start openclaw-gateway.service
  sleep 20  # gateway cần ~15s để sẵn sàng
fi

echo
echo "Sau cập nhật: $(openclaw --version)"
openclaw gateway status || true
