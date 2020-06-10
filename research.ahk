#SingleInstance Force
SetWorkingDir %A_ScriptDir% 

init()
{	
	Hotkey, ~RControl, DoubleA, On
}


DoubleA(){
	if(A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400)
	{
		KeyWait, RControl
		return
	}
	MsgBox,,, You double pressed a key	
}


^!f::
Input, text, L3 T3, , oi,ol,ob
Switch text
{
        case "oi": MsgBox,,, Open I
        case "ob": MsgBox,,, Open B
        case "ol": MsgBox,,, Open L
    }
return


GroupAdd, FileListers, ahk_class CabinetWClass
GroupAdd, FileListers, ahk_class WorkerW
GroupAdd, FileListers, ahk_class #32770, ShellView

;ALT+D is used from CTRL+D : go to address bar in windows explorer like navigators
#IfWinActive ahk_group FileListers
^l::SendInput !d

;Open in cmd current windows explorer folder
#IfWinActive ahk_group FileListers  
^!t::SendInput !dcmd{Enter}

; Get selected files in explorer and more:
; http://www.autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
#IfWinActive ahk_group FileListers
^s::
SelectByRegEx() {
    static selectionPattern := ""
    WinGetPos, wx, wy
    ControlGetPos, cx, cy, cw, , DirectUIHWND3
    x := wx + cx + cw/2 - 200
    y := wy + cy
    InputBox, selectionPattern, Select by regex
        , Enter regex pattern to select files that CONTAIN it (Empty to select all)
        , , 400, 150, %x%, %y%, , , %selectionPattern%
    if ErrorLevel
        Return
    for window in ComObjCreate("Shell.Application").Windows
        if WinActive("ahk_id " . window.hwnd) {
            pattern := "S)" . selectionPattern
            items := window.document.Folder.Items
            total := items.Count()
            i := 0
            showProgress := total > 160
            if (showProgress)
                Progress, b w200, , Matching...
            for item in items {
                match := RegExMatch(item.Name, pattern) ? 17 : 0
                window.document.SelectItem(item, match)
                if (showProgress) {
                    i := i + 100
                    Progress, % i / total
                }
            }
            Break
        }
    Progress, Off
}

#include C:\git\Ahk_scripts\Ahk Resources\AhkLibs\SelectedPath.ahk


#IfWinActive ahk_group FileListers
^#c::
	SplashTextOn, before
    SoundBeep
    Clipboard := Explorer_GetSelected()
	SplashTextOff
    Return
    
#IfWinActive ahk_group FileListers
^#n::
CreateFolderHierarchy() {
    loc := Explorer_GetPath()
    WinGetPos, wx, wy
    ControlGetPos, cx, cy, cw, , DirectUIHWND3
    x := wx + cx + cw/2 - 200
    y := wy + cy
    InputBox, folder, Create Folder, Enter folder name/path create:, , 400, 120
        , %x%, %y%
    if ErrorLevel
        Return
    folder := StrReplace(folder, "/", "\")
    pos := RegExMatch(folder, "O)\{([^\{]+)\}", match)
    folders := []
    if (pos > 0) {
        parts := StrSplit(match.value(1), ",")
        prefix := SubStr(folder, 1, match.Pos(0) - 1)
        suffix := SubStr(folder, match.Pos(0) + match.Len(0))
        for i, part in parts {
            folders.Push(prefix . part . suffix)
        }
    } else {
        folders.Push(folder)
    }
    for i, folder in folders {
        FileCreateDir, %loc%\%folder%
    }
    Explorer_GetWindow().Navigate2(loc . "\" . folders[folders.Length()])
}

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