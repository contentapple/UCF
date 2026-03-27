@echo off
setlocal

:: Paths
set UC_LAUNCH="C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UbisoftConnect.exe"
set WD2_EXE="C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\games\WATCH_DOGS2\bin_plus\WatchDogs2.exe"

echo Starting Ubisoft Connect...
start "" %UC_LAUNCH%

:: Wait for upc.exe to exist
echo Waiting for upc.exe...
:wait_upc
tasklist | find /i "upc.exe" >nul
if errorlevel 1 (
    timeout /t 1 >nul
    goto wait_upc
)

echo Ubisoft Connect is running.

echo Launching Watch Dogs 2...
start "" %WD2_EXE%

:: Now we spam‑focus the UC window for a short window of time
echo Forcing Ubisoft Connect to foreground for handshake...
set /a tries=0

:focus_loop
set /a tries+=1
if %tries% GTR 20 goto done_focus

:: Try to bring the "Ubisoft Connect" window to front
powershell -command "(New-Object -ComObject WScript.Shell).AppActivate('Ubisoft Connect')" 2>nul

:: Small delay between focus attempts
timeout /t 1 >nul
goto focus_loop

:done_focus
echo Ubisoft Connect has been open long enough, enjoy your game!
endlocal
exit /b
