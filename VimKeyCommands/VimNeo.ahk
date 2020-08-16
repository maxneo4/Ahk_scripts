InitVimNeo()
{	
	global vimEnabled = "OFF"	
	global visualMode = 
	global slotClipboard = {}
	
	global slotMouse = {}
	
	global LabelId
	
	global mouseDelta = 8
	global mouseFastDelta = 80
	
	Gui, vim:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, vim:Color, EEAA99, OOOO00
	Gui, vim:Font, s24 Calibri bold
	Gui, vim:Add, Text, cBlue -Background HwndLabelId W140 h44 center, Vim [N]	
	Gui +LastFound 
	WinSet, TransColor, EEAA99 100	
	
	Hotkey, IfWinNotExist, VimT		
	Hotkey, +Escape, DoubleKeyToActivate, On
		
	global fn := Func("VimIsEnabled")	
	Hotkey, If, % fn
	
	Hotkey, Escape, DisableVim, On
	Hotkey, F1, VimHelp, On
	
	movModifiers := ["","+"]	
	loop, % movModifiers.MaxIndex()
	{
		modifier := movModifiers[A_Index]
		
		Hotkey, %modifier%w, sendWordNext, On
		Hotkey, %modifier%b, sendWordBack, On
		Hotkey, %modifier%z, SendBottom, On
		Hotkey, %modifier%q, sendTop, On		
		
		Hotkey, %modifier%o, SendCreateNewLine, On
		Hotkey, %modifier%u, SendUndo, On
		
		Hotkey, %modifier%y, ManageCopy, On
		Hotkey, %modifier%p, sendPaste, On
		
		Hotkey, %modifier%s, ManageSelected, On		
		
		Hotkey, %modifier%c, StoreSlotClipboad, On
		Hotkey, %modifier%v, RetrieveSlotClipboad, On
		
		Hotkey, %modifier%n, StoreMousePosition, On
		Hotkey, %modifier%m, ClickMousePosition, On
		
		Hotkey, %modifier%., sendLeftClick, On
		Hotkey, %modifier%`,, sendRightClick, On
		
		Hotkey, %modifier%i, allowInsert, On
	}
	
	Hotkey, 0, SendBeginLine, On
	Hotkey, $, SendEndLine, On	
	
	Hotkey, +d, DeleteLine, On	
	Hotkey, d, ManageCut, On	
	
	Hotkey, x, SendBackspace, On
	Hotkey, +x, SendDel, On
	
	Hotkey, r, replaceChar, On
	Hotkey, +r, replaceCharDel, On
	
	Hotkey, h, sendLeft, On
	Hotkey, j, sendDown, On
	Hotkey, k, sendUp, On
	Hotkey, l, sendRight, On	
	
	Hotkey, +h, moveMouseLeft, On
	Hotkey, +j, moveMouseDown, On
	Hotkey, +k, moveMouseUp, On
	Hotkey, +l, moveMouseRight, On
	
	Hotkey, ^h, moveFastMouseLeft, On
	Hotkey, ^j, moveFastMouseDown, On
	Hotkey, ^k, moveFastMouseUp, On
	Hotkey, ^l, moveFastMouseRight, On
	
	;"ñ","?","¿" removed cause error in some computers	
	;"m","n"
	nullKeys := ["Space","a","e","f","g","t","1","2","3","4","5","6","7","8","9",";","-","_","{","}","[","]","+","*","/","!","#","%","&","(",")","=","'","<",">",""""]
	
	Loop, % nullKeys.MaxIndex()
	{
		nullKey := nullKeys[A_Index]
		Hotkey, %nullKey%, DisableKey, On		
	}	
	
	Hotkey, if	
	
	DoubleKeyToActivate:
	if(DoubleKey("+Escape"))
		EnableVim()
	return	
}

VimIsEnabled(){
	global vimEnabled
	if vimEnabled = "ON"
		return true
	else
		return false
}

EnableVim()
{	
	global vimEnabled
	WinGet, active_id, ID, A
	yPos := A_ScreenHeight - 100
	Gui, vim:Show, autosize xCenter y%yPos%, VimT
	WinActivate, ahk_id %active_id%
	vimEnabled = "ON"
}

DisableVim()
{	
	global vimEnabled
	Gui, vim:Hide
	vimEnabled = "OFF"
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
	SendInput %visualMode%{Right}
}

sendWordNext(){
	global visualMode
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

SendBackspace(){
	SendInput, {Backspace}
}

DeleteLine(){	
	SendBeginLine()
	SendInput, +{End}
	SendDel()	
}

allowInsert(replace="None"){
	global vimEnabled
	global LabelId
	
	GuiControl, ,%LabelId%, Vim [I]
	vimEnabled = "OFF"
	Input, key, T1 L1
	vimEnabled = "ON"
	if(key)
		{
			if(replace = "B")
				SendBackspace()
			if(replace = "D")
				SendDel()
			SendInput, %key%
		}
	GuiControl, ,%LabelId%, Vim [N]
	
}

replaceChar(){
	allowInsert("B")
}

replaceCharDel(){
	allowInsert("D")
}

DisableKey(){	
	return true
}

ManageCopy(cutMode = false){	
	global vimEnabled
			
	vimEnabled = "OFF"
	Input, text, L1 T1, , w,l,s	
	vimEnabled = "ON"
	Switch text
	{
		case "w": SelectWord()
		case "l": SelectLine()		
	}	
	if(cutMode)
		SendInput, ^x
	else
		SendInput, ^c	
}

ManageCut(){
	ManageCopy(true)		
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

ManageSelected()
{
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

StoreSlotClipboad()
{
	global slotClipboard
	global vimEnabled
	vimEnabled = "OFF"
	Input, key, T2 L1
	vimEnabled = "ON"
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
	global vimEnabled
	vimEnabled = "OFF"
	Input, key, T2 L1
	vimEnabled = "ON"
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
	global vimEnabled
	vimEnabled = "OFF"
	Input, key, T2 L1
	vimEnabled = "ON"
	if(key){
		MouseGetPos, posX, posY, wId
		slotMouse[key] := {x:posX, y:posY, id:wId}
		showMessage("Stored in slot " . key, 1000)
	}
}

ClickMousePosition()
{
	global slotMouse
	global vimEnabled
	vimEnabled = "OFF"
	Input, key, T2 L1
	vimEnabled = "ON"
	if(slotMouse.HasKey(key))
	{
		mouseInfo := slotMouse[key]
		winId := mouseInfo.id
		WinActivate, ahk_id %winId%
		MouseClick, Left, mouseInfo.x, mouseInfo.y		
	}else
		showFailMessage("slot " . key . " is empty", 1000)
}

sendLeftClick(){
	Click	
}

sendRightClick(){
	Click,,, Right
}

translateMouse(x=0,y=0)
{
	MouseGetPos, posX, posY
	posX := posX + x
	posY := posY + y
	MouseMove, posX, posY
}

moveMouseRight(){
	global mouseDelta
	translateMouse(mouseDelta, 0)
}

moveMouseLeft(){
	global mouseDelta
	translateMouse(-mouseDelta, 0)
}

moveMouseUp(){
	global mouseDelta
	translateMouse(0, -mouseDelta)
}

moveMouseDown(){
	global mouseDelta
	translateMouse(0, mouseDelta)
}


moveFastMouseRight(){
	global mouseFastDelta
	translateMouse(mouseFastDelta, 0)
}

moveFastMouseLeft(){
	global mouseFastDelta
	translateMouse(-mouseFastDelta, 0)
}

moveFastMouseUp(){
	global mouseFastDelta
	translateMouse(0, -mouseFastDelta)
}

moveFastMouseDown(){
	global mouseFastDelta
	translateMouse(0, mouseFastDelta)
}

VimHelp(){
	helpText = 
(
S : Selection Mode (Press S again to set to Normal mode)
I : Insert one character (wait 1 second)
R : Replace one character before cursor
SHIFT + R: Replace one character after cursor

H : Move caret to left
J : Move caret to down
K : Move caret to up
L : Move caret to right

Q : Go to begin of page
Z : Go to end of page
W : Go next word
B : Go back word
0 : Go to begin of line
$ : Go to end of line

SHIFT + D : Delete line
O : New Lines

U : Undo last action	
X : Send BackSpace, SHIFT + X: Send Supr	

------------------------------------
#Clipboard actions

YL: Copy line, YW: Copy word, YS: Copy selected
DL: Cut line, DW, Cut word, DS, Cut selected
P : Paste from clipboard

C + Any char: Store in clipboard in slot marked by char
V + Any char: Retrieve from clipboard slot marked by char

------------------------------------
## Mouse actions

N + Any char: Store in slot mouse position
M + Any char: Retrieve from slot mouse position
SHIFT/CTRL + H : Move mouse to left 
SHIFT/CTRL + J : Move mouse to down
SHIFT/CTRL + K : Move mouse to up
SHIFT/CTRL + L : Move mouse to right
. : Send left Click
, : Send right Click

)
	MsgBox, ,Help, %helptext%, 
}