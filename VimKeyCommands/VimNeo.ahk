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
	global multiMode = 0
	global visualMode = 
	
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
	Hotkey, *h, sendLeft, On
	Hotkey, *j, sendDown, On
	Hotkey, *k, sendUp, On
	Hotkey, *l, sendRight, On		
	Hotkey, *w, sendWordNext, On
	Hotkey, *b, sendWordBack, On
	Hotkey, *z, SendBottom, On
	Hotkey, *q, sendTop, On
	Hotkey, *0, SendBeginLine, On
	Hotkey, *$, SendEndLine, On
	Hotkey, o, SendCreateNewLine, On
	Hotkey, u, SendUndo, On
	Hotkey, x, SendDel, On
	Hotkey, +d, DeleteLine, On
	
	Hotkey, y, ManageCopy, On
	Hotkey, d, ManageCut, On
	Hotkey, p, sendPaste, On
	
	Hotkey, v, ManageVisual, On
	
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
	Send, {ShiftUp}
	Gui, vim:Hide
}

sendLeft(){
	global visualMode
	SendInput %visualMode%{Left}
}

sendDown(){
	global visualMode
	SendInput %visualMode%{Down}
}

sendUp(){
	global visualMode
	SendInput %visualMode%{Up}
}

sendRight(){
	global visualMode
	if(OverrideKey())
		SendInput %visualMode%{Right}
}

sendWordNext(){
	global visualMode
	if (OverrideKey())
		SendInput, %visualMode%^{Right}
}

sendWordBack(){
	global visualMode
	SendInput, %visualMode%^{Left}
}

SendBottom(){
	global visualMode
	SendInput, %visualMode%^{End}
}

SendTop(){
	global visualMode
	SendInput, %visualMode%^{Home}
}

SendBeginLine(){
	global visualMode
	SendInput, %visualMode%{Home}
}

SendEndLine(){
	global visualMode
	SendInput, %visualMode%{End}
}

SendCreateNewLine(){
	SendEndLine()
	SendInput, {Enter}
}

SendUndo(){
	SendInput, ^z
}

SendDel(){
	SendInput, {Delete}
}

DeleteLine(){
	SendBeginLine()
	SendInput, +{End}
	SendDel()
}

OverrideKey(){
	global multiMode
	if(multiMode = 1)
		{
			SendInput, %A_ThisHotkey%
			return false
		}
	return true
}

ManageCopy(){	
	global multiMode
	multiMode = 1
	Input, text, L1 T1, , w,y,s	;[selected]
	Switch text
	{
		case "w": SelectWord()
		case "l": SelectLine()		
	}	
	multiMode = 0
	SendInput, ^c
}

ManageCut(){
	ManageCopy()
	SendInput, {Delete}
}

SelectWord(){
	sendWordBack()
	SendInput, +^{Right}	
}

SelectLine(){
	SendBeginLine()
	SendInput, +{End}
}

sendPaste(){
	SendInput, ^v
}

ManageVisual()
{
	global visualMode
	if visualMode != +
	{
		visualMode = +
		SendInput, {ShiftDown}
	}else{
		visualMode = 
		SendInput, {ShiftUp}
	}
}