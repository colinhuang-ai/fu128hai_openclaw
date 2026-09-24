# OpenClaw trên Ubuntu WSL

Bộ script cài đặt và quản lý [OpenClaw](https://docs.openclaw.ai/install) (trợ lý AI cá nhân, chạy gateway cục bộ) trên Ubuntu WSL2.

## Yêu cầu
- Windows 10/11 có WSL2 + Ubuntu (`wsl --install -d Ubuntu`)
- systemd bật trong WSL (`install.sh` tự bật nếu thiếu)
- Node 24.16+ (installer chính thức tự cài nếu thiếu)

## Scripts (`scripts/`)

| Script | Chức năng |
|---|---|
| `install.sh [--no-onboard] [--force]` | Cài phụ thuộc, cài OpenClaw, bật linger, chạy `openclaw onboard --install-daemon` |
| `update.sh [--dry-run]` | Sao lưu `openclaw.json` rồi `openclaw update --yes` (tự restart gateway) |
| `status.sh [--fix]` | Xem version, trạng thái gateway, chạy `openclaw doctor` |
| `gateway.sh <start\|stop\|restart\|status\|logs\|dashboard\|reinstall>` | Quản lý systemd service `openclaw-gateway` |
| `uninstall.sh [--purge]` | Gỡ service + CLI; `--purge` xóa `~/.openclaw` (có sao lưu) |
| `run-in-wsl.ps1 <script> [args]` | Chạy các script trên từ PowerShell Windows |

## Cách dùng

Từ PowerShell (Windows):
```powershell
cd openclaw\scripts
.\run-in-wsl.ps1 install
.\run-in-wsl.ps1 status
.\run-in-wsl.ps1 gateway restart
.\run-in-wsl.ps1 update
```

Hoặc trực tiếp trong Ubuntu:
```bash
cd /mnt/d/Training/2026-09_02aiagent-code/openclaw/scripts
bash install.sh
```

Dashboard: http://127.0.0.1:18789/ (hoặc `bash gateway.sh dashboard`).

## Lưu ý
- Cấu hình: `~/.openclaw/openclaw.json`; bản sao lưu: `~/openclaw-backups/`.
- Nếu `status.sh` báo *"Gateway service uses Node from a version manager"* (do dùng nvm), chạy `gateway.sh reinstall` để tạo lại service file.
