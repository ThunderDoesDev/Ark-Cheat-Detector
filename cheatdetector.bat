@echo off
setlocal enabledelayedexpansion

:: Check for administrative privileges
openfiles >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo [INFO] Requesting administrative privileges...
    powershell -Command "Start-Process -Verb runAs -FilePath '%~0'"
    exit /b
)

:: Console banner
echo ==========================================
echo         Cheat Detection Script
echo ==========================================
echo Developed by: ThunderDoesDev
echo Version: 1.1
echo ==========================================

:: Set the location of the log file
set "logFile=%USERPROFILE%\Desktop\cheat_scan.log"
set cheatFound=0

:: Get PC Name
set pcName=%COMPUTERNAME%

:: Initialize the log file with headers and current date/time
(
    echo ==========================================
    echo         Cheat Detection Script
    echo ==========================================
    echo Developed by: ThunderDoesDev
    echo Version: 1.1
    echo ==========================================
    echo Date: %date% Time: %time%
    echo PC Name: %pcName%
    echo ==========================================
) > "%logFile%"

:: Function to search for files
:searchFiles
echo [INFO] Starting cheat scan...
echo [INFO] Searching for cheat files...
echo [%date% %time%] Searching for cheat files... >> "%logFile%"

:: Define the search paths and terms
set searchPaths=("%USERPROFILE%\AppData\Local\Packages\StudioWildcard.4558480580BB9_1w2mm55455e38\AC\Temp\" "%USERPROFILE%\AppData\Local" "C:\Program Files" "C:\Program Files (x86)" "%USERPROFILE%" "C:\Windows\Prefetch" "%USERPROFILE%\Downloads" "C:\$Recycle.Bin")
set searchTerms=("headshot" "primal" "unleashed" "proofcore" "ring-1" "arkinjector" "extreme injector" "HSLoaderUpdater.exe" "UWPHelper.exe" "addicted" "HSLoader.exe" "HSUWPHelper.exe" "RDPCheck.exe" "rdp" "wallhax" "Client_32.exe")

:: Loop through each search path and search term
for %%d in %searchPaths% do (
    if exist %%d (
        echo [INFO] Searching in %%d...
        echo [%date% %time%] Searching in %%d >> "%logFile%"
        for %%t in %searchTerms% do (
            dir /s /b %%d | findstr /i /c:"%%t" >> "%logFile%"
            if !errorlevel! equ 0 (
                echo [ALERT] Cheat detected: %%t found in %%d
                echo Cheat detected: %%t found in %%d >> "%logFile%"
                set cheatFound=1
            )
        )
    )
)
goto searchProcesses

:: Function to search for suspicious processes
:searchProcesses
echo [INFO] Checking for suspicious processes...
echo [%date% %time%] Checking for suspicious processes... >> "%logFile%"

:: Loop through each search term and check running processes
for %%t in %searchTerms% do (
    tasklist | findstr /i /c:"%%t" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat process detected: %%t
        echo Cheat process detected: %%t >> "%logFile%"
        set cheatFound=1
    )
)
goto checkNetwork

:: Function to check network connections
:checkNetwork
echo [INFO] Checking network connections...
echo [%date% %time%] Checking network connections... >> "%logFile%"

:: Loop through each search term and check network connections
for %%t in %searchTerms% do (
    netstat -anob | findstr /i /c:"%%t" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat-related network activity detected: %%t
        echo Cheat-related network activity detected: %%t >> "%logFile%"
        set cheatFound=1
    )
)
goto checkRegistry

:: Function to check the registry for cheat entries
:checkRegistry
echo [INFO] Checking registry for cheat entries...
echo [%date% %time%] Checking registry for cheat entries... >> "%logFile%"

:: Loop through each search term and check specific registry keys
for %%t in %searchTerms% do (
    reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run /s | findstr /i /c:"%%t" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat detected in registry: %%t
        echo Cheat detected in registry: %%t >> "%logFile%"
        set cheatFound=1
    )
    reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run /s | findstr /i /c:"%%t" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat detected in registry: %%t
        echo Cheat detected in registry: %%t >> "%logFile%"
        set cheatFound=1
    )
)
goto checkWinRAR

:: Function to check WinRAR's recent files
:checkWinRAR
echo [INFO] Checking WinRAR recent files for cheat entries...
echo [%date% %time%] Checking WinRAR recent files for cheat entries... >> "%logFile%"

for %%t in %searchTerms% do (
    reg query HKCU\Software\WinRAR\ArcHistory /s | findstr /i /c:"%%t" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat detected in WinRAR history: %%t
        echo Cheat detected in WinRAR history: %%t >> "%logFile%"
        set cheatFound=1
    )
)
goto additionalPowershellChecks

:: Function for additional checks using PowerShell
:additionalPowershellChecks
echo [INFO] Performing additional checks using PowerShell...
echo [%date% %time%] Performing additional checks using PowerShell... >> "%logFile%"

:: Execute PowerShell commands for more thorough checks
for %%t in %searchTerms% do (
    powershell -Command "Get-Process | Where-Object { $_.Path -like '*%%t*' } | Format-Table -Property Name, Id, Path" >> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat process detected in PowerShell: %%t
        echo Cheat process detected in PowerShell: %%t >> "%logFile%"
        set cheatFound=1
    )
)
powershell -Command "Get-ChildItem -Path '%USERPROFILE%' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'headshot|primal|unleashed|proofcore|ring-1|arkinjector|extreme injector|HSLoaderUpdater.exe|UWPHelper.exe|addicted|HSLoader.exe|HSUWPHelper.exe|rdp|RDPCheck.exe|wallhax|Client_32.exe' } | Format-Table -Property FullName" >> "%logFile%"
powershell -Command "Get-ChildItem -Path 'C:\Windows\Prefetch' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'headshot|primal|unleashed|proofcore|ring-1|arkinjector|extreme injector|HSLoaderUpdater.exe|UWPHelper.exe|addicted|HSLoader.exe|HSUWPHelper.exe|rdp|RDPCheck.exe|wallhax|Client_32.exe' } | Format-Table -Property FullName" >> "%logFile%"

:: Check Windows Defender Protection History
echo [INFO] Checking Windows Defender Protection History for cheat terms...
echo [%date% %time%] Checking Windows Defender Protection History for cheat terms... >> "%logFile%"

for %%t in %searchTerms% do (
    powershell -Command "Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Windows Defender/Operational'} | Where-Object { $_.Message -like '*%%t*' } | Format-Table -Property TimeCreated, Message" >> "%logFile%" 2>> "%logFile%"
    if !errorlevel! equ 0 (
        echo [ALERT] Cheat term detected in Defender logs: %%t
        echo Cheat term detected in Defender logs: %%t >> "%logFile%"
        set cheatFound=1
    )
)

:: Log the completion of the Defender scan
echo [%date% %time%] Defender history check complete. >> "%logFile%"

:: Finalize the log
if !cheatFound! equ 0 (
    echo [INFO] No cheats detected.
    echo No cheats detected. >> "%logFile%"
) else (
    echo [ALERT] Cheats were detected during the scan.
    echo Cheats were detected during the scan. >> "%logFile%"
)

(
    echo.
    echo [%date% %time%] Scan complete. Results saved to %logFile%
    echo ======================
) >> "%logFile%"

echo [INFO] Scan complete. Check %logFile% for details.

endlocal
exit /b %ERRORLEVEL%
