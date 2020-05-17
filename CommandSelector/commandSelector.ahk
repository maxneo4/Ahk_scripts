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
Gui, mw:Add, ListView, w600 h400 -Multi gMyListView AltSubmit -Hdr vLV1 HwndLVID, Category|Name|Command|Order|RunAs|Title
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 30, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 30
    
; load json config
FileRead, jsonContent, commands-max.json
value := JSON.Load( jsonContent )

Loop, % value.Commands.MaxIndex() {
    item := value.Commands[A_Index]
    Add_item(item)
}
gosub selectFirstRow
;LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(1, 185)
LV_ModifyCol(2, 385)
LV_ModifyCol(3, 0)
LV_ModifyCol(4, 0)
LV_ModifyCol(5, 0)
LV_ModifyCol(6, 0)

#Include custom_functions.ahk

return

Add_item(item)
{
    LV_Add("", item.category, item.name, item.command, item.category item.name, item.runAs, item.title)
}

selectFirstRow:
    LV_ModifyCol(4, "Sort")
    LV_Modify(1, "+Select +Focus")
return

invokeCommand:
    Gui, mw:Hide   
    if InStr(selectedCommand, ".lnk")
        ActivateOpenShortCut(selectedCommand, selectedRunAs, selectedTitle)
    else if InStr(selectedCommand, ".exe")        
        ActivateOpenExeByTitle(selectedCommand, selectedRunAs, selectedTitle)        
    else if InStr(selectedCommand, ".") or InStr(selectedCommand, "`/")
        Run, %selectedCommand%    
    else if selectedCommand
        gosub %selectedCommand%  
return

Get_selected_command_vars:
    LV_GetText(selectedCommand, A_EventInfo, 3) ; Get the text from the row's third field.  
    LV_GetText(selectedRunAs, A_EventInfo, 5)
    LV_GetText(selectedTitle, A_EventInfo, 6)
return

MyListView:
if (A_GuiEvent = "DoubleClick")
{    
    gosub Get_selected_command_vars
    gosub invokeCommand
}
else if(A_GuiEvent = "I") ; AltSubmit is necesary option
    {
        ;selectedIndex:= A_EventInfo ; last focused row
        selectedIndex:= LV_GetNext() ; new focused row  
        gosub Get_selected_command_vars
    }
return

FocusText:
    IfWinActive, CommandS
    {
        ControlGetFocus, OutVar, CommandS    
        if OutVar not contains edit ;retrive edit or similar
            GuiControl, Focus, %editId%
    }    
return

~Enter::
IfWinActive, CommandS    
    gosub invokeCommand
return

~Del::
    IfWinActive, CommandS
        GuiControl, ,%EditId% ;clear text box
    gosub FocusText
return

~BackSpace::
    gosub FocusText
return

~Down::    
    ControlGetFocus, OutVar, CommandS    
    if OutVar contains edit ;retrive edit or similar        
            GuiControl, Focus, %LVID% 
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
        if  InStr(name, Search) or InStr(category, Search) or (Search = )
            Add_item(item)
    }    
    gosub selectFirstRow
    return

^?::
!Space::
Gui, mw:Show, autosize xCenter y34, CommandS
GuiControl, Focus, %editId%
return

~Escape::
Gui, mw:Hide
return