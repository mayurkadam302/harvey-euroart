# Harvey - EuroArt UAE lead finder (no email is sent: email is off, send limit 0, sending paused)
# Run from this folder in PowerShell:  powershell -ExecutionPolicy Bypass -File .\run-harvey-leads.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Harvey version this setup was tested against (ethanplusai/harvey, 1 Nov 2026)
$HarveyRepo = "https://github.com/ethanplusai/harvey.git"
$HarveyCommit = "6b6a23a789090e165802baef4104ee4618a3e169"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Install Git for Windows from git-scm.com, then run this again."
    exit 1
}
if (-not (Get-Command py -ErrorAction SilentlyContinue) -and -not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python is not installed. Install Python 3.11 or newer from python.org (tick 'Add to PATH'), then run this again."
    exit 1
}

if (-not (Test-Path "harvey\.git")) {
    Write-Host "Downloading Harvey..."
    git clone --quiet $HarveyRepo harvey
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
    git -C harvey checkout --quiet $HarveyCommit
    if ($LASTEXITCODE -ne 0) { throw "git checkout failed" }
}

# Apply the UAE trade categories once (skipped if already applied)
$patch = Join-Path $PSScriptRoot "osm-uae-trades.patch"
git -C harvey apply --reverse --check $patch 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding UAE trade categories to the OpenStreetMap source..."
    git -C harvey apply $patch
    if ($LASTEXITCODE -ne 0) { throw "Could not apply osm-uae-trades.patch" }
}

Copy-Item -Force "harvey.local.yaml" "harvey\harvey.local.yaml"
Set-Location "harvey"

if (-not (Test-Path ".venv")) {
    Write-Host "First run: installing Harvey (takes a few minutes)..."
    if (Get-Command py -ErrorAction SilentlyContinue) { py -3 -m venv .venv } else { python -m venv .venv }
    .\.venv\Scripts\python.exe -m pip install --upgrade pip
    .\.venv\Scripts\python.exe -m pip install -e .
}

$harvey = ".\.venv\Scripts\harvey.exe"
& $harvey sending pause
& $harvey signals --confirm free
Write-Host "Searching OpenStreetMap for UAE contractors, fit-out, joinery, door, hardware, locksmith and architect firms..."
& $harvey discover --limit 200
Write-Host "Writing the company list..."
& $harvey companies
Write-Host "Done. Open companies.csv in the harvey folder (it may also be under its data folder)."
