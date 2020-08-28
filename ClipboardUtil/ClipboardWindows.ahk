initClipboardWindow()

initClipboardWindow(){
	global
	clipItems := []
	Content = 	
	CHListBoxHwnd =
	Hotkey, ^#o, openClipboardWindow, on
	Hotkey, IfWinExist, Clipboard history
	Hotkey, #v, addClipItem, on
	Hotkey, #a, copyAndAddClipItem, on
	Hotkey, #c, copySelectedItem, on
	;#r run item
	Hotkey, Escape, HideClipboardWindow, on	
	Hotkey, Delete, deleteSelectedItem, On
	Hotkey, if	

	Gui, clipboardForm:Default
	;set transparency
	Gui, Color, EEAA99, F3282923
	Gui +LastFound 
	WinSet, TransColor, EEAA99 250
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, 5, 5
	Gui, Add, ListBox, HwndCHListBoxHwnd vListClips w500 0x100 h100 gUpdateItem AltSubmit
	Gui, Add, Edit, r12 vContent w500 ReadOnly
}

openClipboardWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Show,, Clipboard history
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