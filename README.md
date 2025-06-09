This script will help you to copy the files from SD card or Camera internal drive to your hardrive or mapped network folder.

Functionality: Sorting the files to Hardrive in folders and subfolder based on date and type of the file.

In camera the files are stored in JPG, MP4 and LRF (low resolution file). To copy/move the files to Hardrive or network folder, 
script will create the folder with date in "YYYYMMDD" format and subfolders as "Photo", "High" (for high resolution videos) and
"Low" (for low resolution videos) and transfer the files to respective folders.

Change default source and destination: 
param([string]$source="F:\Source",[string]$destination="F:\Destination")

Change the destination sub-folder names based on the file type
"JPG"    { $SubFolder = "Photo" }
"LRF"    { $SubFolder = "Low" }
"MP4"    { $SubFolder = "High" }
default  { $SubFolder = "" }


