SetWorkingDir, C:\git\Ahk_scripts

initFastContentWindow()

F5::Reload

initFastContentWindow(){
	global
	clipItems := []
	clipNames := []
	Content = 	
	CHListBoxHwnd =
	FolderName = FastAccessContent
	hideFinished = 1
	Hotkey, #o, openFastContentWindow, on
	Hotkey, ~LButton, validateIfChangeFocus, on
	Hotkey, IfWinExist, 
	
	Hotkey, #v, addClipItem, on
	Hotkey, #a, copyAndAddClipItem, on ;when used in window actived fails with error
	Hotkey, #c, copySelectedItem, on
	;#r run item, detect parent folder to use to working directory
	Hotkey, Escape, HideFastContentWindow, on	
	Hotkey, Delete, deleteSelectedItem, On
	Hotkey, if	

	Gui, clipboardForm:Default
	;set transparency
	;Gui, Color, CCCCCC
	Gui +LastFound 
	validateIfChangeFocus()
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, 5, 5
	Gui, Add, ListBox, HwndCHListBoxHwnd vListClips w450 0x100 h100 gUpdateItem AltSubmit
	Gui, Add, Edit, r12 vContent w450 ReadOnly
	;Gui, Color, 000000, 000000	
	loadContentsFromDisk()
}

loadContentsFromDisk(){
	global
	Gui, ClipboardForm:Default
	patternFiles := FolderName . "/*.*"
	Loop, Files, %patternFiles%
	{
		GuiControl, , ListClips, %A_LoopFileName%
		FileRead, newContent, %A_LoopFileFullPath%
		clipItems.Push(newContent)
		clipNames.Push(A_LoopFileName)
	}
}

openFastContentWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Show,, Fast contents
	SetTransparencyShow()
}

HideFastContentWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Hide
}

addClipItem(customTitle=""){
	global
	Gui, clipboardForm:Default
	newContent := Clipboard
	if(StrLen(newContent)<1)
		return ;only if we have some newContent
	
	text := newContent 
	text := varize(text)
	if(StrLen(text) > 100)
	{
		len := StrLen(text)
		startSuffix := len - 40
		text := SubStr(text, 1, 40) . " [...] " . SubStr(text, startSuffix, 41)
	} 
	clipItems.Push(newContent)
	clipNames.Push(text)
	maxIndex := clipItems.MaxIndex()
	file := FolderName . "/" . text
	FileAppend, %newContent%, %file%
	GuiControl, , ListClips, %text%
	GuiControl, Choose, ListClips, %maxIndex%
	GuiControl, , Content , %newContent%
}

copyAndAddClipItem(){
	Clipboard =
	send, ^c
	Sleep, 250
	addClipItem()
}

UpdateItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	selectedContent := clipItems[ListClips]	
	GuiControl, , Content , %selectedContent%
}

copySelectedItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	selectedContent := clipItems[ListClips]
	Clipboard := selectedContent
	ToolTip, Item copied!, , ,
	SetTimer, RemoveToolTip, -1000
	return 

	RemoveToolTip:
	ToolTip
	return
}

deleteSelectedItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	
	Control, Delete, %ListClips%,, % "ahk_id " . CHListBoxHwnd
	GuiControl, , Content ,
	file := FolderName . "/" . clipNames[ListClips]

	clipItems.remove(ListClips)
	clipNames.remove(ListClips)
	FileDelete, %file%
}

validateIfChangeFocus(){
	global
	SetTimer, changeTransparency, -250	
}

changeTransparency(){
	global
	IfWinActive, Fast contents
	{
		;MsgBox will be actived
		SetTimer, SetTransparencyHide, off
		hideFinished = 1
		SetTransparencyShow()
	}
	Else
	{
		if hideFinished = 1
		{
			hideFinished = 0
			SetTimer, SetTransparencyHide, -10000
		}
	}
}

SetTransparencyShow(){
	Gui, clipboardForm:Default
	GuiControl, Show, Content
	Gui, Color, FFFFFF
	Gui +LastFound 
	WinSet, TransColor, CCCCCC 230
}

SetTransparencyHide(){
	global
	hideFinished = 1
	Gui, clipboardForm:Default
	GuiControl, Hide, Content
	Gui, Color, CCCCCC
	Gui +LastFound 
	WinSet, TransColor, CCCCCC 150
}

varize(var){
   var := StrReplace(var, "`r`n", " ")
   var := StrReplace(var, "`t")
   chars = .,<>:;'"/|\*?
   loop, parse, chars,
   	var := StrReplace(var, A_Loopfield, " ")
   return var
}