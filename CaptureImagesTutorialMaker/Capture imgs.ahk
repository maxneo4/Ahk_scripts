#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; + shift, ^ ctrl, # windows, ! alt

#SingleInstance Force

capture = False
Folder = %A_ScriptDir%

^!c::
if(%capture% == true){
	capture = false
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, Capture was disabled
	SetTimer, OSD_OFF, -2000
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -openImagesFolder true -folderTarget %Folder%
}else {
	capture = true
	FileSelectFolder, Folder, *%Folder%
	if (Folder = "")
		Folder = %A_ScriptDir%	
	MsgBox, 64, Capture images, 
(
- Use [LWin] to take screenshoot
- Use [CTRL+E] to edit json config
- Use [CTRL+R] to view html tutorial
Capture enabled in folder "%Folder%" 
), 5
}
Return

OSD_OFF:
Progress, off
return

LWin::
if(%capture% == false)
{
	SendInput, {LWin}
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, Capture is disabled
	SetTimer, OSD_OFF, -2000
}
Gosub, InvokeCapture
Return

InvokeCapture:
Clipboard = ;
if(%capture% == true){
	Sleep, 150
	SendInput, #+s	
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -secondsToWait 20 -folderTarget %Folder%
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