@echo off
setlocal

:: Paths
set UC_LAUNCH="C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UbisoftConnect.exe"
set WD2_EXE="C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\games\WATCH_DOGS2\bin_plus\WatchDogs2.exe"

echo Starting Ubisoft Connect...
start "" %UC_LAUNCH%

:: Wait for upc.exe to exist
echo Waiting for upc.exe...
set /a upc_wait=0

:wait_upc
tasklist | find /i "upc.exe" >nul
if errorlevel 1 (
    set /a upc_wait+=1
    if %upc_wait% GTR 15 (
        echo.
        echo Error Code: LNF001UC
        echo Ubisoft Connect (upc.exe) could not be found.
        echo Copy this and contact ContentApple on GitHub.
        echo.
        pause
        exit /b
    )
    timeout /t 1 >nul
    goto wait_upc
)

echo Ubisoft Connect is running.

:: Check if WD2 exists before launching
if not exist %WD2_EXE% (
    echo.
    echo Error Code: LNF002WD2
    echo Watch Dogs 2 executable not found at:
    echo %WD2_EXE%
    echo Copy this and contact the developer on GitHub: Contentapple
    echo.
    pause
    exit /b
)

echo Launching Watch Dogs 2...
start "" %WD2_EXE%

echo Forcing Ubisoft Connect to foreground for handshake...
set /a tries=0

:focus_loop
set /a tries+=1
if %tries% GTR 20 goto done_focus

powershell -command "(New-Object -ComObject WScript.Shell).AppActivate('Ubisoft Connect')" 2>nul

timeout /t 1 >nul
goto focus_loop

:done_focus
echo UPC has finished focusing.
endlocal
exit /b
