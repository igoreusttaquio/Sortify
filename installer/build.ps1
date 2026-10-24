# Builds Sortify for Windows and packages it into an installer with Inno Setup.
# Requires: Flutter desktop toolchain (VS "Desktop development with C++") and
# Inno Setup 6 (https://jrsoftware.org/isdl.php).
#
# Usage:  powershell -ExecutionPolicy Bypass -File installer\build.ps1
#         powershell -ExecutionPolicy Bypass -File installer\build.ps1 -Version 1.1.0

param(
  [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path $PSScriptRoot -Parent
Set-Location $projectRoot

Write-Host "==> flutter build windows --release" -ForegroundColor Cyan
flutter build windows --release --build-name $Version

$isccCandidates = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
  "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
)
$iscc = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) {
  throw "Inno Setup 6 nao encontrado. Instale em https://jrsoftware.org/isdl.php"
}

Write-Host "==> Compilando instalador com $iscc" -ForegroundColor Cyan
& $iscc "/DMyAppVersion=$Version" "installer\sortify.iss"

Write-Host "==> Pronto: dist\Sortify-Setup-$Version.exe" -ForegroundColor Green
