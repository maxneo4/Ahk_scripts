#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;MsgBox, %A_AhkVersion%
; + shift, ^ ctrl, # windows, ! alt, ~ continua el evento [Alt+126]

#SingleInstance,Force
#Include json.ahk

FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\My AHK Script.lnk, %A_ScriptDir%

Gui, mw:New, AlwaysOnTop ToolWindow -DPIScale -Caption
Gui, Font, s18 Arial cA9A9A7
Gui, mw:Add, Edit, w600 vSearch gUpdate HwndEditId ;h35
Gui, Font, s12 Arial cA9A9A7

Gui, mw:Color, EEAA99, 282923
Gui +LastFound 
WinSet, TransColor, EEAA99

; Create the ListView with two columns, Name and Size:
Gui, mw:Add, ListView, w600 h400 -Multi gMyListView AltSubmit -Hdr vLV1 HwndLVID, Category|Name|Command|Order
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 30, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 30
    
; load json config
FileRead, jsonContent, commands.json
value := JSON.Load( jsonContent )

Loop, % value.Commands.MaxIndex() {
    item := value.Commands[A_Index]
    LV_Add("", item.category, item.name, item.command, item.category item.name)
}
gosub selectFirstRow
;LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(1, 185)
LV_ModifyCol(2, 385)
LV_ModifyCol(3, 0)
LV_ModifyCol(4, 0)

#Include custom_functions.ahk

return

selectFirstRow:
    LV_ModifyCol(4, "Sort")
    LV_Modify(1, "+Select +Focus")
return

invokeCommand:
    Gui, mw:Hide   
    if InStr(selectedCommand, ".")
        Run, %selectedCommand%
    else if InStr(selectedCommand, "`/")
        Run, %selectedCommand%
    else if selectedCommand
        gosub %selectedCommand%  
return

MyListView:
if (A_GuiEvent = "DoubleClick")
{    
    LV_GetText(selectedCommand, A_EventInfo, 3) ; Get the text from the row's first field.    
    gosub invokeCommand
}
else if(A_GuiEvent = "I") ; AltSubmit is necesary option
    {
        ;selectedIndex:= A_EventInfo ; last focused row
        selectedIndex:= LV_GetNext() ; new focused row  
        LV_GetText(selectedCommand, selectedIndex, 3)
    }
return

~Enter::
IfWinActive, CommandS    
    gosub invokeCommand
return

~Del & BackSpace::
~+Del::
^Del::
+BackSpace::
^D::
    ControlGetFocus, OutVar, CommandS    
    if OutVar contains edit ;retrive edit or similar        
        GuiControl, ,%EditId% ;clear text box
return

~Del::
    ControlGetFocus, OutVar, CommandS    
    if OutVar contains edit ;retrive edit or similar        
        GuiControl, ,%EditId% ;clear text box
return

~Down::    
    ControlGetFocus, OutVar, CommandS    
    if OutVar contains edit ;retrive edit or similar        
            GuiControl, Focus, %LVID%        
    ;else ;necesary to avoid jump one row more
     ;   SendInput {Down} 
return
    
~Up::       
    ControlGetFocus, OutVar, CommandS
    if (OutVar contains listView) and (selectedIndex < 2)
        GuiControl, Focus, %EditId%
	return

Update:
    GuiControlGet Search ;get content of control of associate var
    LV_Delete()
    Loop, % value.Commands.MaxIndex()  
    {
        item := value.Commands[A_Index]
        name := item.name       
        category := item.category
        if name contains %Search% 
            LV_Add("", item.category, item.name, item.command, item.category item.name)
        else if category contains %Search% 
            LV_Add("", item.category, item.name, item.command, item.category item.name)
        else if Search = 
            LV_Add("", item.category, item.name, item.command, item.category item.name)
    }    
    gosub selectFirstRow
    return

^?::
!Space::
Space & a::
Space & p::
Gui, mw:Show, autosize xCenter y34, CommandS
GuiControl, Focus, %editId%
return

Space::Send {Space}

~Escape::
Gui, mw:Hide
return