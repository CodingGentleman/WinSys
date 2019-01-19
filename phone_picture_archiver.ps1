# -- Phone Picture Archiver --
# PPA moves pictures from your smartphone to ~\Pictures\PhoneArchive\
# check "schtasks" which event is created on mount to run this script at appropiate times
# or let it run every x minutes, whatever, I'm not here to judge

param (
    [string]$SourceRelativePath = "DICM\Camera",
    [string]$ArchivePath = "~\Pictures\PhoneArchive"
)

function Archive-Phone {
    param( [string]$SourcePath )
    # iterate through all items
    Get-ChildItem ($SourcePath) | foreach {

        # construct destination
        $LastWriteTime = $_.LastWriteTime.ToShortDateString()
        $PictureFolderName = Get-Date $LastWriteTime -Format yyyy.MM.dd
        $DestinationPath = "$ArchivePath\$PictureFolderName"

        # create folder if it doesn't exist
        if (-Not (test-path $DestinationPath)) { 
            new-item -ItemType directory -Path $DestinationPath
        }

        # archive the picture
        move-item $_.fullname $DestinationPath
    }
}

# Small helper function to display a toast
function Toast {
    param( [string]$Message )
    $balloon = New-Object System.Windows.Forms.NotifyIcon
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
    $balloon.BalloonTipText = $Message
    $balloon.BalloonTipTitle = "Phone Picture Archiver"
    $balloon.Tag = "com.codinggentleman.ppa"
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Process -id $pid).Path)  
    $balloon.Visible = $true 
    $balloon.ShowBalloonTip(5000)
}

$RunAtLeastOnce = $false;
# Main loop - iterate through all drives
[System.IO.DriveInfo]::GetDrives() | foreach {
    $SourceAbsolutePath = $_.RootDirectory.Name+$SourceRelativePath+"*";
    # check if the path exists and has content
    if (test-path $SourceAbsolutePath) {

        Toast "Archiving $(if ([string]::IsNullOrEmpty($_.VolumeLabel)) {$_.Name} else {$_.VolumeLabel})"
        Archive-Phone $SourceAbsolutePath
        $RunAtLeastOnce = $true;

    }
}

# Sleepy toast just if the archiving is done very quickly
if($RunAtLeastOnce) {
    Start-Sleep -s 5
    Toast "Archived to $(Resolve-Path $ArchivePath)"
}