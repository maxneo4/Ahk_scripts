InitRememberList("LogNotesAndRememberList\rememberList.txt")

InitRememberList(rememberListFileParam) {
	global folder = "LogNotesAndRememberList"
	global rememberListFile
		
	rememberListFile := rememberListFileParam

	static FilterId
	static LVRLID
	static LV2

	Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Add, Edit, w400 x0 y0 vFilter gUpdateRememberFilter HwndFilterId ;h35
	Gui, Font, s10 Arial cA9A9A7
	Gui, rl:Color, EEAA99, F3282923
	Gui +LastFound 
	WinSet, TransColor, EEAA99 220
	Gui, rl:Add, ListView, w400 h300 x0 y25 -Multi gListViewRLEvent AltSubmit -Hdr vLV2 HwndLVRLID, item ;important diff v and Hwn
	LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25

	FileRead, listContent, %rememberListFile%
	Loop, Parse, listContent, `n
		{
			if  A_LoopField
				LV_Add("", A_LoopField)
		}
	LV_ModifyCol()				
	selectFirstRowRemember()

	Hotkey, IfWinActive, rememberList
    Hotkey, ~Enter, invokeText, On
    Hotkey, ~Down, DownRL, On
    Hotkey, ~Up, UpRL, On
    Hotkey, if

    Hotkey, ^Space , WaitSubCommandKeys, On

    Hotkey, ^!L , addSelectedToLog, On
    Hotkey, ^!O , openTodayLog, On
    Hotkey, ^!d , openLogByDate, On
    Hotkey, ^+c , addCaptureToLog, On
    Hotkey, ^+o , openScreenCaptureLog, On
    Hotkey, ^+d , openScreenCaptureByDate, On

    Hotstring(":X*:irm", "invokeRememberList")
    Hotkey, ^#r , addSelectedTextToList, On
    Hotkey, ^#o , openRememberList, On

    DownRL:  
	    ControlGetFocus, OutVar, rememberlist    
	    if OutVar contains edit ;retrive edit or similar        
            GuiControl, Focus, %LVRLID% 
	return
    
	UpRL:  
		global selectedIndexRL
	    ControlGetFocus, OutVar, rememberlist
	    if (OutVar contains listView) and (selectedIndexRL < 2)
	        GuiControl, Focus, %FilterId%
	return

}

showMessage(message, time)
{
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, %message%
	SetTimer, OSD_OFF, -%time%
}

showFailMessage(message, time)
{
	Progress, B1 W300 H28 ZH0 FS11 WS900 Y400 CTFF0000, %message%
	SetTimer, OSD_OFF, -%time%
}

OSD_OFF(){
	Progress, off
	return
}

sendLiteCopy(){
   Clipboard :=
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return	
}

WaitSubCommandKeys(){
	Input, text, L3 T3, , l,il,o,d,cs,co,cd,ra,ro,ri
	Switch text
    {
        case "l": addSelectedToLog()
        case "il": InputToLog()
        case "o": openTodayLog()
        case "d": openLogByDate()
        case "cs": addCaptureToLog()
        case "co": openScreenCaptureLog()
        case "cd": openScreenCaptureByDate()
        case "ra": addSelectedTextToList()
        case "ro": openRememberList()
        case "ri": invokeRememberList()
    }		
	return
}

;LOG NOTES

addSelectedToLog(){
	sendLiteCopy()
	addToLog()
	showMessage("Text added to log", 1000)
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
	return
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

addCaptureToLog(){
	global folder
	FormatTime, DateString,, ddMMMyyyy
	FormatTime, TimeString,, HH-mm-ss
	IfNotExist, %folder%\%DateString%
	   FileCreateDir, %folder%\%DateString%
	SendInput, #+s	
	Clipboard = %A_ScriptDir%\%folder%\ClipboardImageToFile.exe -secondsToWait 20 -imagePath "%A_ScriptDir%\%folder%\%DateString%\%TimeString%.png"
	Run, %A_ScriptDir%\%folder%\ClipboardImageToFile.exe -secondsToWait 20 -imagePath "%A_ScriptDir%\%folder%\%DateString%\%TimeString%.png"
	return
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

UpdateRememberFilter:
	global rememberListFile  
    GuiControlGet Filter ;get content of control of associate var
    LV_Delete()
    Loop, Read, %rememberListFile%
	{
		if  InStr(A_LoopReadLine, Filter) or (Filter = )
			LV_Add("", A_LoopReadLine)
	}
    selectFirstRowRemember()
	LV_ModifyCol()
    return

selectFirstRowRemember(){
    LV_ModifyCol(1, "Sort")
    LV_Modify(1, "+Select +Focus")
	return
}

; add to list remember
addSelectedTextToList(){
	global rememberListFile
	Clipboard :=
	sendLiteCopy()
	if Clipboard
	{
		addToLog()
		Clipboard :=  StrReplace(Clipboard, "`r`n")
		FileAppend, %Clipboard%`r`n, %rememberListFile%
		showMessage("Text added to remember", 1000)
	}		
	return
}

invokeRememberList(){
	CoordMode, Caret, Screen 
	GuiControl, ,%FilterId% 	
	Sleep, 100
	if A_CaretX	
		Gui, rl:show, AutoSize x%A_CaretX% y%A_CaretY% ,rememberList	
	else
		Gui, rl:show, AutoSize Center , rememberList
	GuiControl, Focus, %FilterId%
	return
}

; open remember list file
openRememberList(){
	global rememberListFile
	IfExist, %rememberListFile%
		Run, %rememberListFile%
	else
		showFailMessage("rememberList.txt is not created!", 1500)
	return 
}

RememberListHide(){
	Gui, rl:Hide
	return
}