InitRememberList() {
	global folder := A_ScriptDir . "\LogNotesAndRememberList"
	global ownFolder := "LogNotesAndRememberList"
	global rememberListFile
	global gRememberListFile
	global Filter
	global FilterId
	
	global defaultRemeberListFile := "LogNotesAndRememberList\rememberList.txt"
	rememberListFile := defaultRemeberListFile
	gRememberListFile := "LogNotesAndRememberList\GlobalRememberList.txt"
	
	
	static LVRLID
	static LV2	
	
	Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Add, Edit, w600 x0 y0 vFilter gUpdateRememberFilter HwndFilterId ;h35
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Color, EEAA99, F3282923
	Gui +LastFound 
	WinSet, TransColor, EEAA99 220
	Gui, rl:Add, ListView, w600 h300 x0 y25 -Multi gListViewRLEvent AltSubmit -Hdr vLV2 HwndLVRLID, item ;important diff v and Hwn
	LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25
	
	FileRead, listContent, %rememberListFile%
	Loop, Parse, listContent, `n
	{
		if  A_LoopField
			LV_Add("", A_LoopField)
	}
	LV_ModifyCol()				
	selectFirstRowRemember()
	
	Hotkey, IfWinActive, rememberListWindow
	Hotkey, ~Enter, invokeText, On
	Hotkey, ~Down, DownRL, On
	Hotkey, ~Up, UpRL, On
	Hotkey, ~Escape, RememberListHide, On
	Hotkey, if
	
	Hotkey, ^!Space , WaitSubCommandKeys, On
	Hotkey, +Space , WaitSubCommandKeys, On
	
	Hotkey, IfWinNotActive, ahk_exe strwinclt.exe
	Hotstring(":X*:irm", "invokeRememberList")
	Hotstring(":X*:irl", "invokeRememberList")
	Hotstring(":X*:irg", "invokeGlobalRememberList")
	Hotkey, if
	
	DownRL:      	
	ControlGetFocus, OutVar, rememberListWindow    
	if OutVar contains edit ;retrive edit or similar        
		GuiControl, Focus, %LVRLID% 
	return
	
	UpRL:  
	global selectedIndexRL
	ControlGetFocus, OutVar, rememberListWindow
	if (OutVar contains listView) and (selectedIndexRL < 2)
		GuiControl, Focus, %FilterId%
	return
}

WaitSubCommandKeys(){
	Input, text, L3 T3, , la,li,lo,ld,cs,co,cd,ra,ro,ce,cc,ga,go,gi
	Switch text
	{
		case "la": addSelectedToLog()
		case "li": InputToLog()
		case "lo": openTodayLog()
		case "ld": openLogByDate()
		case "cs": addCaptureToLog()
		case "ce": openCaptureEdit()
		case "cc": clipboardCaptureToLog()
		case "co": openScreenCaptureLog()
		case "cd": openScreenCaptureByDate()
		case "ra": addSelectedTextToList()
		case "ro": openRememberList()
		case "ga": addSelectedTextToGlobalList()
		case "go": openGlobalRememberList()
		case "gi": invokeGlobalRememberList()
	}		
	return
}

;LOG NOTES

addSelectedToLog(){
	sendSmartCopy()
	RemoveBreakLinesAndTrimClipboard()
	if Clipboard {
		addToLog()
		showMessage("Text added to log", 1000)
	}	
}

InputToLog(){
	InputBox, textToLog, , Text to log., , 500, 140
	if ErrorLevel 
		ShowFailMessage("You cancel the dialog", 1000)
	else
	{
		Clipboard := textToLog
		addToLog()
	}
}

openTodayLog(){
	global folder
	FormatTime, DateString,, ddMMMyyyy
	IfExist, %folder%\%DateString%.txt
		Run, %folder%\%DateString%.txt
	else
		showFailMessage(DateString ".txt is not created!", 1500)
	return 
}


;open by selected date
openLogByDate(){
	global mode
	mode := "file"
	openCalendar()
	return 
}

addCaptureToLog(sendToCaptureScreen=1){
	global folder
	global ownFolder
	FormatTime, DateString,, ddMMMyyyy
	FormatTime, TimeString,, HH-mm-ss
	IfNotExist, %folder%\%DateString%
	   FileCreateDir, %folder%\%DateString%
	if sendToCaptureScreen
		SendInput, #+s
	Run, %A_ScriptDir%\%ownFolder%\ClipboardImageToFile.exe -secondsToWait 20 -imagePath "%folder%\%DateString%\%TimeString%.png"
	return
}

openCaptureEdit(){
	SendInput, ^{PrintScreen}
	ClipWait, 5
	clipboardCaptureToLog()
}

clipboardCaptureToLog(){
	addCaptureToLog(0)
	showMessage("Saving clipboard image to images log",1000)
}

openScreenCaptureLog(){
	global folder
	FormatTime, DateString,, ddMMMyyyy
	IfExist, %folder%\%DateString%
		Run, %folder%\%DateString%
	else
		showFailMessage("images log not created!", 2000)
	return
}

openScreenCaptureByDate(){
	global mode
	mode := "folder"
	openCalendar()
	return
}

addToLog(){	
	global folder
	FormatTime, DateString,, ddMMMyyyy
	FormatTime, TimeString,, HH:mm:ss
	FileAppend, >>[%TimeString%] `r`n%Clipboard%`r`n`r`n, %folder%\%DateString%.txt 
	return
}

openCalendar(){
	global MyCalendar
	Gui, dt:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, dt:Add, MonthCal, vMyCalendar
	Gui, Font, s10
	Gui, dt:Add, Button, gSelectedDate x100, Ok
	Gui, Show
	return
}

selectedDate(){
	global folder
	global mode
	global MyCalendar
	Gui, dt:Submit ; important when selected date is today
	FormatTime, DateString, %MyCalendar%000000 , ddMMMyyyy
	Gui, dt:Hide
	if(mode = "file")
	{
		IfExist, %folder%\%DateString%.txt
			Run, %folder%\%DateString%.txt
		else
			showFailMessage(DateString ".txt is not created!", 2000)
	}
	if(mode = "folder")
	{
		IfExist, %folder%\%DateString%
			Run, %folder%\%DateString%
		else
			showFailMessage(DateString " images log not created!", 2000)
	}
	return
}

;REMEMBER LIST

invokeRememberList(){
	global rememberListFile	
	invokeRememberListByPath(rememberListFile)
}

invokeGlobalRememberList(){
	global gRememberListFile
	invokeRememberListByPath(gRememberListFile)
}

invokeRememberListByPath(rememberListFile){	
	global FilterId
	global rememberListFileParam := rememberListFile
	UpdateRememberFilter()
	CoordMode, Caret, Screen 
	GuiControl, ,%FilterId% 	
	Sleep, 100
	if A_CaretX	
		Gui, rl:show, AutoSize x%A_CaretX% y%A_CaretY% ,rememberListWindow	
	else
		Gui, rl:show, AutoSize Center , rememberListWindow
	GuiControl, Focus, %FilterId%
	return
}

invokeText(){
	global SelectedText
	Gui, rl:Hide
	Clipboard := SelectedText	
	SendInput ^v
	return
}

ListViewRLEvent(){
	Gui, rl:Default
    global selectedText
	if(A_GuiEvent = "I") ; AltSubmit is necesary option
	    {        
	    	global selectedIndexRL
	        selectedIndexRL:= LV_GetNext() ; new focused row  
	        LV_GetText(selectedText, A_EventInfo, 1)
	    }
	return
}

UpdateRememberFilter(){ 	
	global rememberListFileParam
	Gui, rl:Default 
	GuiControlGet Filter ;get content of control of associate var
	Filter := Trim(Filter)
	arrayWords := StrSplit(Filter, A_Space)
	LV_Delete()	
	Loop, Read, %rememberListFileParam%
	{	
		line := A_LoopReadLine	
		if  InStr("", Filter) or ContainsAllWords(line, arrayWords) or (Filter = )
			LV_Add("", A_LoopReadLine)
	}
	selectFirstRowRemember()
	LV_ModifyCol()
	return
}

selectFirstRowRemember(){
    LV_ModifyCol(1, "Sort")
    LV_Modify(1, "+Select +Focus")
	return
}

addSelectedTextToList(){
	global rememberListFile
	addSelectedTextToListByPath(rememberListFile)
}

addSelectedTextToGlobalList()
{
	global gRememberListFile
	InputBox, textToLog, , Add to global remember., , 500, 140
	if ErrorLevel 
		ShowFailMessage("You cancel the dialog", 1000)
	else
	{
		Clipboard := textToLog
		addSelectedTextToListByPath(gRememberListFile)
	}
	
}

; add to list remember
addSelectedTextToListByPath(rememberListFile){	
	sendSmartCopy()
	RemoveBreakLinesAndTrimClipboard()
	if Clipboard
	{		
		addToLog()
		FileAppend, %Clipboard%`r`n, %rememberListFile%
		showMessage("Text added to remember", 1000)
	}		
	return
}

openRememberList(){
	global rememberListFile
	openRememberListByPath(rememberListFile)
}

openGlobalRememberList(){
	global gRememberListFile
	openRememberListByPath(gRememberListFile)
}

; open remember list file
openRememberListByPath(rememberListFile){
	
	IfExist, %rememberListFile%
		Run, %rememberListFile%
	else
		showFailMessage("rememberList.txt is not created!", 1500)
	return 
}

changeLogNotesRememberWorkSpaceFolder(){	
	global folder
	global rememberListFile
	newFolder := getSmartCurrentFolder()
	if(newFolder)
	{
		folder := StrReplace(newFolder, "file:", "")
		rememberListFile :=  StrReplace(newFolder, "file:", "") . "\rememberList.txt"
		showText("","Workspace was changed to " . folder, 2000, 500, 60)
	}
}

restoreLogNotesRememberWorkSpaceFolder(){
	global folder := A_ScriptDir . "\LogNotesAndRememberList"
	global rememberListFile
	global defaultRemeberListFile
	rememberListFile := defaultRemeberListFile
	showText("","Workspace was restored to default", 1500)
}

showCurrentWorkspace(){
	global folder
	Run, %folder%
}

RememberListHide(){
	Gui, rl:Hide
	return
}