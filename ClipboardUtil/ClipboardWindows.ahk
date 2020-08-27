initClipboardWindow()

initClipboardWindow(){
	global
	clipItems := []
	Content = 	
	Hotkey, ^#o, openClipboardWindow, on
	Hotkey, #v, addClipItem, on
	Hotkey, #a, copyAndAddClipItem, on
	;add copy selected item
	;add delete selected item

	Gui, clipboardForm:Default
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, 5, 5
	Gui, Add, ListBox, vListClips w500 0x100 h100 gUpdateItem AltSubmit
	Gui, Add, Edit, r12 vContent w500 ReadOnly
}

openClipboardWindow(){
	global 	
	Gui, clipboardForm:Default
	Gui, Show,, Clipboard history
}

addClipItem(){
	global
	Gui, clipboardForm:Default
	newContent := Clipboard
	clipItems.Push(newContent)
	maxIndex := clipItems.MaxIndex()
	text := newContent 
	if(StrLen(text) > 100)
	{
		len := StrLen(text)
		startSuffix := len - 50
		text := SubStr(newContent, 1, 50) . " [...] " . SubStr(newContent, startSuffix, 50)
	} 
	GuiControl, , ListClips, %text%
	GuiControl, Choose, ListClips, %maxIndex%
	GuiControl, , Content , %newContent%
}

copyAndAddClipItem(){
	send, ^c
	addClipItem()
}

UpdateItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	selectedContent := clipItems[ListClips]	
	GuiControl, , Content , %selectedContent%
}