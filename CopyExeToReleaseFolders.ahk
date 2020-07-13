SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

for idx, target in ["C:\MegaSync\_intercambio archivos\LauncherTools-max","C:\MegaSync\_intercambio archivos\AHK Tools Bizagi","C:\MegaSync\Portables\LauncherTools"]
{
	MsgBox, , , %target%
	FileCopy, LauncherTools.exe, %target%, 1
}
