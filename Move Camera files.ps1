# Script Name: Move Camera files.ps1
# powershell -ExecutionPolicy Bypass -File "K:\My Drive\Software\Macro\Sort Camera files.ps1"
# powershell -ExecutionPolicy Bypass -File "K:\My Drive\Software\Macro\Sort Camera files.ps1" -source "F:\Source" -destination "F:\Destination"
#Parameters
#The script should take 2 arguments $source and $destination (for the source and destination folders).
param([string]$source="F:\Source",[string]$destination="F:\Destination")

# Define log file path and ensure Log folder exists
$logFolder = Join-Path $destination "Log"
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Define log file path
$logFile = Join-Path $logFolder "SortCameraFiles_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

Function Write-Log {
    param([string]$message)
    Write-Host $message
    Add-Content -Path $logFile -Value $message
}
#1)	Main processing

#a) Test for existence of the source folder (using the CheckFolder function).

if (!(Test-Path $source)){
    Write-Log "The source directory '$source' is not found. Script can not continue."
    Exit
}

# Check if the source folder is empty
if (-not (Get-ChildItem -Path $source | Where-Object { -not $_.PSIsContainer })) {
    Write-Log "The source directory '$source' is empty. Script cannot continue."
    Exit
}
#b) Test for the existence of the destination folder

if (!(Test-Path $destination)){
    Write-Log "The destination directory '$destination' is not found. Script can not continue."
    Exit
}



#c) Copy each file to the appropriate destination.
#get all the files that need to be copied

# PSIsContainer is a property in PowerShell that indicates whether a particular item is a container, such as a directory or folder, rather than a file. When you use commands like Get-ChildItem, each item returned is an object that may have the PSIsContainer property. If PSIsContainer is $true, the item is a container (for example, a directory); if it is $false, the item is not a container (for example, a file).
$files = dir $source | where {!$_.PSIsContainer}
# $files

# Move each file to the appropriate destination folder based on date and file type
foreach ($file in $files) {
    $dateString = $file.LastWriteTime.ToString("yyyyMMdd")
    $ext = if ($file.Extension) { $file.Extension.Replace(".", "").ToUpper() } else { "" }
    # Determine the subfolder based on the file extension
    switch ($ext) {
        "JPG"    { $SubFolder = "Photo" }
        "LRF"    { $SubFolder = "Low" }
        "MP4"    { $SubFolder = "High" }
        default  { $SubFolder = "" }
    }
    if ($SubFolder -ne "") {
        $targetFolder = Join-Path (Join-Path $destination $dateString) $SubFolder
    } else {
        $targetFolder = Join-Path $destination $dateString
    }

    # Ensure the type folder exists
    if (-not (Test-Path $targetFolder)) {
        New-Item -Path $targetFolder -ItemType Directory | Out-Null
        Write-Log "Created :: Folder :: $targetFolder"
    }

    # Move the file
    $targetPath = Join-Path $targetFolder $file.Name
    if (-not (Test-Path $targetPath)) {
        Move-Item $file.FullName $targetFolder
        Write-Log "Moving :: File to :: $targetPath"
    } else {
        Write-Log "Skipping :: File already exists in :: $targetFolder - $($file.Name)"
    }
}





