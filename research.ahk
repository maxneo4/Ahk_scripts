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