#!/usr/bin/env bash
# Cài đặt OpenClaw trên Ubuntu (WSL2).
#
# Cách dùng:
#   ./install.sh               # cài + chạy wizard onboarding (cài luôn gateway systemd)
#   ./install.sh --no-onboard  # chỉ cài CLI, onboarding làm sau
#   ./install.sh --force       # cài lại dù đã có openclaw
set -euo pipefail

NO_ONBOARD=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --no-onboard) NO_ONBOARD=1 ;;
    --force) FORCE=1 ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "Tham số không hợp lệ: $arg" >&2; exit 2 ;;
  esac
done

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$*"; }

# 1. Môi trường
log "Kiểm tra môi trường"
grep -qi microsoft /proc/version || warn "Không phát hiện WSL — script vẫn chạy được trên Ubuntu thường."
. /etc/os-release && echo "OS: $PRETTY_NAME"

# 2. systemd (bắt buộc để gateway chạy nền và tự khởi động)
if [ "$(ps -p 1 -o comm=)" != "systemd" ]; then
  warn "systemd chưa bật trong WSL. Đang bật trong /etc/wsl.conf..."
  if ! grep -q '^systemd=true' /etc/wsl.conf 2>/dev/null; then
    printf '[boot]\nsystemd=true\n' | sudo tee -a /etc/wsl.conf >/dev/null
  fi
  warn "Hãy chạy 'wsl --shutdown' trong PowerShell, mở lại Ubuntu rồi chạy lại script này."
  exit 1
fi
echo "systemd: OK"

# 3. Đã cài chưa?
if command -v openclaw >/dev/null 2>&1 && [ "$FORCE" -eq 0 ]; then
  echo "OpenClaw đã được cài: $(openclaw --version)"
  echo "Dùng ./update.sh để cập nhật, hoặc ./install.sh --force để cài lại."
  exit 0
fi

# 4. Gói hệ thống cần thiết
log "Cài gói phụ thuộc (curl, git, build-essential)"
sudo apt-get update -y
sudo apt-get install -y curl git ca-certificates build-essential

# 5. Cài OpenClaw bằng installer chính thức (tự cài Node nếu thiếu, cần Node 24.16+)
log "Cài OpenClaw"
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard

# Nạp lại PATH (installer có thể vừa cài Node/nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
hash -r
command -v openclaw >/dev/null || { warn "Không tìm thấy lệnh openclaw — mở terminal mới rồi thử 'openclaw --version'."; exit 1; }
echo "Đã cài: $(openclaw --version)"

# 6. Cho phép user service chạy khi chưa đăng nhập shell
sudo loginctl enable-linger "$USER" || true

# 7. Onboarding + cài gateway dạng systemd user service
if [ "$NO_ONBOARD" -eq 0 ]; then
  log "Chạy onboarding (chọn model provider, API key, kênh chat...)"
  openclaw onboard --install-daemon
else
  warn "Bỏ qua onboarding. Chạy sau bằng: openclaw onboard --install-daemon"
fi

# 8. Kiểm tra
log "Kiểm tra sau cài đặt"
openclaw --version
openclaw gateway status || true
echo
echo "Xong. Dashboard: http://127.0.0.1:18789/  (hoặc chạy: openclaw dashboard)"
