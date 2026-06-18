# Local Jekyll preview launcher for sunrisemvmtDEN.github.io
# Run this script to start the local preview server at http://127.0.0.1:4000

param(
    [switch]$NoLivereload
)

# Get the script's directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Add Ruby to PATH if not already there
$rubyBin = 'C:\Ruby34-x64\bin'
if ($env:Path -notlike "*$rubyBin*") {
    $env:Path = "$rubyBin;" + $env:Path
}

# Verify bundle works
try {
    bundle -v | Out-Null
} catch {
    Write-Host ""
    Write-Host "ERROR: bundle not found. Please ensure Ruby with DevKit is installed."
    Write-Host ""
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host ""
Write-Host "Starting Jekyll local preview server..."
Write-Host ""
Write-Host "Server will be available at: http://127.0.0.1:4000"
Write-Host "Press Ctrl+C to stop the server."
Write-Host ""

# Start Jekyll with livereload (unless --NoLivereload is passed)
if ($NoLivereload) {
    bundle exec jekyll serve --host 127.0.0.1 --port 4000
} else {
    bundle exec jekyll serve --livereload
}

# If server exits with error, prompt user
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Server exited with an error."
    Read-Host "Press Enter to close"
}
