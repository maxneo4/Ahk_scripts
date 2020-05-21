#NoEnv
#SingleInstance Force 

SetWorkingDir %A_ScriptDir% 

Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Add, Edit, w400 x0 y0 vFilter gUpdate HwndEditId ;h35
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Color, EEAA99, F3282923
Gui +LastFound 
WinSet, TransColor, EEAA99 200
Gui, rl:Add, ListView, w400 h300 x0 y25 -Multi gMyListView AltSubmit -Hdr vLV2 HwndLVRLID, item ;important diff v and Hwn
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25

 FileRead, listContent, rememberList.txt
 Loop, Parse, listContent, `n
		{
			if  A_LoopField
				LV_Add("", A_LoopField)
		}
LV_ModifyCol()	
		
gosub SelectFirstRow
		
;COMMON

sendCopy:   
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
return
		
OSD_OFF:
Progress, off
return
		
;LOG NOTES

addToLog:	
	FormatTime, DateString,, ddMMMyyyy
	FormatTime, TimeString,, HH:mm:ss
	FileAppend, >>[%TimeString%] `r`n%Clipboard%`r`n`r`n, %DateString%.txt 
return

^!Space::
	gosub sendCopy
	gosub addToLog	
	Clipboard = ;
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, Text added to log
	SetTimer, OSD_OFF, -1000
return

^!o::
Run, %DateString%.txt
return 

;REMEMBER LIST

MyListView:
if(A_GuiEvent = "I") ; AltSubmit is necesary option
    {        
        selectedIndex:= LV_GetNext() ; new focused row  
        LV_GetText(selectedText, A_EventInfo, 1)
    }
return

Update:
    GuiControlGet Filter ;get content of control of associate var
    LV_Delete()
    Loop, Read, rememberList.txt
	{
		if  InStr(A_LoopReadLine, Filter) or (Filter = )
			LV_Add("", A_LoopReadLine)
	}
    gosub selectFirstRow
	LV_ModifyCol()
    return

selectFirstRow:
    LV_ModifyCol(1, "Sort")
    LV_Modify(1, "+Select +Focus")
return

~Escape::
	Gui, rl:Hide
return

^#r:: ; add to list remember
	Clipboard :=
	gosub sendCopy
	if Clipboard
	{
		gosub addToLog
		Clipboard :=  StrReplace(Clipboard, "`r`n")
		FileAppend, %Clipboard%`r`n, rememberList.txt 
		Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, Text added to remember
		SetTimer, OSD_OFF, -1000
	}		
return

:*:irm:: 
	CoordMode, Caret, Screen 
	GuiControl, ,%EditId% 	
	Sleep, 100
	if A_CaretX	
		Gui, rl:show, AutoSize x%A_CaretX% y%A_CaretY% ,rememberlist	
	else
		Gui, rl:show, AutoSize Center , rememberlist
	GuiControl, Focus, %EditId%
return

!#r:: ; open remember list file
IfExist, rememberList.txt
	Run, rememberList.txt
return 

~Enter::
IfWinActive, rememberlist    
    gosub invokeText
return

invokeText:
    Gui, rl:Hide
	Clipboard := SelectedText	
	SendInput ^v
return

~Down::    
    ControlGetFocus, OutVar, rememberlist    
    if OutVar contains edit ;retrive edit or similar        
            GuiControl, Focus, %LVRLID% 
return
    
~Up::       
    ControlGetFocus, OutVar, rememberlist
    if (OutVar contains listView) and (selectedIndex < 2)
        GuiControl, Focus, %EditId%
	return

^!t:: ; tasks
return

