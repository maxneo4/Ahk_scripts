#SingleInstance Force 

SetWorkingDir %A_ScriptDir% 
FormatTime, DateString,, ddMMMyyyy

^!Space::

FormatTime, TimeString,, HH:mm:ss

gosub sendCopy

FileAppend, >>[%TimeString%] `r`n%Clipboard%`r`n`r`n, %DateString%.txt 

Clipboard = ;

Progress, B1 W200 H28 ZH0 FS11 WS900 Y400 CT0000FF, Text added to log
SetTimer, OSD_OFF, -1000

return

OSD_OFF:
Progress, off
return

^!o::

Run, %DateString%.txt

return 

sendCopy:
   Sleep, 100
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
   Sleep, 100
return

^w::
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