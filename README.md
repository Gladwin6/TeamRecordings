# TeamRecordings Setup

Automatically maps a shared network drive and configures Snipping Tool to save screenshots and screen recordings into organised dated folders — one click setup for all workstations.

## What it does
- Maps `Z:` drive to `\\100.124.248.113\TeamRecordings`
- Sets Snipping Tool to save to `Z:\COMPUTERNAME\`
- Installs a background organizer that auto-sorts files into dated folders
- Runs organizer automatically at every login (via Startup folder)

## Folder structure
```
Z:\
    WORKSTATION9\
        2026-02-24\
            Screenshots\
                Screenshot 2026-02-24 093012.png
            Screen Recordings\
                Screen Recording 2026-02-24 093045.mp4
        2026-02-25\
            Screenshots\
            Screen Recordings\
    WS7\
        2026-02-24\
            ...
```

## Usage
1. Copy `Setup_TeamRecordings.bat` to any computer
2. Double-click it
3. Enter the network password when prompted
4. Close and reopen Snipping Tool
5. Done — screenshots and recordings auto-save to the network drive

## Files
- `Setup_TeamRecordings.bat` — single-file installer (contains embedded organizer script)
- `RecordingOrganizer.ps1` — background watcher script (extracted automatically by the bat)

## Requirements
- Windows 10 / 11
- Access to `\\100.124.248.113\TeamRecordings`
- PowerShell (built into Windows)
