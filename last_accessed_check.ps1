# Find not accessed folders
# This scripts iterates through a $SourcePath and prints the top folder which were not accessed in the last $Days

param (
    [string]$SourcePath = "E:\S3\",
    [int]$Days = 30
)

$AccessedFolders = @()
Get-ChildItem $SourcePath -Directory | foreach {
    Get-ChildItem $_.FullName -Recurse | where -FilterScript {
        $_.LastAccessTime -gt (Get-Date).Date.AddDays(-[math]::abs($Days))
    } | select $_.Name | select -First 1 | foreach { $AccessedFolders += $_.psobject.properties.name }
}
Get-ChildItem $SourcePath -Directory | where ({ $AccessedFolders -notcontains $_ }) | sort $_ | Write-Host