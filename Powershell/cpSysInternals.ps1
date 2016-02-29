$tmpPath = 'E:\my\sysinternals'

$LastDateTimeLocalFile = Get-ChildItem $tmpPath | Sort {$_.LastWriteTime} | select -last 1 | foreach {$a=$_;$b=Get-Acl $_.FullName; Add-Member -InputObject $b -Name "LastWriteTime" -MemberType NoteProperty -Value $a.LastWriteTime;$b}

Write-Host ('Ultima data do arquivo: ', $LastDateTimeLocalFile.LastWriteTime)

Get-ChildItem \\live.sysinternals.com\Tools\*.* | Where{$_.LastWriteTime -ge $LastDateTimeLocalFile.LastWriteTime} | Copy-Item -destination e:\my\sysinternals

get-childitem $tmpPath | sort-object -property @{Expression={$_.LastWriteTime - $_.CreationTime}; Ascending=$false} | Format-Table LastWriteTime, CreationTime, Name
