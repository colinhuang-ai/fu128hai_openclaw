# Chạy các script OpenClaw trong Ubuntu WSL từ PowerShell (Windows).
#
# Cách dùng: .\run-in-wsl.ps1 <install|update|status|gateway|uninstall> [tham số...]
# Ví dụ:
#   .\run-in-wsl.ps1 install              # cài đặt
#   .\run-in-wsl.ps1 install --no-onboard
#   .\run-in-wsl.ps1 status
#   .\run-in-wsl.ps1 gateway restart
#   .\run-in-wsl.ps1 update --dry-run
# Distro mặc định là Ubuntu; đổi bằng biến môi trường OPENCLAW_WSL_DISTRO.

$ErrorActionPreference = 'Stop'
$valid = 'install', 'update', 'status', 'gateway', 'uninstall'

$Script = $args[0]
if ($Script -notin $valid) {
    Write-Host "Cách dùng: .\run-in-wsl.ps1 <$($valid -join '|')> [tham số...]" -ForegroundColor Yellow
    exit 2
}
$ScriptArgs = @($args | Select-Object -Skip 1)
$Distro = if ($env:OPENCLAW_WSL_DISTRO) { $env:OPENCLAW_WSL_DISTRO } else { 'Ubuntu' }

if (-not ((wsl -l -q) -replace "`0", '' | Where-Object { $_.Trim() -eq $Distro })) {
    Write-Host "Chưa có distro '$Distro'. Cài bằng: wsl --install -d $Distro" -ForegroundColor Yellow
    exit 1
}

$winPath = Join-Path $PSScriptRoot "$Script.sh"
$wslPath = (wsl -d $Distro -- wslpath -a ($winPath -replace '\\', '/')).Trim()
$argLine = ($ScriptArgs | ForEach-Object { "'$_'" }) -join ' '

# Bỏ ký tự CRLF (nếu file bị Windows đổi xuống dòng) rồi chạy bằng login shell để nạp nvm/PATH
wsl -d $Distro -- bash -lc "tr -d '\r' < '$wslPath' > /tmp/openclaw-$Script.sh && bash /tmp/openclaw-$Script.sh $argLine"
exit $LASTEXITCODE
