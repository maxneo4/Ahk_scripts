﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
	
	global slotMouse = {}
	
	global LabelId
	
	Gui, vim:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, vim:Color, EEAA99, OOOO00
	Gui, vim:Font, s14 Arial bold
	Gui, vim:Add, Text, cBlue -Background HwndLabelId , Vim [N]	
	Gui +LastFound 
	WinSet, TransColor, EEAA99 100	
	
	Hotkey, IfWinNotExist, VimT
	Hotkey, ~Escape, DoubleKeyToActivate, On
	
	Hotkey, IfWinExist, VimT
	
	Hotkey, Escape, DisableVim, On
	
	movModifiers := ["","+"]	
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
		Hotkey, %modifier%i, SendF2, On
		
		Hotkey, %modifier%o, SendCreateNewLine, On
		Hotkey, %modifier%u, SendUndo, On
		
		Hotkey, %modifier%x, SendDel, On
		
		Hotkey, %modifier%y, ManageCopy, On
		Hotkey, %modifier%p, sendPaste, On
		
		Hotkey, %modifier%s, ManageSelected, On		
		
		Hotkey, %modifier%c, StoreSlotClipboad, On
		Hotkey, %modifier%v, RetrieveSlotClipboad, On
		
		Hotkey, %modifier%n, StoreMousePosition, On
		Hotkey, %modifier%m, ClickMousePosition, On
		
		Hotkey, %modifier%., sendLeftClick, On
		Hotkey, %modifier%`,, sendRightClick, On
	}
	
	Hotkey, 0, SendBeginLine, On
	Hotkey, $, SendEndLine, On	
	
	Hotkey, +d, DeleteLine, On	
	Hotkey, d, ManageCut, On	
	
	;"m","n"
	nullKeys := ["Space","a","e","f","g","ñ","r","t","1","2","3","4","5","6","7","8","9",";","-","_","{","}","[","]","+","*","/","!","#","%","&","(",")","=","'","?","¿","<",">",""""]
	
	Loop, % nullKeys.MaxIndex()
	{
		nullKey := nullKeys[A_Index]
		Hotkey, %nullKey%, OverrideKey, On		
	}	
	
	Hotkey, if	
	
	DoubleKeyToActivate:
	if(DoubleKey("Escape"))
		EnableVim()
	return
	
}

EnableVim()
{
	WinGet, active_id, ID, A
	yPos := A_ScreenHeight - 100
	Gui, vim:Show, autosize xCenter y%yPos%, VimT
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
	if(OverrideKey()){		
		multiMode = 1
		Input, text, L1 T1, , w,l,s	
		multiMode = 0
		Switch text
		{
			case "w": SelectWord()
			case "l": SelectLine()		
		}	
		
		SendInput, ^c
	}
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
		global LabelId
		
		if visualMode != +
		{
			visualMode = +
			GuiControl, ,%LabelId%, Vim [S]
		}else{
			visualMode = 	
			GuiControl, ,%LabelId%, Vim [N]
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

StoreMousePosition()
{	
	global slotMouse
	global multiMode
	multiMode = 1
	Input, key, T1 L1
	multiMode = 0
	if(key){
		MouseGetPos, posX, posY, wId
		slotMouse[key] := {x:posX, y:posY, id:wId}
		showMessage("Stored in slot " . key, 1000)
	}
}

ClickMousePosition()
{
	global slotMouse
	global multiMode
	multiMode = 1
	Input, key, T1 L1
	multiMode = 0
	if(slotMouse.HasKey(key))
	{
		mouseInfo := slotMouse[key]
		winId := mouseInfo.id
		WinActivate, ahk_id %winId%
		MouseClick, Left, mouseInfo.x, mouseInfo.y		
	}else
		showFailMessage("slot " . key . " is empty", 1000)
}

SendF2(){
	if(OverrideKey())
		SendInput, {F2}
}

sendLeftClick(){
	Click	
}

sendRightClick(){
	Click,,, Right
}