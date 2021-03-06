InitRememberList() {
	global ownFolder := "LogNotesAndRememberList"
	global defaultFolder := A_ScriptDir . "\" . ownFolder
	global folder := defaultFolder	
	global rememberListFile
	global gRememberListFile
	global Filter
	global FilterId
	global rememberItemsDictionary := {}
	
	global defaultRemeberListFile := "LogNotesAndRememberList\rememberList.txt"
	rememberListFile := defaultRemeberListFile
	gRememberListFile := "LogNotesAndRememberList\GlobalRememberList.txt"
	
	global isGlobalWorking := false ;to define if tags column has size or not..
	
	static LVRLID
	static LV2	
	
	Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale ;-Caption
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Add, Edit, w840 x0 y0 vFilter gUpdateRememberFilter HwndFilterId ;h35
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Color, EEAA99, F3282923
	Gui +LastFound 

	
	WinSet, TransColor, EEAA99 250
	Gui, rl:Add, ListView, w840 h300 x0 y25 -Multi gListViewRLEvent AltSubmit -Hdr vLV2 HwndLVRLID, tag|item|order ;important diff v and Hwn
	LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25

	Hotkey, IfWinActive, rememberListWindow
	Hotkey, ~Enter, invokeText, On
	Hotkey, +Enter, runText, On
	Hotkey, ~Down, DownRL, On
	Hotkey, ~Up, UpRL, On
	Hotkey, ~Escape, RememberListHide, On
	Hotkey, if
	
	Hotkey, ^!Space , WaitSubCommandKeys, On
	Hotkey, ^+Space , WaitSubCommandKeys, On
	
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
Help =
(
la, li, lo   cs, ce, cc, co  ra, ro 
ga, go, gi   ws, wd, wo, wc, wp
)
	SplashTextOn, , 40, Waiting command, %Help%	
	Input, text, L3 T3, , la,li,lo,cs,co,ra,ro,ce,cc,ga,go,gi,ws,wd,wo,wc,wp
	SplashTextOff
	if(ErrorLevel != "Match")
		MsgBox, , Not match, % ErrorLevel . " value:" . text	
	Sleep, 250
	Switch text
	{
		case "la": addSelectedToLog()
		case "li": InputToLog()
		case "lo": openTodayLog()		
		case "cs": addCaptureToLog()
		case "ce": openCaptureEdit()
		case "cc": clipboardCaptureToLog()
		case "co": openScreenCaptureLog()		
		case "ra": addSelectedTextToList()
		case "ro": openRememberList()
		case "ga": addSelectedTextToGlobalList()
		case "go": openGlobalRememberList()
		case "gi": invokeGlobalRememberList(false)
		case "ws": changeLogNotesRememberWorkSpaceFolder()
		case "wd": restoreLogNotesRememberWorkSpaceFolder()
		case "wo": showCurrentWorkspace()
		case "wc": copyPathCurrentWorkspace()
		case "wp": copyPastePathCurrentWorkspace()
	}
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
}

openCaptureEdit(){
	SendInput, ^{PrintScreen}
	Clipboard := 
	ClipWait, 10
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

addToLog(){	
	global folder
	global defaultFolder
	FormatTime, DateString,, ddMMMyyyy
	FormatTime, TimeString,, HH:mm:ss	
	FileAppend, >>[%TimeString%] `r`n%Clipboard%`r`n`r`n, %folder%\%DateString%.txt 
	if (folder != defaultFolder) ;reply to defaultFolder
		FileAppend, >>[%TimeString%] (%folder%) `r`n%Clipboard%`r`n`r`n, %defaultFolder%\%DateString%.txt		
}

;REMEMBER LIST

invokeRememberList(){
	global rememberListFile	
	global isGlobalWorking
	isGlobalWorking = false
	invokeRememberListByPath(rememberListFile, true)
}

invokeGlobalRememberList(showInCaret = true){
	global gRememberListFile
	global isGlobalWorking
	isGlobalWorking = true
	invokeRememberListByPath(gRememberListFile, showInCaret)
}

invokeRememberListByPath(rememberListFile, showInCaret){	
	global FilterId
	global rememberListFileParam := rememberListFile
	UpdateRememberFilter()
	CoordMode, Caret, Screen 
	GuiControl, ,%FilterId% 	
	Sleep, 100
	if A_CaretX	and showInCaret
		Gui, rl:show, AutoSize x%A_CaretX% y%A_CaretY% ,rememberListWindow	
	else
		Gui, rl:show, AutoSize Center , rememberListWindow
	GuiControl, Focus, %FilterId%
	return
}

invokeText(){
	global SelectedText
	global rememberItemsDictionary
	Gui, rl:Hide
	
	if(rememberItemsDictionary.HasKey(SelectedText))
		Clipboard := rememberItemsDictionary[SelectedText]
	Else
		Clipboard := SelectedText	
	SendInput ^v
}

runText(){
	global SelectedText
	global rememberItemsDictionary
	Gui, rl:Hide
	textToRun := SelectedText
	if(rememberItemsDictionary.HasKey(SelectedText))
		textToRun := rememberItemsDictionary[SelectedText]	
	Run, %textToRun%, , UseErrorLevel
	if ErrorLevel
		MsgBox, , Error, %ErrorLevel% happen trying to run '%textToRun%', 2
}

ListViewRLEvent(){
	Gui, rl:Default
    global selectedText
	if(A_GuiEvent = "I") ; AltSubmit is necesary option
	    {        
	    	global selectedIndexRL
	        selectedIndexRL:= LV_GetNext() ; new focused row  
	        LV_GetText(selectedText, A_EventInfo, 2)
	    }
	return
}

UpdateRememberFilter(){ 	
	global rememberListFileParam
	global rememberItemsDictionary
	Gui, rl:Default 
	GuiControlGet Filter ;get content of control of associate var
	Filter := Trim(Filter)
	arrayWords := StrSplit(Filter, A_Space)	
	tagFilter := arrayWords[1]
	
	filterTagAndValue := false
	if(arrayWords.MaxIndex() > 1) ;to work first word with tags, others with value
	{
		arrayWords.Remove(1)
		filterTagAndValue := true
	}
	LV_Delete()	
	Loop, Read, %rememberListFileParam%
	{	
		line := A_LoopReadLine	
		
		parts := StrSplit(line, ">>")		
		if(parts.MaxIndex() = 2)
		{
			tags := parts[1]
			value := parts[2]							
		}else{
			tags = 
			value := line
		}
		ordered := tags . value
		
		if(StrLen(value) > 100)
		{
			originalValue := value
			len := StrLen(value)
			startSuffix := len - 30
			middleIndex := len / 2 - 30 / 2
			value := SubStr(value, 1, 30) . "[..]" . SubStr(value, middleIndex, 30) . "[..]" . SubStr(value, startSuffix, 31)
			rememberItemsDictionary[value] := originalValue 
		} 
		
		if (filterTagAndValue = true) {
			if InStr(tags, tagFilter) and ContainsAllWords(value, arrayWords) 
				LV_Add("", tags, value, ordered) ;fisrt tags, second value
		}
		else{		
			if  InStr(tags, tagFilter) or ContainsAllWords(value, arrayWords) or (Filter = )
				LV_Add("", tags, value, ordered) ;fisrt tags, second value				
		}
	}
	selectFirstRowRemember()
}

selectFirstRowRemember(){
	global isGlobalWorking
    LV_ModifyCol(3, "Sort")
    LV_Modify(1, "+Select +Focus")
    LV_ModifyCol(2)
    if isGlobalWorking = true
    	LV_ModifyCol(1, 100)
    else
    	LV_ModifyCol(1, 0) ;by default tags are invisible column
	LV_ModifyCol(3, 0)	
}

addSelectedTextToList(){
	global rememberListFile
	addSelectedTextToListByPath(rememberListFile)
}

addSelectedTextToGlobalList(){
	global gRememberListFile
	InputBox, textToAdd, Add to global remember., Set tags and value separated by >> , , 500, 140
	if ErrorLevel 
		ShowFailMessage("You cancel the dialog", 1000)
	else
	{		
		FileAppend, %textToAdd%`r`n, %gRememberListFile%
		showMessage("Text added to global remember", 1000)	
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

copyPathCurrentWorkspace(){
	global folder
	Clipboard := folder
}

copyPastePathCurrentWorkspace(){
	copyPathCurrentWorkspace()
	Send, ^v
}

RememberListHide(){
	Gui, rl:Hide
	return
}