@echo off
REM Local Jekyll preview launcher for sunrisemvmtDEN.github.io
REM Run this file to start the local preview server at http://127.0.0.1:4000

setlocal enabledelayedexpansion
cd /d "%~dp0"

REM Add Ruby to PATH if not already there
set "RUBY_BIN=C:\Ruby34-x64\bin"
echo %PATH% | find /I "%RUBY_BIN%" >nul
if errorlevel 1 (
    set "PATH=%RUBY_BIN%;%PATH%"
)

REM Verify bundle works
bundle -v >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: bundle not found. Please ensure Ruby with DevKit is installed.
    echo.
    pause
    exit /b 1
)

echo.
echo Starting Jekyll local preview server...
echo.
echo Server will be available at: http://127.0.0.1:4000
echo Press Ctrl+C to stop the server.
echo.

REM Start Jekyll with livereload
bundle exec jekyll serve --livereload

REM If server exits with error, pause so user can see the message
if errorlevel 1 (
    echo.
    echo Server exited with an error. Press any key to close this window.
    pause
)
