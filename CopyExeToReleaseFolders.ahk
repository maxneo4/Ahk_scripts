SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

for idx, target in ["H:\Mega\MegaSync\_intercambio archivos\LauncherTools-max","H:\Mega\MegaSync\_intercambio archivos\AHK Tools Bizagi","H:\Mega\MegaSync\Portables\LauncherTools"]
{
	MsgBox, , , %target%
	FileCopy, LauncherTools.exe, %target%, 1
	FileCopy, settings.ini, %target%, 1
}

;Run, H:\MegaSync\_intercambio archivos\LauncherTools-max