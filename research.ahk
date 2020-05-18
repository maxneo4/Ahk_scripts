#SingleInstance Force 

SetWorkingDir %A_ScriptDir% 
FormatTime, DateString,, ddMMMyyyy

Gui, rl:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Font, s10 Arial cA9A9A7
Gui, rl:Color, EEAA99, 282923
Gui +LastFound 
WinSet, TransColor, EEAA99

; Create the ListView with two columns, Name and Size:
Gui, rl:Add, ListView, w800 h400 -Multi gMyListView AltSubmit -Hdr vLV2 HwndLVRLID, item ;important diff v and Hwn
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25

;~ FileRead, listContent, rememberList.txt
;~ Loop, Parse, listContent, `n
		;~ {
			;~ if  InStr(A_LoopField, filter) or (filter = )
				;~ LV_Add("", A_LoopField)
		;~ }

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

^!Space::
	gosub sendCopy
	gosub addToLog	
	Clipboard = ;
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, Text added to log
	SetTimer, OSD_OFF, -1000
return

^!r:: ; remember
	gosub sendCopy
	gosub addToLog
	FileAppend, %Clipboard%`r`n, rememberList.txt 
	Clipboard = ;
	Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, Text added to remember
	SetTimer, OSD_OFF, -1000
return

#f::
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

OSD_OFF:
Progress, off
return

addToLog:	
	FormatTime, TimeString,, HH:mm:ss
	FileAppend, >>[%TimeString%] `r`n%Clipboard%`r`n`r`n, %DateString%.txt 
return

^+r::
Run, rememberList.txt
return 

^!o::
Run, %DateString%.txt
return 

sendCopy:   
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
return


^w::
CoordMode, Caret, Screen 
Gui, New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Add, ListBox, r5 vColorChoice, Red|Green|Blue|Black|White
posY := 20 
posX := 0
if A_CaretX
	posX += A_CaretX
if A_CaretY
	posY += A_CaretY
Gui, show, x%posX% y%posY%
return


^i::
Pics := []
; Find some pictures to display.
Loop, Files, %Folder%\web\images\*.png, R
{
    ; Load each picture and add it to the array.
    Pics.Push(LoadPicture(A_LoopFileFullPath))
}
if !Pics.Length()
{
    ; If this happens, edit the path on the Loop line above.
    MsgBox, No pictures found!  Try a different directory.
    ExitApp
}
; Add the picture control, preserving the aspect ratio of the first picture.
Gui, Add, Pic, +Border +BackgroundTrans vPic x10 y10 ,  % "HBITMAP:*" Pics.1


Gui, Show, w800 h600
Loop 
{
	Sleep 2000
    ; Switch pictures!
	;Gui, Add, Pic, +Border +BackgroundTrans x6 y10 , % "HBITMAP:*" Pics[Mod(A_Index, Pics.Length())+1]
    ;GuiControl, , Pic, % Pics[Mod(A_Index, Pics.Length())+1] 
	opt := "*w0 *h0 "
	GuiControl, Move , Pic, *w0 *h0
	GuiControl, , Pic, % "HBITMAP:*" Pics[Mod(A_Index, Pics.Length())+1]
	
}
return

GuiClose:
GuiEscape:
ExitApp
return