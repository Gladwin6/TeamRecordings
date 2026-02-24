# RecordingOrganizer.ps1
# Watches Z:\COMPUTERNAME\ and Z:\COMPUTERNAME\Screen Recordings\
# Moves files into Z:\COMPUTERNAME\YYYY-MM-DD\Screenshots\ or Screen Recordings\

$computer  = $env:COMPUTERNAME
$basePath  = "Z:\$computer"
$recPath   = "$basePath\Screen Recordings"

# Ensure base folders exist
if (!(Test-Path $basePath)) { New-Item -ItemType Directory -Path $basePath | Out-Null }
if (!(Test-Path $recPath))  { New-Item -ItemType Directory -Path $recPath  | Out-Null }

function Move-ToDateFolder {
    param($filePath, $fileName, $type)

    if ((Get-Item $filePath -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo]) { return }

    Start-Sleep -Seconds 3

    $date       = Get-Date -Format "yyyy-MM-dd"
    $dateFolder = Join-Path "Z:\$env:COMPUTERNAME" $date
    $destFolder = Join-Path $dateFolder $type

    if (!(Test-Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
    }

    $dest = Join-Path $destFolder $fileName
    try {
        Move-Item -Path $filePath -Destination $dest -Force
    } catch {
        Start-Sleep -Seconds 5
        Move-Item -Path $filePath -Destination $dest -Force -ErrorAction SilentlyContinue
    }
}

# Watcher 1 — Screenshots (root folder)
$watcherShot = New-Object System.IO.FileSystemWatcher
$watcherShot.Path = $basePath
$watcherShot.Filter = "*.*"
$watcherShot.IncludeSubdirectories = $false
$watcherShot.EnableRaisingEvents = $true

$actionShot = {
    $fp = $Event.SourceEventArgs.FullPath
    $fn = $Event.SourceEventArgs.Name
    Move-ToDateFolder -filePath $fp -fileName $fn -type "Screenshots"
}

# Watcher 2 — Screen Recordings (Screen Recordings subfolder)
$watcherRec = New-Object System.IO.FileSystemWatcher
$watcherRec.Path = $recPath
$watcherRec.Filter = "*.*"
$watcherRec.IncludeSubdirectories = $false
$watcherRec.EnableRaisingEvents = $true

$actionRec = {
    $fp = $Event.SourceEventArgs.FullPath
    $fn = $Event.SourceEventArgs.Name
    Move-ToDateFolder -filePath $fp -fileName $fn -type "Screen Recordings"
}

Register-ObjectEvent -InputObject $watcherShot -EventName "Created" -Action $actionShot | Out-Null
Register-ObjectEvent -InputObject $watcherRec  -EventName "Created" -Action $actionRec  | Out-Null

# Keep script alive silently
while ($true) { Start-Sleep -Seconds 30 }
