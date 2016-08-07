$DefaultDir="C:\Users\nicolastarzia\OneDrive\Entrevistas_Palmeiras"
    function DownloadFileNews($DefaultDir){
        $strVersionFile = "version.txt"
            $strFile = Get-Content "$DefaultDir\$strVersionFile"
            $iVersao = [System.Decimal]::Parse($strFile)
            $evernotePath="C:\Program Files (x86)\Evernote\Evernote"
            $url = "http://www.palmeiras.com.br/public/upload/audio/audios/audio_$strFile.mp3"
            $currentDate = (Get-Date).ToString('yyyyMMdd')
            if((Test-Path "$DefaultDir\$currentDate") -eq 0){
                mkdir "$DefaultDir\$currentDate"
            }
            $output = "$DefaultDir\$currentDate\$strFile.mp3"
            $start_time = Get-Date
            $notebook="!nbox"
            $maxTitleLength = 75
            $note = "Entrevista coletiva Palmeiras - $strFile"
            Try
            {
                $wc = New-Object System.Net.WebClient
                Write-Host $url
                Write-Host $output
                    $wc.DownloadFile($url, $output)
                    Write-Output "Download realizado, demorou: $((Get-Date).Subtract($start_time).Seconds) segundo(s) - $output"
                    Set-Content "$DefaultDir\$strVersionFile" ($iVersao+1)
# add to evernote, thanks FStanley https://gist.github.com/fstanley/2993203
                    $title = $note.Substring(0,[Math]::Min($note.length,$maxTitleLength))
                    if($title.length -eq $maxTitleLength) {
                        $title+="..."
                    }
                if ($notebook) {
                    echo "$note" | & "$evernotePath\ENScript.exe" createNote /i $title  /n $notebook
                } else {
                    echo "$note" | & "$evernotePath\ENScript.exe" createNote /i $title 
                }
                DownloadFileNews($DefaultDir)
            }
        Catch
        {
            $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Output "$ErrorMessage - $FailedItem - Versao: $iVersao"
                Set-Content "$DefaultDir\$strVersionFile" ($iVersao)
        }
    }
    DownloadFileNews($DefaultDir)
