SET "7ZIP=c:\Program Files\7-Zip\7z.exe"
SET "FROM=E:\"
SET "TO=F:\bkpGoofy-SDCARD\"
SET "ZIPFILE=F:\bkpGoofy-SDCARDzip\"
SET OUTPUT=output.log
SET DD=%DATE:~7,2%%DATE:~4,2%%DATE:~-4%


ROBOCOPY %FROM% %TO% /MOVE /S /MINAGE:5 /log+:%OUTPUT%
cd %FROM%
for /d %%X in (*) do (
  "%7ZIP%" a -tzip "%ZIPFILE%LOG_%DD%_%%X_Backup.zip" %%X
)

:END
pause
