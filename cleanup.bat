@echo off
:: =======================================================
:: ⚡ Windows Cleanup & Programmer Booster
:: Version: 4.2 (Final Fix)
:: =======================================================

:: --- Fix Emoji/Text Encoding ---
chcp 65001 >nul

:: --- Auto elevate to admin ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%~f0\"' -Verb runAs"
    exit /b
)

title "⚡ Windows Cleanup & Programmer Booster"
color 0a
cls

echo =====================================================
echo 🚀 Starting System ^& Dev Cleanup
echo =====================================================
echo.

:: --- Ask for deep system repair ---
set "deepScan="
set /p deepScan="Run deep repair (SFC & DISM)? (Y/N): "
echo.

:: --- Record free space before cleanup (MB) ---
echo Measuring disk space...
for /f "usebackq tokens=*" %%A in (`powershell -command "[math]::round((Get-PSDrive C).Free / 1MB)"`) do set FreeBefore=%%A

:: --- Function for safe folder cleanup ---
setlocal enabledelayedexpansion

call :cleanFolder "%temp%" "User Temp"
call :cleanFolder "%windir%\Temp" "Windows Temp"
call :cleanFolder "%systemroot%\Prefetch" "Prefetch"
call :cleanFolder "%windir%\SoftwareDistribution\Download" "Windows Update Cache"
call :cleanFolder "%ProgramData%\Microsoft\Windows\WER" "Error Reports"
call :cleanFolder "%windir%\Logs" "Windows Logs"
call :cleanFolder "%windir%\Panther" "Setup Logs"
call :cleanFolder "%LocalAppData%\Microsoft\Windows\INetCache" "Internet Cache"

:: --- Clear Recycle Bin ---
echo Emptying Recycle Bin...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

:: --- Clear Delivery Optimization cache ---
echo Cleaning Delivery Optimization cache...
rd /s /q "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" 2>nul
md "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" >nul 2>&1

:: --- Clear browser caches ---
echo Cleaning Chrome ^& Edge caches...
for %%i in (
    "%LocalAppData%\Google\Chrome\User Data\Default\Cache"
    "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache"
) do (
    if exist "%%~i" (
        del /f /s /q "%%~i\*.*" >nul 2>&1
        for /d %%x in ("%%~i\*") do rd /s /q "%%x" 2>nul
    )
)

:: --- Flush DNS ---
echo Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

:: --- Clear event logs ---
echo Clearing event logs...
for /F "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" >nul 2>&1

:: --- Reset Microsoft Store cache ---
echo Resetting Microsoft Store cache...
wsreset -i >nul 2>&1

:: --- Optional Dev Cleanup ---
set "devCleanup="
set /p devCleanup="Do you want to clean node_modules, build, and dist folders? (Y/N): "
if /I "%devCleanup%"=="Y" (
    echo Cleaning dev folders...
    :: Change this path to where your projects are
    for /d %%P in ("%UserProfile%\Projects\*") do (
        if exist "%%P\node_modules" (
            echo Deleting node_modules in %%P ...
            rd /s /q "%%P\node_modules"
        )
        if exist "%%P\build" (
            echo Deleting build folder in %%P ...
            rd /s /q "%%P\build"
        )
        if exist "%%P\dist" (
            echo Deleting dist folder in %%P ...
            rd /s /q "%%P\dist"
        )
    )
)

:: --- Optional Deep System Repair ---
if /I "%deepScan%"=="Y" (
    echo Running System File Checker...
    sfc /scannow
    echo.
    echo Running DISM health restore...
    DISM /Online /Cleanup-Image /RestoreHealth
)

:: --- Optional Startup Optimization ---
set "optStartup="
set /p optStartup="Do you want to disable non-essential startup apps? (Y/N): "
if /I "%optStartup%"=="Y" (
    echo Disabling unnecessary startup apps...
    powershell -Command "Get-CimInstance Win32_StartupCommand | ForEach-Object { Disable-ScheduledTask -TaskName $_.Name -ErrorAction SilentlyContinue }"
)

:: --- Disk Optimization ---
echo Optimizing Drive C (Smart Trim/Defrag)...
defrag C: /O /U /V >nul

:: --- Free Memory ---
echo Freeing memory...
powershell -Command "$null=[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers()"

:: --- Free space summary (MB) ---
for /f "usebackq tokens=*" %%B in (`powershell -command "[math]::round((Get-PSDrive C).Free / 1MB)"`) do set FreeAfter=%%B

:: --- Calculate Result ---
set /a SavedSpace=%FreeAfter%-%FreeBefore%

echo.
echo =====================================================
echo ✅ Cleanup ^& Programmer Boost Complete!
echo =====================================================
echo Free space before: %FreeBefore% MB
echo Free space after:  %FreeAfter% MB
echo -----------------------------------------------------
echo 🗑️ TOTAL CLEANED:   %SavedSpace% MB
echo =====================================================
pause
exit /b

:: --- Function Definitions ---
:cleanFolder
set "target=%~1"
set "name=%~2"
if exist "%target%" (
    echo Cleaning %name%...
    del /f /s /q "%target%\*.*" >nul 2>&1
    for /d %%x in ("%target%\*") do rd /s /q "%%x" 2>nul
)
exit /b