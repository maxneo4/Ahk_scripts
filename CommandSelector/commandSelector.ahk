InitCommandSelector(configFileParam) {   
	global configFile := configFileParam
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
	
	LoadCommands()
	; add default commands
	FillDefaultCommands() 		
	
	selectFirstRow()
	LV_ModifyCol(1, 185)
	LV_ModifyCol(2, 385)
	LV_ModifyCol(3, 0)
	LV_ModifyCol(4, 0)
	LV_ModifyCol(5, 0)
	LV_ModifyCol(6, 0)
	
	Hotkey, IfWinActive, CommandS		
	Hotkey, ~Enter, invokeCommand, On
	Hotkey, ~Del, Del, On
	Hotkey, ~BackSpace, FocusText, On
	Hotkey, ~Down, Down, On
	Hotkey, ~Up, Up, On
	Hotkey, ~Escape, CommandSelectorHide, On
	Hotkey, If
	
	Hotkey, !Space, ShowCommandSelector, On
	Hotkey, ^!r, ReloadLauncherTools, On
	Hotkey, ^!e, openCommandsConfig, On
	
	GroupAdd, FileListers, ahk_class CabinetWClass
	GroupAdd, FileListers, ahk_class WorkerW
	GroupAdd, FileListers, ahk_class #32770, ShellView
	
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
	Send, ^a
	return
	
	openCommandsConfig:
	global commandsPath
	Run, %commandsPath%
	return
}

LoadCommands(){
	global configFile
	; load json config
	FileRead, jsonContent, %configFile%
	global valueCSjson := JSON.Load( jsonContent )
}

ReloadLauncherTools(){
	showMessage("Reloading commands ...", 1000)	
	LoadCommands()
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
	if InStr(selectedCommand, ".") or InStr(selectedCommand, "`/") or InStr(selectedCommand, "\")
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
	global defaultCommands
	Gui, mw:Default
    ;Gui, Submit, NoHide
	GuiControlGet Search ;get content of control of associate var
	Search := Trim(Search)
	arrayWords := StrSplit(Search, A_Space)
	LV_Delete()
	Loop, % valueCSjson.Commands.MaxIndex()  
	{
		item := valueCSjson.Commands[A_Index]
		FilterItem(item, arrayWords)
	}
	Loop, % defaultCommands.MaxIndex()  
	{
		item := defaultCommands[A_Index]
		FilterItem(item, arrayWords )
	} 
	
	selectFirstRow()    
	return
}

FilterItem(item, arrayWords){
	global Search
	name := item.name       
	category := item.category
	;if  InStr(name, Search) or InStr(category, Search) or (Search = )
	if InStr(category, Search) or ContainsAllWords(name, arrayWords) or (Search = )	
		Add_item(item)	
}


copySelectedFileContentToClipboard(){	
	path := getSmartSelectedFile()
	if path {			
		FileRead, contentFile, %path%
		Clipboard := contentFile		
	}
}

addSelectedItemAsCommand(){
	path := getSmartSelectedItem()
	if(path){
		Clipboard := path
		addClipboardContentAsCommand()
	}
}

addSelectedTextAsCommand(){
	sendSmartCopy()
	addClipboardContentAsCommand()
}

addClipboardContentAsCommand(){
	global valueCSjson
	global commandsPath
	path := Clipboard
	if path
	{
		InputBox, categoryAndName, command to add %path% , Set category and name separated by : , , 500, 140		
		if ErrorLevel 
			ShowFailMessage("You cancel to add command", 1000)
		else
		{
			parts := StrSplit(categoryAndName, ":")		
			if(parts.MaxIndex() = 2)
			{
				category := parts[1]
				name := parts[2]
				if not instr(path, "`\`\") ;avoid to change network folders					
					StringReplace, path, path, `\, /, 1
				valueCSjson.Commands.Push({ category: category, name: name, command: path })
				fullJson := JSON.Dump(valueCSjson,,2)
				FileDelete, %commandsPath%
				FileAppend, %fullJson%, %commandsPath%
				;run, %commandsPath%
				LoadCommands()
			}else{
				showFailMessage("You enter an incorrect format", 1000)
			}			
		}
	}
}

CommandSelectorHide()
{    
    Gui, mw:Hide
    return
}

FillDefaultCommands(){
	global defaultCommands := []
	
	defaultCommands.Push({category: "generate", command: "generateGuidInClipboard", name: "new Guid"})
	defaultCommands.Push({category: "convertCase", command: "toLower", name: "to lower"})
	defaultCommands.Push({category: "convertCase", command: "toUpper", name: "to upper"})
	defaultCommands.Push({category: "copy", command: "copyFileFromFullPath", name: "file from full path"})
	defaultCommands.Push({category: "convertData", command: "listToWhereIn", name: "get 'where in ()' from list"})
	defaultCommands.Push({category: "replace", command: "replaceFileSeparator", name: "change \\ by /"})
	defaultCommands.Push({category: "config", command: "addSelectedItemAsCommand", name: "add selected item as new command"})
	defaultCommands.Push({category: "config", command: "addSelectedTextAsCommand", name: "add selected text as new command"})
	defaultCommands.Push({category: "copy", command: "copySelectedFileContentToClipboard", name: "copy content selected file"})
	defaultCommands.Push({category: "get version", command: "getFileVersion", name: "Get dll/file version"})
	defaultCommands.Push({category: "config", command: "changeLogNotesRememberWorkSpaceFolder", name: "Set current folder as workspace"})
	defaultCommands.Push({category: "config", command: "showCurrentWorkspace", name: "Open workspace"})
	defaultCommands.Push({category: "config", command: "restoreLogNotesRememberWorkSpaceFolder", name: "Set/Restore default workspace"})
	defaultCommands.Push({category: "CMD", command: "openCurrentFolderInCMD", name: "Open current folder in CMD"})
	
	defaultCommands.Push({category: "log notes", command: "addSelectedToLog", name: "log add"})
	defaultCommands.Push({category: "log notes", command: "InputToLog", name: "log input"})
	defaultCommands.Push({category: "log notes", command: "openTodayLog", name: "log open"})
	defaultCommands.Push({category: "log notes", command: "openLogByDate", name: "log open by date"})
	
	defaultCommands.Push({category: "log images", command: "addCaptureToLog", name: "capture screen region"})
	defaultCommands.Push({category: "log images", command: "openCaptureEdit", name: "capture screen edit"})
	defaultCommands.Push({category: "log images", command: "clipboardCaptureToLog", name: "capture from clipboard"})
	defaultCommands.Push({category: "log images", command: "openScreenCaptureLog", name: "capture open folder"})
	defaultCommands.Push({category: "log images", command: "openScreenCaptureByDate", name: "capture open folder by date"})
	
	defaultCommands.Push({category: "remember list", command: "addSelectedTextToList", name: "remember add"})
	defaultCommands.Push({category: "remember list", command: "openRememberList", name: "remember open file"})		
	defaultCommands.Push({category: "global remember list", command: "addSelectedTextToGlobalList", name: "global remember add"})
	defaultCommands.Push({category: "global remember list", command: "openGlobalRememberList", name: "global remember open file"})
	
	defaultCommands.Push({category: "tutorial maker", command: "ChooseEnabledTutorialFolder", name: "enabled/set tutorial maker folder"})
	defaultCommands.Push({category: "tutorial maker", command: "DisableTutorialFolder", name: "disable tutorial maker folder"})
	defaultCommands.Push({category: "tutorial maker", command: "showTutorialFolder", name: "open tutorial maker folder"})
	defaultCommands.Push({category: "tutorial maker", command: "RunTemplate", name: "generate tutorial"})
	defaultCommands.Push({category: "tutorial maker", command: "EditTextImage", name: "edite text of selected image"})
}