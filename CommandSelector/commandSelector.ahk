
InitCommandSelector()

#include CommandSelector\custom_functions.ahk

return

InitCommandSelector() {   
    Gui, mw:New, AlwaysOnTop ToolWindow -DPIScale -Caption
    Gui, Font, s18 Arial cA9A9A7
    Gui, mw:Add, Edit, w600 vSearch gUpdate HwndEditId ;h35
    Gui, Font, s12 Arial cA9A9A7

    Gui, mw:Color, EEAA99, 282923
    Gui +LastFound 
    WinSet, TransColor, EEAA99

    static ListViewCommandSelector

    ; Create the ListView with two columns, Name and Size:
    Gui, mw:Add, ListView, w600 h400 -Multi gMyListView AltSubmit -Hdr vListViewCommandSelector HwndLVID, Category|Name|Command|Order|RunAs|Title
    LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 30, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 30
        
    ; load json config
    FileRead, jsonContent, CommandSelector\commands-max.json
    global valueCSjson := JSON.Load( jsonContent )

    Loop, % valueCSjson.Commands.MaxIndex() {
        item := valueCSjson.Commands[A_Index]
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
}

Add_item(item) {
    LV_Add("", item.category, item.name, item.command, item.category item.name, item.runAs, item.title)
}

selectFirstRow:
    LV_ModifyCol(4, "Sort")
    LV_Modify(1, "+Select +Focus")
return

invokeCommand:
    Gui, mw:Hide          
    if InStr(selectedCommand, ".") or InStr(selectedCommand, "`/")
        RunPathSwitch(selectedCommand, selectedRunAs, selectedTitle)  
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
    Gui, mw:Default
    GuiControlGet Search ;get content of control of associate var
    LV_Delete()
    Loop, % valueCSjson.Commands.MaxIndex()  
    {
        item := valueCSjson.Commands[A_Index]
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