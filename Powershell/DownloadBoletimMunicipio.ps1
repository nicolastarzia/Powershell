$defaultDir = "E:\my\JornalConsumidor\{0}"
$defaultLink = "http://www.sjc.sp.gov.br{0}"
$pathTXT = $defaultDir -f "versionBoletim.txt"
$linkHTML = $defaultLink -f "/servicos/portal_da_transparencia/boletim_municipio.aspx"
$evernotePath="C:\Program Files (x86)\Evernote\Evernote"
$links = ((Invoke-WebRequest -Uri $linkHTML).Links | Where-Object {$_.href -like "*pdf"})
    $b = [System.IO.File]::ReadAllText($pathTXT)
Foreach ($link in $links)
{
    if($b -NotLike '*' + $link.href + '*')
    {
	$linkFILE = "{0},{1}" -f $link.href,(Get-Date)
	    Add-Content -Path $pathTXT $linkFILE
	    $output = $defaultDir -f "BoletimDoMunicipio.pdf"
	    $notebook="!nbox"
	    $maxTitleLength = 75
	    $note = "Boletim municipio - $($link.innerText)"

	    Try
	    {
		$wc = New-Object System.Net.WebClient
		    $linkDownloadFile = $link.href
		    $wc.DownloadFile($linkDownloadFile, $output)
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
		Remove-Item $output
	    }
	Catch
	{
	    $ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output "$ErrorMessage - $FailedItem - Versao: $iVersao"
	}

    }
}
