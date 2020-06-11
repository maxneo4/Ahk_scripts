#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include  ..\CommandSelector\custom_functions.ahk

InitVimNeo()

InitVimNeo()
{
	global lastCommand = "{Shift}{ShiftUp}"
	global vimEnabled = false
	
	Gui, vim:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, vim:Color, EEAA99, OOOO00
	Gui, vim:Font, s14 Arial bold
	Gui, vim:Add, Text, cBlue -Background , Vim enabled	
	Gui +LastFound 
	WinSet, TransColor, EEAA99 150
	
	Hotkey, IfWinNotExist, VimT
	Hotkey, ~RControl, DoubleRControl, On
	
	Hotkey, IfWinExist, VimT
	Hotkey, Escape, DisableVim, On
	Hotkey, h, sendLeft, On
	Hotkey, j, sendDown, On
	Hotkey, k, sendUp, On
	Hotkey, l, sendRight, On
	Hotkey, w, sendWordNext, On
	Hotkey, b, sendWordBack, On
	Hotkey, z, SendBottom, On
	Hotkey, q, sendTop, On
	Hotkey, 0, SendBeginLine, On
	Hotkey, $, SendEndLine, On
	Hotkey, if	
	
}

DoubleRControl(){
	if(A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400)
	{
		KeyWait, RControl
		return
	}
	EnableVim()
}

EnableVim()
{
	WinGet, active_id, ID, A
	Gui, vim:Show, autosize xCenter y-8, VimT
	WinActivate, ahk_id %active_id%
}

DisableVim()
{
	Gui, vim:Hide
}

sendLeft(){
	SendInput {Left}
}

sendDown(){
	SendInput {Down}
}

sendUp(){
	SendInput {Up}
}

sendRight(){
	SendInput {Right}
}

sendWordNext(){
	SendInput, ^{Right}
}

sendWordBack(){
	SendInput, ^{Left}
}

SendBottom(){
	SendInput, ^{End}
}

SendTop(){
	SendInput, ^{Home}
}

SendBeginLine(){
	SendInput, {Home}
}

SendEndLine(){
	SendInput, {End}
}