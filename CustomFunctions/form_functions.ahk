DynamicInputBox(guiDefinitions){
	static
	inputResult = 
	global helps := {}
	global helpPaths := {}
	global lists := {}
	title := guiDefinitions.title
	storeFileIni := guiDefinitions.storeFileIni
	width := guiDefinitions.width	
	margin := guiDefinitions.margin
	vspace := guiDefinitions.vspace
	vminspace := vspace / 2
	controls := guiDefinitions.controls
	controlsCount := controls.MaxIndex()
	ypos := 0

	Gui, dynForm:Default	
	Gui, +AlwaysOnTop ToolWindow 
	Gui, Margin, %margin%, %margin%

	Loop, %controlsCount%
	{		
		control := controls[A_Index]
		text := control.name
		type = Edit
		values := 		
		varName := "var" . A_Index
		value := control.value
		options := control.options
		helpPath := control.help
		if(helpPath)
		{
			FileRead, helpContent, %helpPath%		
			helpContent := StrSplit(helpContent, "`r`n")
			helpPaths[varName] := helpPath
			helps[varName] := helpContent
		}		

		if(control.type)
		{
			type := control.type
			values := control.values
		}Else
			control["type"] := "Edit"

		if(type != "CheckBox")
			Gui, Add, Text, y%ypos% x%margin% w%width%, %text%
		Else
			value := text

		if(type = "ComboBox")
		{			
			value := parseHelp(helpContent)
			lists[varName] := value		
		}

		ypos += vminspace

		if(type = "UpDown")
			Gui, Add, Edit
		Gui, Add, %type%, y%ypos% x%margin% v%varName% w%width% %options% gEditChangeEvent, %value%
		ypos += vspace	
	}
	
	yButton := controlsCount * 1.5 * vspace
	Gui, Add, Button, y%yButton%  gCInputButton Default, % "OK"
	Gui, Add, Button, y%ybutton%  gCCancelButton, % "Cancel"
	
	Gui Show,,%title%

	if(storeFileIni)
	{
		storedData := {}
		loop, Read, %storeFileIni%
		{
			pair := StrSplit(A_LoopReadLine, "=")
			key := pair[1]
			storedData[key] := pair[2]
		}		
	}	

	editNumber := 0
	Loop, %controlsCount%
	{		
		control := controls[A_Index]
		varName := "var" . A_Index
		controlName := control.name	
		controlType := control.type
		storedValue := storedData[controlName]	 
		state := (storedValue)? storedValue: control.state
				
		if controlType in Edit,ComboBox,UpDown
			editNumber := editNumber + 1

		if(state)
		{						
			switch % controlType
			{
				case "CheckBox", "UpDown", "Slider": 
					GuiControl, , %varName% , %state%
				case "Edit", "ComboBox":
						ControlSetText, Edit%EditNumber%, %state%, %title%
				case "DropDownList", "ListBox": 
					GuiControl, ChooseString, %varName%, %state%
			}			
		}
	}	

	Hotkey, IfWinExist, %title%
	Hotkey, ^Space, openDropDown, On
	HotKey, ^E, editHelp, On
	Hotkey, if

	Loop
		If( inputResult )
			Break

	Result := inputResult
	inputResult := 
	Gui, Submit, Hide
	Gui Destroy 
	if Result = Out
	{
		Result := {}
		Loop, %controlsCount%
		{
			controlName := controls[A_Index].name
			varName := "var" . A_Index
			value := %varName%
			Result[controlName] := value
			storedData[controlName] := value
		}
		if(storeFileIni)
		{
			FileDelete, %storeFileIni%
			For key, value in storedData
    			FileAppend, %key%=%value%`r`n, %storeFileIni%
		}
	}
  	Return Result

  	CInputButton:  	 
  	 inputResult = Out
  	return

  	CCancelButton:
  	dynFormGuiEscape:
	dynFormGuiClose:	
	  inputResult = Canceled
	Return
}

parseHelp(arrayHelpContent, arrayWords = "", Search = ""){
	result := ""
	Loop, % arrayHelpContent.MaxIndex()
	{	
		line := arrayHelpContent[A_Index]
		if(ContainsAllWords(line, arrayWords) or Search = "")			
			result := result . "|" . line 
	}
	return SubStr(result, 2)
}

openDropDown(){
	global currentHwnd
	Control ShowDropDown,,, ahk_id %currentHwnd%
}

editHelp(){
	global helpPaths
	global controlDef
	helpPath := helpPaths[controlDef]
	if !FileExist(helpPath)
		FileAppend, , %helpPath%
	Run Edit %helpPath%
}

EditChangeEvent(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	global helps 
	global lists
	global currentHwnd := CtrlHwnd
		
	global controlDef := A_GuiControl	
	helpContent := helps[controlDef]
	list := lists[controlDef]
	
	if(helpContent)
	{				
		GuiControlGet, Search,, %CtrlHwnd% 
		
		if(selectedText)
			MsgBox, , Title, % SelectedText
				
		listByComma := StrReplace(list, "|", ",")
		if Search not in %listByComma%
		{		
			;Control ShowDropDown,,, ahk_id %CtrlHwnd%
			Search := Trim(Search)
			arrayWords := StrSplit(Search, A_Space)
							
			listItems := StrSplit(list, "|")		
			Loop, % listItems.MaxIndex()
				Control, Delete, 1,, % "ahk_id " . CtrlHwnd 

			newValue := parseHelp(helpContent, arrayWords, Search)
			GuiControl, , %CtrlHwnd%, %newValue%
			lists[controlDef] := newValue
			if !InStr(newValue, "|")
				SendInput, {Down}

			if(StrLen(Search) > 3 && newValue)			
				Control ShowDropDown,,, ahk_id %CtrlHwnd%
		}
	}
}