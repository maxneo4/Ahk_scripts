;SetWorkingDir, C:\git\Ahk_scripts
;initFastContentWindow()
;F5::Reload

initFastContentWindow(){
	global
	clipItems := []
	clipNames := []
	Content = 	
	CHListBoxHwnd =
	FolderName = FastAccessContent
	hideFinished = 1
	CWidth = 600
	
	FileCreateDir, %FolderName%
	
	Hotkey, #o, openFastContentWindow, on
	Hotkey, ~LButton, validateIfChangeFocus, on
	Hotkey, #a, copyAndAddClipItem, on ;when used in window actived fails with error
	Hotkey, IfWinExist, Fast contents
	
	Hotkey, #v, addClipItem, on	
	Hotkey, #c, copySelectedItem, on
	Hotkey, #r, runSelectedItem, on
	HotKey, ^#r, runSelectedItemAsAdmin, on
	;#r run item, detect parent folder to use to working directory
	Hotkey, Escape, HideFastContentWindow, on	
	Hotkey, ~Delete, deleteSelectedItem, On
	Hotkey, if	
	
	Gui, clipboardForm:Default
	;set transparency
	;Gui, Color, CCCCCC	
	Gui +LastFound 
	validateIfChangeFocus()
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, 5, 5
	Gui, Font, s12	
	Gui, Add, ListView, HwndCHListBoxHwnd w%CWidth% h125 gUpdateItem AltSubmit -Hdr +Grid -Multi, defTitle
	LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 25, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25
	Gui, Font, s14
	Gui, Add, Edit, r10 vContent w%Cwidth% ReadOnly
	;Gui, Color, 000000, 000000	
	loadContentsFromDisk()
}

loadContentsFromDisk(){
	global
	SysGet, VSBW, 2   ; width of a vertical scroll bar
	Gui, ClipboardForm:Default
	patternFiles := FolderName . "/*.*"

	Loop, Files, %patternFiles%
 		FileList = %FileList%%A_LoopFileTimeModified%`t%A_LoopFileName%`t%A_LoopFileFullPath%`n
	Sort, FileList	
	Loop, parse, FileList, `n
	{
		if A_LoopField = 
        	continue     	
    	StringSplit, FileItem, A_LoopField, %A_Tab% 
    	If not ErrorLevel
		{			
			fileName := FileItem2
			fileFullPath := FileItem3
			LV_Add("", fileName)
			FileRead, newContent, %fileFullPath%
			clipItems.Push(newContent)
			clipNames.Push(fileName)
		}
	}	
	LV_ModifyCol(1, CWidth - VSBW - 4)
}

openFastContentWindow(moveScroll=0){
	global 	
	Gui, clipboardForm:Default
	Gui, Show,, Fast contents
	SetTransparencyShow()
	if moveScroll = 1
		Send {End} 
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
	cutLen := 34
	if(StrLen(text) > 100)
	{
		len := StrLen(text)
		startSuffix := len - cutLen
		text := SubStr(text, 1, cutLen) . " [...] " . SubStr(text, startSuffix, (cutLen+1))
	} 
	clipItems.Push(newContent)
	clipNames.Push(text)
	maxIndex := clipItems.MaxIndex()
	file := FolderName . "/" . text
	FileAppend, %newContent%, %file%
	LV_Add("", text)
	LV_Modify(maxIndex, "+Select +Focus")
	GuiControl, , Content , %newContent%
}

copyAndAddClipItem(){
	Clipboard =
	send, ^c
	Sleep, 250
	addClipItem()
	openFastContentWindow(1)
}

UpdateItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	If (A_GuiEvent == "I") && InStr(ErrorLevel, "S", True) {
		selectedContent := clipItems[A_EventInfo]	
		GuiControl, , Content , %selectedContent% 
		FCSelectedIndex := A_EventInfo  		
	}	
}

copySelectedItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	selectedContent := clipItems[FCSelectedIndex]
	Clipboard := selectedContent
	ShowToolTip("Item copied!")
	return 
}

runSelectedItemAsAdmin(){
	runSelectedItem(1)
}

runSelectedItem(runAsAdmin=0){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
	selectedContent := clipItems[FCSelectedIndex]
	loop, %selectedContent%
		ContainerDir := A_LoopFileDir
	
	if(runAsAdmin = 1)
		Run, *RunAs %selectedContent%, %ContainerDir%, UseErrorLevel, varPID
	Else
		Run, %selectedContent%, %ContainerDir%, , varPID
	; store in array to can kill with #k
	ContainerDir :=
}

deleteSelectedItem(){
	global
	Gui, clipboardForm:Default
	Gui, Submit, NoHide
		
	LV_Delete(FCSelectedIndex)
	GuiControl, , Content ,
	file := FolderName . "/" . clipNames[FCSelectedIndex]

	clipItems.remove(FCSelectedIndex)
	clipNames.remove(FCSelectedIndex)
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
			SetTimer, SetTransparencyHide, -30000
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