#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; + shift, ^ ctrl, # windows, ! alt

capture = False
Folder = %A_ScriptDir%

^!c::
if(%capture% == true){
	capture = false
	Run, "%Folder%\web\images"
}else {
	capture = true
	FileSelectFolder, Folder
	if (Folder = "")
		Folder = %A_ScriptDir%
	MsgBox, Capture enabled = %capture% in folder %Folder%
}
Return

LWin::
if(%capture% == false)
{
	SendInput, {LWin}
}
Gosub, InvokeCapture
Return

InvokeCapture:
Clipboard = ;
if(%capture% == true){
	Sleep, 150
	SendInput, #+s	
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -secondsToWait 20 -folderTarget %Folder% -editConfig false
}
Return

^e::
if(%capture% == true){
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -editConfig true -folderTarget %Folder%
}
Return

^r::
if(%capture% == true){
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -runHtmlPage true -folderTarget %Folder%
}
Return