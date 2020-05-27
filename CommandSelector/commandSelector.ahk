#include CommandSelector\custom_functions.ahk

InitCommandSelector(configFile) {   
    global Search
    global EditId ;global cause is used in other functions

    static LVID

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
    FileRead, jsonContent, %configFile%
    global valueCSjson := JSON.Load( jsonContent )

    Loop, % valueCSjson.Commands.MaxIndex() {
        item := valueCSjson.Commands[A_Index]
        Add_item(item)
    }
    selectFirstRow()
    LV_ModifyCol(1, 185)
    LV_ModifyCol(2, 385)
    LV_ModifyCol(3, 0)
    LV_ModifyCol(4, 0)
    LV_ModifyCol(5, 0)
    LV_ModifyCol(6, 0)

    ;#IfWinActive, CommandS
    Hotkey, IfWinActive, CommandS
    Hotkey, ~Enter, invokeCommand, On
    Hotkey, ~Del, Del, On
    Hotkey, ~BackSpace, FocusText, On
    Hotkey, ~Down, Down, On
    Hotkey, ~Up, Up, On
    Hotkey, If
    Hotkey, !Space, ShowCommandSelector, On

    Del:   
        GuiControl, ,%EditId% ;clear text box
        FocusText()
    return

    Down:    
        ControlGetFocus, OutVar, CommandS    
        if OutVar contains edit ;retrive edit or similar        
                GuiControl, Focus, %LVID% 
    return
        
    Up:     
        global selectedIndex
        ControlGetFocus, OutVar, CommandS
        if (OutVar contains listView) and (selectedIndex < 2)
            GuiControl, Focus, %EditId%
        return
    
    ShowCommandSelector:
    Gui, mw:Show, autosize xCenter y34, CommandS
    GuiControl, Focus, %editId%
    return
}

Add_item(item) {
    LV_Add("", item.category, item.name, item.command, item.category item.name, item.runAs, item.title)
}

selectFirstRow(){
    LV_ModifyCol(4, "Sort")
    LV_Modify(1, "+Select +Focus")
    return
}

invokeCommand(){    
    Gui, mw:Hide
    global selectedCommand
    if InStr(selectedCommand, ".") or InStr(selectedCommand, "`/")
        RunPathSwitch(selectedCommand, selectedRunAs, selectedTitle)  
    else if selectedCommand
        %selectedCommand%()
    return
}

Get_selected_command_vars(){
    Gui, mw:Default
    global selectedCommand
    global selectedRunAs
    global selectedTitle
    LV_GetText(selectedCommand, A_EventInfo, 3) ; Get the text from the row's third field.  
    LV_GetText(selectedRunAs, A_EventInfo, 5)
    LV_GetText(selectedTitle, A_EventInfo, 6)
}

MyListView() {
    if (A_GuiEvent = "DoubleClick")
    {    
        Get_selected_command_vars()
        invokeCommand()
    }
    else if(A_GuiEvent = "I") ; AltSubmit is necesary option
        {
            ;selectedIndex:= A_EventInfo ; last focused row
            global selectedIndex
            selectedIndex:= LV_GetNext() ; new focused row  
            Get_selected_command_vars()
        }
    return
}

FocusText() {    
    global EditId
    ControlGetFocus, OutVar, CommandS    
    if OutVar not contains edit ;retrive edit or similar
        GuiControl, Focus, %EditId%    
    return
}

Update() {   
    global Search
    global valueCSjson
    Gui, mw:Default
    ;Gui, Submit, NoHide
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
    selectFirstRow()    
    return
}

CommandSelectorHide()
{    
    Gui, mw:Hide
    return
}