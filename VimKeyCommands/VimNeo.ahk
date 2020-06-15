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
	global slotClipboard = {}
	
	Gui, vim:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, vim:Color, EEAA99, OOOO00
	Gui, vim:Font, s14 Arial bold
	Gui, vim:Add, Text, cBlue -Background , Vim enabled	
	Gui +LastFound 
	WinSet, TransColor, EEAA99 150
	
	storeKeys := ["q","w","e","r","t","y","u","i","o","p","1","2","3","4","5","6","7","8","9","0"]
	movModifiers := ["","+"]
	
	Hotkey, IfWinNotExist, VimT
	Hotkey, ~Ctrl, DoubleControl, On
	
	Hotkey, IfWinExist, VimT
	
	Hotkey, Escape, DisableVim, On
	
	loop, % movModifiers.MaxIndex()
	{
		modifier := movModifiers[A_Index]
		Hotkey, %modifier%h, sendLeft, On
		Hotkey, %modifier%j, sendDown, On
		Hotkey, %modifier%k, sendUp, On
		Hotkey, %modifier%l, sendRight, On		
		Hotkey, %modifier%w, sendWordNext, On
		Hotkey, %modifier%b, sendWordBack, On
		Hotkey, %modifier%z, SendBottom, On
		Hotkey, %modifier%q, sendTop, On
		Hotkey, %modifier%0, SendBeginLine, On
		Hotkey, %modifier%$, SendEndLine, On
	}
	
	
	Hotkey, o, SendCreateNewLine, On
	Hotkey, u, SendUndo, On
	Hotkey, x, SendDel, On
	
	Hotkey, +d, DeleteLine, On
	
	Hotkey, y, ManageCopy, On
	Hotkey, d, ManageCut, On
	Hotkey, p, sendPaste, On
	
	Hotkey, v, ManageVisual, On	
	
	loop, % storeKeys.MaxIndex()
	{
		element := storeKeys[A_Index]
		Hotkey, !%element%, setSlotClipboad, On
		Hotkey, ^%element%, getSlotClipboad, On		
	}		
	
	Hotkey, if	
	
}

DoubleControl(){
	if(A_PriorHotkey != "~Ctrl" or A_TimeSincePriorHotkey > 400)
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
	}else{
		visualMode = 		
	}
}

setSlotClipboad()
{
	global slotClipboard
	sendSmartCopy()
	key := StrReplace(A_ThisHotkey, "!", "")	
	slotClipboard[key] := Clipboard
	Clipboard := 
}

getSlotClipboad()
{
	global slotClipboard
	key := StrReplace(A_ThisHotkey, "^", "")
	if(slotClipboard.HasKey(key))
	{		 
		Clipboard := slotClipboard[key]
		SendInput, ^v
		Sleep, 100
		Clipboard := 
	}else
		showFailMessage("slot " . key . " is empty", 1500)
}