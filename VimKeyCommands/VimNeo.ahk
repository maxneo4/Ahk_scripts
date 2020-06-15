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
		
	movModifiers := ["","+"]
	
	Hotkey, IfWinNotExist, VimT
	Hotkey, ~Shift, DoubleShift, On
	
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
	
	Hotkey, s, ManageSelected, On		
		
	Hotkey, c, StoreSlotClipboad, On
	Hotkey, v, RetrieveSlotClipboad, On
	
	Hotkey, if	
	
}

DoubleShift(){
	if(A_PriorHotkey != "~Shift" or A_TimeSincePriorHotkey > 400)
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
	if(OverrideKey())
		SendInput %visualMode%{Left}
}

sendDown(){
	global visualMode
	if(OverrideKey())
		SendInput %visualMode%{Down}
}

sendUp(){
	global visualMode
	if(OverrideKey())
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
	if(OverrideKey())
		SendInput, %visualMode%^{Left}
}

SendBottom(){
	global visualMode
	if(OverrideKey())
		SendInput, %visualMode%^{End}
}

SendTop(){
	global visualMode
	if(OverrideKey())
		SendInput, %visualMode%^{Home}
}

SendBeginLine(){
	global visualMode
	if(OverrideKey())
		SendInput, %visualMode%{Home}
}

SendEndLine(){
	global visualMode
	if(OverrideKey())
		SendInput, %visualMode%{End}
}

SendCreateNewLine(){
	if(OverrideKey()){
		SendEndLine()
		SendInput, {Enter}
	}	
}

SendUndo(){
	if(OverrideKey())
		SendInput, ^z
}

SendDel(){
	if(OverrideKey())
		SendInput, {Delete}
}

DeleteLine(){
	if(OverrideKey()){
		SendBeginLine()
		SendInput, +{End}
		SendDel()
	}
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
	;if(OverrideKey()){		
	multiMode = 1
	Input, text, L1 T1, , w,l,s	
	multiMode = 0
	Switch text
	{
		case "w": SelectWord()
		case "l": SelectLine()		
	}	
	
	SendInput, ^c
	;}
}

ManageCut(){
	if(OverrideKey())
	{
		ManageCopy()
		SendInput, {Delete}
	}	
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
	if(OverrideKey())
		SendInput, ^v
}

ManageSelected()
{
	if(OverrideKey()){
		global visualMode
		if visualMode != +
		{
			visualMode = +		
		}else{
			visualMode = 		
		}
	}
}

StoreSlotClipboad()
{
	global slotClipboard	
	global multiMode	
	multiMode = 1
	Input, key, T1 L1
	multiMode = 0
	if(key)
	{
		sendSmartCopy()
		slotClipboard[key] := Clipboard
		showMessage("Stored in slot " . key, 1000)
		Clipboard := 		
	}	
}

RetrieveSlotClipboad()
{
	global slotClipboard
	global multiMode	
	multiMode = 1
	Input, key, T1 L1
	multiMode = 0
	if(slotClipboard.HasKey(key))
	{		 
		Clipboard := slotClipboard[key]
		SendInput, ^v
		Sleep, 100
		Clipboard := 
	}else
		showFailMessage("slot " . key . " is empty", 1500)
		
}