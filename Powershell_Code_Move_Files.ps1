<#Henry Agramonte, Powershell Script to move files Between Locations#>

#Create the log file
start-transcript "ROUTE WHERE YOU WANT TO STORE THE LOGS\Disk_Cleanup_$( Get-Date -Format 'MM_dd_yyyy-HH_mm' ).txt"

#Variables#
$MoveFromPath="LOCATION OF THE FILES THAT YOU WANT TO MOVE"
$MoveToPath ="LOCATION OF WHERE YOU WANT TO MOVE THE FILES TO"

##Get Disk space information Before Cleanup##
Write-Host "--- Disk Space Before Cleanup ---"
Get-CimInstance -Class CIM_LogicalDisk | Select-Object @{Name="Size(GB)";Expression={$_.size/1gb}}, @{Name="Free Space(GB)";Expression={$_.freespace/1gb}}, @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}, DeviceID, DriveType | Where-Object DriveType -EQ '3'
Write-Host "---^^^ Disk Space Before Cleanup ^^^---"


Write-Host "***------ I will Start Moving the Files Please see the Files_Moved_.txt ------*** "

## START Moving Files after the Cleanup of duplicate files
                Robocopy $MoveFromPath $MoveToPath /E /MOV *.txt *.uploaded *.zip /minage:30 /TEE /NP /FP /log+:"LOCATION FOR A ROBOCOPY LOG\Files_Moved_$( Get-Date -Format 'MM_dd_yyyy-HH_mm' ).txt"
## END of Moving Files

                    
##-----------------------------------------------------------------------------------------------------##
##Get Disk space information After Cleanup##
Write-Host "--- Disk Space After Cleanup ---"
Get-CimInstance -Class CIM_LogicalDisk | Select-Object @{Name="Size(GB)";Expression={$_.size/1gb}}, @{Name="Free Space(GB)";Expression={$_.freespace/1gb}}, @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}, DeviceID, DriveType | Where-Object DriveType -EQ '3'
Write-Host "---^^^ Disk Space After Cleanup ^^^---" 
Write-Host "---^^^ Sending Email ^^^---"   
         
stop-transcript

##-----------------------------------------------------------------------------------------------------##
## SEND EMAIL WHEN COMPLETED ##

get-childitem -Path LOCATION OF YOUR LOG FILES\ -recurse -include *.txt | Sort-Object LastAccessTime -Descending | Select-Object -First 3 | Send-MailMessage -SmtpServer " SERVER IP" -To "EMAIL ADDRESS <EMAIL ADDRESS>" -From "EMAIL ADDRESS <EMAIL ADDRESS>"  -Subject "Disk Space Cleanup Completed for: $env:computername" -Body "Disk Space Cleanup completed. Please find the logs in the attachments" 