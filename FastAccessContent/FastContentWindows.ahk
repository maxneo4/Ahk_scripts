;initClipboardWindow()

initClipboardWindow(){
	global
	clipItems := []
	Content = 	
	CHListBoxHwnd =
	Hotkey, #o, openClipboardWindow, on
	Hotkey, ~LButton, validateIfChangeFocus, on
	Hotkey, IfWinExist, 
	
	Hotkey, #v, addClipItem, on
	Hotkey, #a, copyAndAddClipItem, on ;when used in window actived fails with error
	Hotkey, #c, copySelectedItem, on
	;#r run item, detect parent folder to use to working directory
	Hotkey, Escape, HideClipboardWindow, on	
	Hotkey, Delete, deleteSelectedItem, On
	Hotkey, if	

	Gui, clipboardForm:Default
	;set transparency
	;Gui, Color, CCCCCC
	Gui +LastFound 
	validateIfChangeFocus()
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, 5, 5
	Gui, Add, ListBox, HwndCHListBoxHwnd vListClips w500 0x100 h100 gUpdateItem AltSubmit
	Gui, Add, Edit, r12 vContent w500 ReadOnly
	;Gui, Color, 000000, 000000	
}

openClipboardWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Show,, Fast contents
}

HideClipboardWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Hide
}

addClipItem(){
	global
	Gui, clipboardForm:Default
	newContent := Clipboard
	if(StrLen(newContent)<1)
		return ;only if we have some newContent
	clipItems.Push(newContent)
	maxIndex := clipItems.MaxIndex()
	text := newContent 
	text := StrReplace(text, "|", "")
	if(StrLen(text) > 100)
	{
		len := StrLen(text)
		startSuffix := len - 40
		text := SubStr(newContent, 1, 40) . " [...] " . SubStr(newContent, startSuffix, 41)
	} 
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
	clipItems.remove(ListClips)
	Control, Delete, %ListClips%,, % "ahk_id " . CHListBoxHwnd
	GuiControl, , Content ,
}

validateIfChangeFocus(){
	global
	SetTimer, changeTransparency, -250
	Return

	changeTransparency:
	Gui, clipboardForm:Default
	IfWinActive, Fast contents
	{
		GuiControl, Show, Content
		Gui, Color, FFFFFF
		Gui +LastFound 
		WinSet, TransColor, CCCCCC 230		
		return
	}		
	GuiControl, Hide, Content
	Gui, Color, CCCCCC
	Gui +LastFound 
	WinSet, TransColor, CCCCCC 150
	return
}