﻿##[Ps1 To Exe]
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
##L8/UAdDXTlaDjrXc9whW7UDRUWs5Z9WPqoqLy4aS8P7pqATXTagRRFF6lCzuKEKuTc4xWfwFtt4QRxkDIvMM54bfPe6lQOwPiuYf
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
param( $secondsToWait=5, $imagePath='C:\screen.png')

foreach($i in 1..$secondsToWait)
{
    Start-Sleep -Seconds 1
    $img = Microsoft.PowerShell.Management\Get-Clipboard -Format Image
    if($img){
         Write-Host capturada -ForegroundColor Green
         $img.save($imagePath, [System.Drawing.Imaging.ImageFormat]::Png)
         echo $null | clip.exe
         break;
    }    
}