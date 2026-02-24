@echo off
setlocal

echo ============================================
echo   TeamRecordings Setup
echo   - Maps Z: drive
echo   - Sets Snipping Tool save to Z:\
echo   - Auto-sorts into dated folders:
echo     Z:\COMPUTERNAME\YYYY-MM-DD\Screenshots\
echo     Z:\COMPUTERNAME\YYYY-MM-DD\Screen Recordings\
echo ============================================
echo.

REM --- Remove existing Z: mapping if any ---
net use Z: /delete /yes >nul 2>&1

REM --- Map Z: drive ---
echo Connecting to TeamRecordings...
echo Username: workstation_4_india@outlook.com
echo Please enter the password when prompted.
echo.
net use Z: \\100.124.248.113\TeamRecordings /persistent:yes /user:workstation_4_india@outlook.com *

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not map drive. Check password and try again.
    pause
    exit /b 1
)

echo.
echo Z: drive mapped successfully!

REM --- Create base folders ---
if not exist "Z:\%COMPUTERNAME%"                    mkdir "Z:\%COMPUTERNAME%"
if not exist "Z:\%COMPUTERNAME%\Screen Recordings"  mkdir "Z:\%COMPUTERNAME%\Screen Recordings"

REM --- Fix Snipping Tool save locations ---
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video"                              /t REG_EXPAND_SZ /d "Z:\%COMPUTERNAME%"                   /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" /t REG_EXPAND_SZ /d "Z:\%COMPUTERNAME%"                   /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" /t REG_EXPAND_SZ /d "Z:\%COMPUTERNAME%\Screen Recordings" /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"      /v "My Video"                              /t REG_SZ        /d "Z:\%COMPUTERNAME%"                   /f >nul
echo Snipping Tool paths set.

REM --- Install organizer script ---
set "APPDIR=%LOCALAPPDATA%\TeamRecordings"
if not exist "%APPDIR%" mkdir "%APPDIR%"

echo Extracting organizer script...
powershell -ExecutionPolicy Bypass -Command "$b64='IyBSZWNvcmRpbmdPcmdhbml6ZXIucHMxCiMgV2F0Y2hlcyBaOlxDT01QVVRFUk5BTUVcIGFuZCBaOlxDT01QVVRFUk5BTUVcU2NyZWVuIFJlY29yZGluZ3NcCiMgTW92ZXMgZmlsZXMgaW50byBaOlxDT01QVVRFUk5BTUVcWVlZWS1NTS1ERFxTY3JlZW5zaG90c1wgb3IgU2NyZWVuIFJlY29yZGluZ3NcCgokY29tcHV0ZXIgID0gJGVudjpDT01QVVRFUk5BTUUKJGJhc2VQYXRoICA9ICJaOlwkY29tcHV0ZXIiCiRyZWNQYXRoICAgPSAiJGJhc2VQYXRoXFNjcmVlbiBSZWNvcmRpbmdzIgoKIyBFbnN1cmUgYmFzZSBmb2xkZXJzIGV4aXN0CmlmICghKFRlc3QtUGF0aCAkYmFzZVBhdGgpKSB7IE5ldy1JdGVtIC1JdGVtVHlwZSBEaXJlY3RvcnkgLVBhdGggJGJhc2VQYXRoIHwgT3V0LU51bGwgfQppZiAoIShUZXN0LVBhdGggJHJlY1BhdGgpKSAgeyBOZXctSXRlbSAtSXRlbVR5cGUgRGlyZWN0b3J5IC1QYXRoICRyZWNQYXRoICB8IE91dC1OdWxsIH0KCmZ1bmN0aW9uIE1vdmUtVG9EYXRlRm9sZGVyIHsKICAgIHBhcmFtKCRmaWxlUGF0aCwgJGZpbGVOYW1lLCAkdHlwZSkKCiAgICBpZiAoKEdldC1JdGVtICRmaWxlUGF0aCAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250aW51ZSkgLWlzIFtTeXN0ZW0uSU8uRGlyZWN0b3J5SW5mb10pIHsgcmV0dXJuIH0KCiAgICBTdGFydC1TbGVlcCAtU2Vjb25kcyAzCgogICAgJGRhdGUgICAgICAgPSBHZXQtRGF0ZSAtRm9ybWF0ICJ5eXl5LU1NLWRkIgogICAgJGRhdGVGb2xkZXIgPSBKb2luLVBhdGggIlo6XCRlbnY6Q09NUFVURVJOQU1FIiAkZGF0ZQogICAgJGRlc3RGb2xkZXIgPSBKb2luLVBhdGggJGRhdGVGb2xkZXIgJHR5cGUKCiAgICBpZiAoIShUZXN0LVBhdGggJGRlc3RGb2xkZXIpKSB7CiAgICAgICAgTmV3LUl0ZW0gLUl0ZW1UeXBlIERpcmVjdG9yeSAtUGF0aCAkZGVzdEZvbGRlciAtRm9yY2UgfCBPdXQtTnVsbAogICAgfQoKICAgICRkZXN0ID0gSm9pbi1QYXRoICRkZXN0Rm9sZGVyICRmaWxlTmFtZQogICAgdHJ5IHsKICAgICAgICBNb3ZlLUl0ZW0gLVBhdGggJGZpbGVQYXRoIC1EZXN0aW5hdGlvbiAkZGVzdCAtRm9yY2UKICAgIH0gY2F0Y2ggewogICAgICAgIFN0YXJ0LVNsZWVwIC1TZWNvbmRzIDUKICAgICAgICBNb3ZlLUl0ZW0gLVBhdGggJGZpbGVQYXRoIC1EZXN0aW5hdGlvbiAkZGVzdCAtRm9yY2UgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUKICAgIH0KfQoKIyBXYXRjaGVyIDEgLSBTY3JlZW5zaG90cyAocm9vdCBmb2xkZXIpCiR3YXRjaGVyU2hvdCA9IE5ldy1PYmplY3QgU3lzdGVtLklPLkZpbGVTeXN0ZW1XYXRjaGVyCiR3YXRjaGVyU2hvdC5QYXRoID0gJGJhc2VQYXRoCiR3YXRjaGVyU2hvdC5GaWx0ZXIgPSAiKi4qIgokd2F0Y2hlclNob3QuSW5jbHVkZVN1YmRpcmVjdG9yaWVzID0gJGZhbHNlCiR3YXRjaGVyU2hvdC5FbmFibGVSYWlzaW5nRXZlbnRzID0gJHRydWUKCiRhY3Rpb25TaG90ID0gewogICAgJGZwID0gJEV2ZW50LlNvdXJjZUV2ZW50QXJncy5GdWxsUGF0aAogICAgJGZuID0gJEV2ZW50LlNvdXJjZUV2ZW50QXJncy5OYW1lCiAgICBNb3ZlLVRvRGF0ZUZvbGRlciAtZmlsZVBhdGggJGZwIC1maWxlTmFtZSAkZm4gLXR5cGUgIlNjcmVlbnNob3RzIgp9CgojIFdhdGNoZXIgMiAtIFNjcmVlbiBSZWNvcmRpbmdzIHN1YmZvbGRlcgokd2F0Y2hlclJlYyA9IE5ldy1PYmplY3QgU3lzdGVtLklPLkZpbGVTeXN0ZW1XYXRjaGVyCiR3YXRjaGVyUmVjLlBhdGggPSAkcmVjUGF0aAokd2F0Y2hlclJlYy5GaWx0ZXIgPSAiKi4qIgokd2F0Y2hlclJlYy5JbmNsdWRlU3ViZGlyZWN0b3JpZXMgPSAkZmFsc2UKJHdhdGNoZXJSZWMuRW5hYmxlUmFpc2luZ0V2ZW50cyA9ICR0cnVlCgokYWN0aW9uUmVjID0gewogICAgJGZwID0gJEV2ZW50LlNvdXJjZUV2ZW50QXJncy5GdWxsUGF0aAogICAgJGZuID0gJEV2ZW50LlNvdXJjZUV2ZW50QXJncy5OYW1lCiAgICBNb3ZlLVRvRGF0ZUZvbGRlciAtZmlsZVBhdGggJGZwIC1maWxlTmFtZSAkZm4gLXR5cGUgIlNjcmVlbiBSZWNvcmRpbmdzIgp9CgpSZWdpc3Rlci1PYmplY3RFdmVudCAtSW5wdXRPYmplY3QgJHdhdGNoZXJTaG90IC1FdmVudE5hbWUgIkNyZWF0ZWQiIC1BY3Rpb24gJGFjdGlvblNob3QgfCBPdXQtTnVsbApSZWdpc3Rlci1PYmplY3RFdmVudCAtSW5wdXRPYmplY3QgJHdhdGNoZXJSZWMgIC1FdmVudE5hbWUgIkNyZWF0ZWQiIC1BY3Rpb24gJGFjdGlvblJlYyAgfCBPdXQtTnVsbAoKd2hpbGUgKCR0cnVlKSB7IFN0YXJ0LVNsZWVwIC1TZWNvbmRzIDMwIH0K'; $bytes=[Convert]::FromBase64String($b64); [System.IO.File]::WriteAllBytes('%APPDIR%\RecordingOrganizer.ps1',$bytes)"
echo Organizer script ready.

REM --- Add to Startup folder ---
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
(
  echo Set oShell = CreateObject^("WScript.Shell"^)
  echo oShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%APPDIR%\RecordingOrganizer.ps1""", 0, False
) > "%STARTUP%\TeamRecordingsOrganizer.vbs"
echo Startup launcher installed.

REM --- Kill old organizer and start fresh ---
taskkill /f /im powershell.exe /fi "WINDOWTITLE eq TeamRecordingsOrganizer" >nul 2>&1
start "" powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%APPDIR%\RecordingOrganizer.ps1"
echo Organizer running in background.

echo.
echo ============================================
echo   DONE!  Files will be sorted into:
echo   Z:\%COMPUTERNAME%\2026-02-24\Screenshots\
echo   Z:\%COMPUTERNAME%\2026-02-24\Screen Recordings\
echo ============================================
echo.
echo IMPORTANT: Close and reopen Snipping Tool now.
echo.
pause
