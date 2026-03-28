@echo off
setlocal EnableDelayedExpansion

:: Paths
set "UC_LAUNCH=C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UbisoftConnect.exe"
set "WD2_EXE=C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\games\WATCH_DOGS2\bin_plus\WatchDogs2.exe"

echo ============================================
echo   WatchDogs2 Launcher - Debug Mode
echo ============================================
echo.

:: Check if Ubisoft Connect is already running
echo Checking if Ubisoft Connect is already running...
set "UC_WAS_RUNNING=0"
tasklist /FI "IMAGENAME eq upc.exe" 2>nul | find /i "upc.exe" >nul && set "UC_WAS_RUNNING=1"

if "!UC_WAS_RUNNING!"=="1" (
    echo [INFO] Ubisoft Connect is already running.
) else (
    echo [INFO] Ubisoft Connect not running. Launching it now...
    start "" "!UC_LAUNCH!"
    call :wait_for_process "upc.exe"
    echo [INFO] Waiting 10 seconds for Ubisoft Connect to initialize...
    timeout /t 10 /nobreak >nul
)

echo.
echo [INFO] Launching Watch Dogs 2...
start "" "!WD2_EXE!"

echo [INFO] Waiting for Watch Dogs 2 process to start...
call :wait_for_process "WatchDogs2.exe"

:: Give WD2 time to reach the splash screen
echo [INFO] Waiting 5 seconds for splash screen...
timeout /t 5 /nobreak >nul

echo.
echo [INFO] WD2 splash should be visible now.
echo [INFO] Keeping Ubisoft Connect in foreground for 20 seconds...

set "FOCUS_COUNT=0"

:focus_loop
set /a FOCUS_COUNT+=1
powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).AppActivate('Ubisoft Connect')" >nul 2>&1
echo [FOCUS] Attempt !FOCUS_COUNT! of 20
timeout /t 1 /nobreak >nul
if !FOCUS_COUNT! LSS 20 goto focus_loop

echo.
echo ============================================
echo   Handshake complete. Enjoy the game!
echo ============================================
echo.
echo Press any key to close this window...
pause >nul
endlocal
exit /b

:wait_for_process
echo [WAIT] Waiting for %~1...
:wait_loop
tasklist /FI "IMAGENAME eq %~1" 2>nul | find /i "%~1" >nul
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto wait_loop
)
echo [WAIT] %~1 is now running.
goto :eof
