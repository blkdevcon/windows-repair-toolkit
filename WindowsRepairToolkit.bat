@echo off
setlocal EnableDelayedExpansion

:: Require Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This toolkit must be run as Administrator.
    echo Right-click the file and select "Run as administrator".
    pause
    exit /b 1
)

:: Log file setup — Desktop\WRT_YYYY-MM-DD.log
set "LOGDATE=%date:~10,4%-%date:~4,2%-%date:~7,2%"
set "LOGFILE=%USERPROFILE%\Desktop\WRT_%LOGDATE%.log"

goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:LOG
::  Usage: call :LOG "message"
echo %~1
echo [%time%] %~1 >> "%LOGFILE%"
goto :eof

:: ─────────────────────────────────────────────────────────────────────────────
:MENU
cls
echo.
echo  ################################################################
echo  ##                                                            ##
echo  ##         W I N D O W S   R E P A I R   T O O L K I T        ##
echo  ##   ======================================================   ## 
echo  ##             Windows Diagnostic and Repair Tools            ##
echo  ##                                                            ##
echo  ################################################################
  
echo   Log: %LOGFILE%

echo  ================================================================
echo.
echo   [1]  System File Checker (SFC)
echo   [2]  DISM Restore Health
echo   [3]  DISM Scan Health
echo   [4]  Check Disk Errors (C:)
echo   [5]  Windows Component Cleanup
echo   [6]  Reset Winsock Network
echo   [7]  Reset TCP/IP
echo   [8]  Flush DNS Cache
echo   [9]  DISM Check Health
echo   [10] System Information
echo   [11] Run Recommended Repair Sequence
echo   [12] Driver Query
echo   [13] Signed Drivers Info
echo   [14] Device Problem Scan
echo   [15] Install Missing Drivers
echo   [16] Scan RAM
echo.
echo   [0]  Exit
echo.
set /p "CHOICE=  Select an option: "

if "%CHOICE%"=="1"  goto :OPT_SFC
if "%CHOICE%"=="2"  goto :OPT_DISM_RESTORE
if "%CHOICE%"=="3"  goto :OPT_DISM_SCAN
if "%CHOICE%"=="4"  goto :OPT_CHKDSK
if "%CHOICE%"=="5"  goto :OPT_CLEANUP
if "%CHOICE%"=="6"  goto :OPT_WINSOCK
if "%CHOICE%"=="7"  goto :OPT_TCPIP
if "%CHOICE%"=="8"  goto :OPT_DNS
if "%CHOICE%"=="9"  goto :OPT_DISM_CHECK
if "%CHOICE%"=="10" goto :OPT_SYSINFO
if "%CHOICE%"=="11" goto :OPT_SEQUENCE
if "%CHOICE%"=="12" goto :OPT_DRIVERQUERY
if "%CHOICE%"=="13" goto :OPT_DRIVERSIGNED
if "%CHOICE%"=="14" goto :OPT_DEVPROBLEM
if "%CHOICE%"=="15" goto :OPT_INSTALLMISSING
if "%CHOICE%"=="16" goto :OPT_SCANRAM
if "%CHOICE%"=="0"  goto :EXIT
echo   Invalid selection. Try again.
timeout /t 2 >nul
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_SFC
cls
call :LOG "=== [1] System File Checker (SFC) ==="
echo Running SFC /scannow - this may take several minutes...
sfc /scannow
echo. >> "%LOGFILE%"
call :LOG "=== SFC complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DISM_RESTORE
cls
call :LOG "=== [2] DISM RestoreHealth ==="
echo Running DISM /RestoreHealth - this may take 10-20 minutes...
DISM /Online /Cleanup-Image /RestoreHealth
echo. >> "%LOGFILE%"
call :LOG "=== DISM RestoreHealth complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DISM_SCAN
cls
call :LOG "=== [3] DISM ScanHealth ==="
DISM /Online /Cleanup-Image /ScanHealth
echo. >> "%LOGFILE%"
call :LOG "=== DISM ScanHealth complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_CHKDSK
cls
call :LOG "=== [4] Check Disk Errors (C:) ==="
echo.
echo NOTE: If C: is in use, chkdsk will be scheduled for the next reboot.
echo.
chkdsk C: /f /r /x
echo. >> "%LOGFILE%"
call :LOG "=== Check Disk complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_CLEANUP
cls
call :LOG "=== [5] Windows Component Cleanup ==="
echo Running DISM component cleanup...
DISM /Online /Cleanup-Image /StartComponentCleanup
echo. >> "%LOGFILE%"
call :LOG "=== Component Cleanup complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_WINSOCK
cls
call :LOG "=== [6] Reset Winsock Network ==="
netsh winsock reset
netsh int ip reset
echo. >> "%LOGFILE%"
call :LOG "=== Winsock reset complete - reboot recommended ==="
echo A reboot is recommended to apply Winsock changes.
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_TCPIP
cls
call :LOG "=== [7] Reset TCP/IP ==="
netsh int tcp reset
netsh int ipv4 reset
netsh int ipv6 reset
echo. >> "%LOGFILE%"
call :LOG "=== TCP/IP reset complete - reboot recommended ==="
echo A reboot is recommended to apply TCP/IP changes.
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DNS
cls
call :LOG "=== [8] Flush DNS Cache ==="
ipconfig /flushdns
ipconfig /registerdns
echo. >> "%LOGFILE%"
call :LOG "=== DNS flush complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DISM_CHECK
cls
call :LOG "=== [9] DISM CheckHealth ==="
DISM /Online /Cleanup-Image /CheckHealth
echo. >> "%LOGFILE%"
call :LOG "=== DISM CheckHealth complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_SYSINFO
cls
call :LOG "=== [10] System Information ==="
systeminfo
echo. >> "%LOGFILE%"
call :LOG "=== System Information complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_SEQUENCE
cls
call :LOG "=== [11] Recommended Repair Sequence ==="
echo Running full repair sequence. This will take 20-40 minutes.
echo Output is being logged to: %LOGFILE%
echo.

echo [1/4] DISM CheckHealth...
call :LOG "--- Step 1/4: DISM CheckHealth ---"
DISM /Online /Cleanup-Image /CheckHealth

echo.
echo [2/4] DISM ScanHealth...
call :LOG "--- Step 2/4: DISM ScanHealth ---"
DISM /Online /Cleanup-Image /ScanHealth

echo.
echo [3/4] DISM RestoreHealth...
call :LOG "--- Step 3/4: DISM RestoreHealth ---"
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [4/4] System File Checker (SFC)...
call :LOG "--- Step 4/4: SFC scannow ---"
sfc /scannow

echo.
echo. >> "%LOGFILE%"
call :LOG "=== Recommended Repair Sequence complete ==="
echo Sequence finished. Review output above or check the log on your Desktop.
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DRIVERQUERY
cls
call :LOG "=== [12] Driver Query ==="
echo Listing all installed drivers with verbose detail...
echo NOTE: Output will be large. Scroll up or check the log file.
echo.
driverquery /v
echo. >> "%LOGFILE%"
call :LOG "=== Driver Query complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DRIVERSIGNED
cls
call :LOG "=== [13] Signed Drivers Info ==="
echo Listing signed driver status for all installed drivers...
echo.
driverquery /si
echo. >> "%LOGFILE%"
call :LOG "=== Signed Drivers Info complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_DEVPROBLEM
cls
call :LOG "=== [14] Device Problem Scan ==="
echo Scanning for devices with driver problems...
echo Devices listed below have missing, broken, or misconfigured drivers.
echo (No output means no driver problems were detected.)
echo.
pnputil /enum-devices /problem
echo. >> "%LOGFILE%"
call :LOG "=== Device Problem Scan complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_INSTALLMISSING
cls
call :LOG "=== [15] Install Missing Drivers ==="
echo Scanning hardware and attempting to install missing drivers...
echo Windows will pull from the local driver store and Windows Update.
echo This may take a few minutes. No output means no new drivers were needed.
echo.
pnputil /scan-devices
echo. >> "%LOGFILE%"
call :LOG "=== Install Missing Drivers complete ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:OPT_SCANRAM
cls
call :LOG "=== [16] Scan RAM ==="
echo Scheduling Windows Memory Diagnostic...
echo NOTE: A reboot is required to run the scan. You will be prompted to restart now or on next boot.
echo.
mdsched.exe
echo. >> "%LOGFILE%"
call :LOG "=== Scan RAM scheduled ==="
pause
goto :MENU

:: ─────────────────────────────────────────────────────────────────────────────
:EXIT
cls
echo.
echo  Windows Repair Toolkit closed.
echo  Log saved to: %LOGFILE%
echo.
timeout /t 3 >nul
endlocal
exit /b 0
