$DefaultDir = "E:\my\JornalConsumidor"
$strVersionFile = "version.txt"
$strFile = Get-Content "$DefaultDir\$strVersionFile"
$iVersao = [System.Decimal]::Parse($strFile)
$evernotePath="C:\Program Files (x86)\Evernote\Evernote"
$url = "http://servicos.sjc.sp.gov.br/governo/jconsumidorflip/downloads/JConsu_$strFile.pdf"
$output = "$DefaultDir\$strFile.pdf"
$start_time = Get-Date
$notebook="!nbox"
$maxTitleLength = 75
$note = "Jornal do consumidor - $strFile"

Try
{
 $wc = New-Object System.Net.WebClient
 $wc.DownloadFile($url, $output)
 Write-Output "Download realizado, demorou: $((Get-Date).Subtract($start_time).Seconds) segundo(s)"
 Set-Content "$DefaultDir\$strVersionFile" ($iVersao+1)

 # add to evernote, thanks FStanley https://gist.github.com/fstanley/2993203
 $title = $note.Substring(0,[Math]::Min($note.length,$maxTitleLength))
 if($title.length -eq $maxTitleLength) {
    $title+="..."
 }

 if ($notebook) {
   echo "$note" | & "$evernotePath\ENScript.exe" createNote /i $title  /n $notebook /a $output
 } else {
   echo "$note" | & "$evernotePath\ENScript.exe" createNote /i $title /a $output
 }
}
Catch
{
 $ErrorMessage = $_.Exception.Message
 $FailedItem = $_.Exception.ItemName
 Write-Output "$ErrorMessage - $FailedItem - Versao: $iVersao"
 Set-Content "$DefaultDir\$strVersionFile" ($iVersao)
}
