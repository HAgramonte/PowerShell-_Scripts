<# Henry Agramonte, Powershell Script to List folders and metadata. 12/29/2020 #>
#This Script Will give you the Full Name, The folder Size in MB, The owner of the Folder, Creation Time and the Last Access Time in a CSV file.
$start = "Folder Path to run the script" # <--- Change this
$output = "Folder Path for the Output File \Files_Info.csv"  # <--- Change this
Get-ChildItem $start | Where-Object{$_.PSIsContainer} | ForEach-Object{
    $singleFolder = $_.FullName
    $folderSize = Get-ChildItem $singleFolder -Recurse -Force | Where-Object{!$_.PSIsContainer} | Measure-Object -Property length -sum | Select-Object -ExpandProperty Sum
    $folderSize = [math]::round($folderSize/1MB, 2)
    $owner = Get-Acl $singleFolder | Select-Object -ExpandProperty Owner
    $_ | Add-Member -MemberType NoteProperty -Name FolderSizeMB -Value $folderSize -PassThru |
        Add-Member -MemberType NoteProperty -Name Owner -Value $owner -PassThru
} | Select-Object FullName,FolderSizeMB,Owner,CreationTime,LastAccessTime | Export-Csv $output -NoTypeInformation