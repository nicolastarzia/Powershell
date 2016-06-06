# 
#	Why I wrote this: 
#	Backup all my Evernote files to my own filesystem
#
$defaultDir = "E:\my\BkpEvernote\"
$evernotePath="C:\Program Files (x86)\Evernote\Evernote\ENScript.exe"
$defaultDate = "{0}" -f (Get-Date -format M.d.yyyy)
$pathExport = "{0}EvernoteNicolas.{1}.enex" -f $defaultDir, $defaultDate
& $evernotePath exportNotes /q any: /f $pathExport

