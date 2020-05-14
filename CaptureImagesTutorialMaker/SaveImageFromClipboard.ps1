##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4dI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+VslQ=
##M9jHFoeYB2Hc8u+VslQ=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjrXc9whW7UDRUWs5Z9WPqoqExZGo6vjpkijYTp8HfUFjmTv1BUeQWPkXR8kmtccUfBArKPct8L3dOOugVaAFk/F7JeCWo9I=
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
param( $secondsToWait=5, $folderTarget='C:', $editConfig='false', $runHtmlPage='false', $openImagesFolder='false' )

function run-html($folderTarget)
{
    $configPath = Join-Path $folderTarget 'web\config.json'
    $config = ( get-content $configPath -raw ) | ConvertFrom-Json
    $htmlPath = Join-Path $folderTarget 'web\index.html'

    $html = "<Html><Body><center>"
    $footerHtml = "</center></Body></Html>"  
    $html += "<h1>$($config.maintitle)</h1><p>$($config.maindescription)</p>"      
    foreach($item in $config.items)
    {
        $sourceImage = "images/captured$($item.id).png"  
        if($item.step){ $html += "<br/><br/><br/><h2>$($item.step). $($item.title)</h2>" }      
        else { $html += "<br/><br/><h3>$($item.title)</h3>" }
        $html += "<p>$($item.description)</p>"
        $html += '<img src="'+$sourceImage+'" alt="'+$item.description+'" border="2" />'
    }
    $html += $footerHtml
    $html | Out-File $htmlPath
    invoke-item $htmlPath
}

function open-config($folderTarget, $files)
{
    $configPath = Join-Path $folderTarget 'web\config.json'
    $config = $null
    if(-not [System.IO.File]::Exists($configPath))
    {
        $config =  [PsCustomObject]@{  maintitle=""; maindescription=""; items =@(); } 
        foreach($i in 1..($files.Count))
        {
            $config.items += [PsCustomObject]@{ id = $i.ToString("000"); step= ""; title = ''; description = ''}
        }
    }
    else {        
        $config = ( get-content $configPath -raw ) | ConvertFrom-Json
        if( $config.items.Length -lt $files.Count){
            foreach($i in ($config.items.Length+1)..($files.Count))
            {
                $config.items += [PsCustomObject]@{ id = $i.ToString("000"); step= ""; title = ''; description = ''}
            }
        }
    }
    $config | ConvertTo-Json | Out-File $configPath
    invoke-item $configPath
}

function save-image($secondsToWait, $folderImages, $files)
{        
    $fileCount = ($files.Count + 1).ToString("000")

    foreach($i in 1..$secondsToWait)
    {
        Start-Sleep -Seconds 1
        $img = Microsoft.PowerShell.Management\Get-Clipboard -Format Image
        if($img){
             Write-Host capturada -ForegroundColor Green
             $img.save("$folderImages\captured$fileCount.png", [System.Drawing.Imaging.ImageFormat]::Png)
             break;
        }    
    }

    echo $null | clip.exe
}

$folderImages = Join-Path $folderTarget 'web\images'
new-item $folderImages -ItemType Directory -Force
$files = Get-ChildItem $folderImages -filter *.png

if($editConfig -eq 'true')
{    
    open-config $folderTarget $files
}elseif($runHtmlPage -eq 'true') {   
    run-html $folderTarget
}elseif($openImagesFolder -eq 'true'){
    invoke-item $folderImages
}else{
    save-image $secondsToWait $folderImages $files 
}

write-host "$(get-location)"