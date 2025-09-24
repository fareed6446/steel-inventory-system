@echo off
echo 🏭 Steel Factory Inventory - Windows Build Script
echo =================================================

REM Check if PowerShell is available
powershell -Command "Get-Host" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PowerShell is not available. Please install PowerShell.
    pause
    exit /b 1
)

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0build-windows.ps1" %*

pause
