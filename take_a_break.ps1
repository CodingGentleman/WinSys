# Simple Toaster 
# Schedule this to get a Info when you should take a break
$wittyMessages = "Let's grab a cup of coffee", "Get up, stand up", "Woa, look at that bird outside", "Time for a KitKat?"

$balloon = New-Object System.Windows.Forms.NotifyIcon
$balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$balloon.BalloonTipTitle = "Time for a break $Env:USERNAME"
$balloon.BalloonTipText = $wittyMessages[(Get-Random -Maximum $wittyMessages.count)]
$balloon.Tag = "com.codinggentleman.ppa"
$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Process -id $pid).Path)  
$balloon.Visible = $true 
$balloon.ShowBalloonTip(5000)
