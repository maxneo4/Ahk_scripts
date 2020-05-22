#NoEnv
#SingleInstance Force 

SetWorkingDir %A_ScriptDir% 

Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Add, Edit, w400 x0 y0 vFilter gUpdate HwndEditId ;h35
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Color, EEAA99, F3282923
Gui +LastFound 
WinSet, TransColor, EEAA99 220
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

FileDelete, ShortKeys.txt
FileAppend, 
(
SHIFT+F1 : abre esta archivo para recordar los comandos

LOG DE NOTAS

CTRL+ALT+SPACE : agregar texto seleccionado al log

WIN+ALT+SPACE : abre caja de texto para escribir directamente al log

CTRL+ALT+O : abrir log del dia actual

CTRL+ALT+D : abrir log por fecha del calendario

----------------------------------------------------------------

REMEBER LIST

ESCAPE : oculta la lista

CTRL+WIN+R : agrega texto seleccionado a la lista

ALT+WIN+R : abre listRemember.txt

irm : muestra la lista para escoger el item a usar
), ShortKeys.txt
		
;COMMON

+F1::
Run, ShortKeys.txt
return

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

OSD_OFF:
Progress, off
return

sendCopy:   
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
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
	showMessage("Text added to log", 1000)	
return

#!Space::
InputBox, textToLog, , Text to log., , 500, 140
if ErrorLevel 
	ShowFailMessage("You cancel the dialog", 1000)
else
{
	Clipboard := textToLog
	gosub addToLog
}
return

^!o::
FormatTime, DateString,, ddMMMyyyy
IfExist, %DateString%.txt
	Run, %DateString%.txt
else
	showFailMessage(DateString ".txt is not created!", 1500)
return 

^!d:: ;open by selected date
Gui, dt:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, dt:Add, MonthCal, vMyCalendar
Gui, Font, s10
Gui, dt:Add, Button, gSelectedDate x100, Ok
Gui, Show
return 

selectedDate:
Gui, Submit ; important when selected date is today
FormatTime, DateString, %MyCalendar%000000 , ddMMMyyyy
Gui, dt:Hide
IfExist, %DateString%.txt
	Run, %DateString%.txt
else
	showFailMessage(DateString ".txt is not created!", 2000)
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
		showMessage("Text added to remember", 1000)
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
else
	showFailMessage("rememberList.txt is not created!", 1500)
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

