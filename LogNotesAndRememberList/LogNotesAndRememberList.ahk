#NoEnv
#SingleInstance Force 

SetWorkingDir %A_ScriptDir% 


Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Color, EEAA99, 282923
Gui +LastFound 
WinSet, TransColor, EEAA99

Gui, rl:Add, ListView, w800 h400 -Multi gMyListView AltSubmit -Hdr vLV2 HwndLVRLID, item ;important diff v and Hwn
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25

;~ FileRead, listContent, rememberList.txt
;~ Loop, Parse, listContent, `n
		;~ {
			;~ if  InStr(A_LoopField, filter) or (filter = )
				;~ LV_Add("", A_LoopField)
		;~ }
		
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

:*:irm:: ; invoke remember list
	Clipboard := 
	gosub sendCopy
	filter := Clipboard
	; IF FILTER EMPTY SHOW MODAL TO WRITE FILTER
	Gui, rl: Default ; important!
	
	GuiControl, -redraw, LV2
	GuiControl, -AltSubmit, LV2
	
	LV_Delete()		
	Loop, Read, rememberList.txt
	{
		if  InStr(A_LoopReadLine, filter) or (filter = )
			LV_Add("", A_LoopReadLine)
	}
	GuiControl, +redraw, LV2	
	GuiControl, +AltSubmit, LV2
	
	LV_ModifyCol()	
	gosub selectFirstRow	
	Gui, rl:show, AutoSize ,rememberlist	
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

^!t:: ; tasks
return

