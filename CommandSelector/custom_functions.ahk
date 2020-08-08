DynamicInputBox(title, guiDefinitions){
	static
	inputResult = 
	GuiID = dynForm

	global dynTitle := title

	width := guiDefinitions.width	
	margin := guiDefinitions.Margin
	vspace := guiDefinitions.vspace
	vminspace := vspace / 2
	controls := guiDefinitions.controls

	global helps := {}
	
	Gui, %GuiID%: +AlwaysOnTop HwnddynFormId -Caption
	Gui, %GuiID%:Margin, %margin%, %margin%

	Gui, help:New, AlwaysOnTop ToolWindow -DPIScale -Caption	
	Gui, Font, s10 Arial cA9A9A7
	Gui, help:Color, EEAA99, 282923
	Gui +LastFound 
	WinSet, TransColor, EEAA99
	Gui, help:Add, ListView, w400 h200 x0 y15 -Multi gListEvent AltSubmit -Hdr vListViewResult HwndLVID, text 
	LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int, 20, Int,0x18, Int,1, Int,1 ), 1 ) ;set row height to 25
	

	controlsCount := controls.MaxIndex()
	ypos := 0
	Loop, %controlsCount%
	{		
		control := controls[A_Index]
		text := control.name
		type = Edit
		values := 
		if(control.type)
		{
			type := control.type
			values := control.values
		}
		varName := "var" . A_Index
		value := control.value
		options := control.options
		helps[varName] := control.help

		Gui, %GuiID%:Add, Text, y%ypos% x%margin% w%width%, %text%
		ypos += vminspace
		if(type = "UpDown")
			Gui, %GuiID%:Add, Edit
		Gui, %GuiID%:Add, %type%, y%ypos% x%margin% v%varName% w%width% %options% gEditChangeEvent, %value%
		ypos += vspace	
	}
	
	yButton := controlsCount * 1.5 * vspace
	Gui, %GuiID%:Add, Button, y%yButton%  gCInputButton Default, % "OK"
	Gui, %GuiID%:Add, Button, y%ybutton%  gCCancelButton, % "Cancel"
	

	Gui %GuiID%:Show,,%title%
	Gui, %GuiID%:Default

	Loop, %controlsCount%
	{		
		control := controls[A_Index]
		varName := "var" . A_Index
		if(control.state)
		{	
			state := control.state
			switch % control.type
			{
				case "Edit", "CheckBox", "UpDown", "Slider": 
					GuiControl,, %varName% , %state%
				case "ComboBox", "ListBox", "DropDownList": 
					GuiControl, ChooseString, %varName%, %state%
			}			
		}
	}

	Loop
		If( inputResult )
			Break

	Result := inputResult
	inputResult := 
	Gui, %GuiID%:Submit, Hide
	Gui %GuiID%:Destroy 
	if Result = "Out"
	{
		Result := {}
		Loop, %controlsCount%
		{
			text := controls[A_Index].name
			varName := "var" . A_Index
			value := %varName%
			Result[text] := value 
		}
	}
  	Return Result

  	CInputButton:  	 
  	 inputResult = "Out"
  	return

  	CCancelButton:
  	dynFormGuiEscape:
	dynFormGuiClose:	
	  inputResult = "Canceled"
	Return
}

EditChangeEvent(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	global helps 
	global dynTitle

	controlDef := A_GuiControl
	help := helps[controlDef]

	if(help)
	{
		GuiControlGet, Search,, %CtrlHwnd% 
		Search := Trim(Search)
		arrayWords := StrSplit(Search, A_Space)
		
		Gui, help:Default
		LV_Delete()

		Loop, Read, %help%
		{	
			line := A_LoopReadLine
			if(ContainsAllWords(line, arrayWords) or Search = "")			
				LV_Add("", line) ;fisrt tags, second value
		}

		CoordMode, Caret, Screen
		Gui, +OwnerdynForm ;+Owner{OtherGui}

		IfWinNotExist, dynamicHelp
		{
			Gui, show, AutoSize x%A_CaretX% y%A_CaretY% , dynamicHelp
			WinActivate, %dynTitle%
		}		
	}
}

ListEvent(){

}

ContainsAllWords(value, arrayWords){	
	maxIndex := arrayWords.MaxIndex()
	matches = 0
	
	Loop, % arrayWords.maxIndex()
	{
		word := arrayWords[A_Index]
		if InStr(value, word)
			matches += 1
	}
	if(matches = maxIndex)
		return true
	else
		return false
}

openCurrentFolderInCMD(){
	currdir := getSmartCurrentFolder()
	Run, cmd, % currdir ? currdir : "C:\"
}

DoubleKey(key){
	if(A_PriorHotkey != "~" . key or A_TimeSincePriorHotkey > 400)
	{
		KeyWait, %key%
		return false
	}
	return true
}

ObjIndexOf(obj, item, case_sensitive:=false){
	for i, val in obj {
		if (case_sensitive ? (val == item) : (val = item))
			return i
	}
	return 0
}

showText(title, text, milis_time, width=300, height=60){	
	SplashTextOn,  width , height, %title%, %text%
	Sleep, milis_time
	SplashTextOff
}

showProgress(message, width=300, height=28)
{
	Progress, B1 W%width% H%height% ZH0 FS11 WS900 Y400 CT0000FF, %message%
}

showMessage(message, time)
{
	Progress, B1 W300 H28 ZH0 FS11 WS900 Y400 CT0000FF, %message%
	SetTimer, OSD_OFF, -%time%
}

showFailMessage(message, time)
{
	Progress, B1 W350 H28 ZH0 FS11 WS900 Y400 CTFF0000, %message%
	SetTimer, OSD_OFF, -%time%
}

OSD_OFF(){
	Progress, off
	return
}

replaceFileSeparator() {
   path :=  sendSmartCopy()
   StringReplace, path, path, `\, /, 1   
   Clipboard :=  path
   Sleep, 100
   Send ^v
   return
}

sendSmartCopy(){
	lastClipboard :=
	if(Clipboard)
	{		
		lastClipboard := Clipboard
		Clipboard :=
	}
	
	Send ^c
	ClipWait 1
	if ErrorLevel
		showFailMessage("Error...",1000)
	Sleep, 100
	
	if  Clipboard = 
	{
		if(lastClipboard)
		{
			Clipboard := lastClipboard
			showMessage("Taken from previous clipboard", 1000)
		}
		else
			showFailMessage("There is'nt clipboard content",2000)
	}
}

getSmartSelectedFile(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	if path 
		filePath := path
	else	if InStr(FileExist(Clipboard), "A")
		filePath := Clipboard
	return filePath
}

getSmartSelectedItem(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	if path 
		itemPath := path
	else	if FileExist(Clipboard)
		itemPath := Clipboard
	return itemPath
}

getSmartCurrentFolder(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetPath()
	if path 
		folderPath := path
	else if InStr(FileExist(folderPath), "D")
		folderPath := Clipboard
	return folderPath
}

RemoveBreakLinesAndTrimClipboard(){	
	;Clipboard := RegExReplace(Clipboard, "`am)^[\s\R]*") ;remove al empty lines if is useful to another flow tool
	Clipboard := Trim(Clipboard, "`r`n")
	Clipboard := Trim(Clipboard)
}

listToWhereIn(){
 sendSmartCopy()
 joined := ""
 Loop, Parse, clipboard, `r`n
   if A_loopfield
      joined .= "'" A_loopfield "'," 
 Clipboard := joined
 return
}

copyFileFromFullPath(){
   sendSmartCopy()
   fullPath := Clipboard
   InvokeVerb(fullPath, "Copy")
   return
}

generateGuidInClipboard(){
   TypeLib := ComObjCreate("Scriptlet.TypeLib")
   NewGUID := TypeLib.Guid
   NewGUID := RegExReplace(NewGUID, "[{}]")
   StringLower, NewGUID, NewGuid
   Clipboard := NewGuid
   Sleep, 100
   Send ^v
   return
}

toLower(){
 sendSmartCopy()
 StringLower, Clipboard, Clipboard
   return
}

toUpper(){
 sendSmartCopy()
 StringUpper, Clipboard, Clipboard
 return
}

getFileVersion(){
	filePath := getSmartSelectedFile()		
	f := FileGetVersionInfo_AW(filePath, "ProductVersion", "FileVersion")
	pv := f.productVersion 
	fv := f.fileVersion
	Clipboard = product version: %pv% `nfile version:%fv%
	MsgBox,,, % Clipboard
	return
}
	
	RunPathSwitch(path, runAs, title) {   
		if title   
			RunByTitle(path, runAs, title)
		else
			RunPath(path, runAs)   
		return
	}
	
	RunPath(path, RunAs) {
		if runAs
			Run *RunAs "%path%"
		else
			run, %path%    
		return
	}
	
	RunByTitle(path, runAs, title) {       
		SetTitleMatchMode, 2 ;to search window title by contains, not by prefix only
		IfWinExist %title%
			WinActivate %title%     
		else  
			RunPath(path, runAs)    
		return
	}
	
	InvokeVerb(path, menu, validate=True) {
	;by A_Samurai
	;v 1.0.1 http://sites.google.com/site/ahkref/custom-functions/invokeverb
		objShell := ComObjCreate("Shell.Application")
		if InStr(FileExist(path), "D") || InStr(path, "::{") {
			objFolder := objShell.NameSpace(path)   
			objFolderItem := objFolder.Self
		} else {
			SplitPath, path, name, dir
			objFolder := objShell.NameSpace(dir)
			objFolderItem := objFolder.ParseName(name)
		}
		if validate {
			colVerbs := objFolderItem.Verbs   
			loop % colVerbs.Count {
				verb := colVerbs.Item(A_Index - 1)
				retMenu := verb.name
				StringReplace, retMenu, retMenu, &       
				if (retMenu = menu) {
					verb.DoIt
					Return True
				}
			}
			Return False
		} else
			objFolderItem.InvokeVerbEx(Menu)
		return
	}
	
	FileGetVersionInfo_AW( peFile="", params*) {	; Written by SKAN
	; www.autohotkey.com/forum/viewtopic.php?p=233188#233188  CD:24-Nov-2008 / LM:27-Oct-2010
		Static	CS, HexVal, Sps="                        ", DLL="Version\", StrGet="StrGet"
		If	!CS
			CS :=	A_IsUnicode ? "W" : "A", HexVal :=	"msvcrt\s" (A_IsUnicode ? "w": "" ) "printf"
		
		If	!FSz :=	DllCall( DLL "GetFileVersionInfoSize" CS , Str,peFile, UInt,0 )
			Return	"", DllCall( "SetLastError", UInt,1 )
		
		VarSetCapacity( FVI, FSz, 0 ), VarSetCapacity( Trans,8 * ( A_IsUnicode ? 2 : 1 ) )
		DllCall( DLL "GetFileVersionInfo" CS, Str,peFile, Int,0, UInt,FSz, UInt,&FVI )
		If	!DllCall( DLL "VerQueryValue" CS, UInt,&FVI, Str,"\VarFileInfo\Translation", UIntP,Translation, UInt,0 )
			Return	"", DllCall( "SetLastError", UInt,2 )
		
		If	!DllCall( HexVal, Str,Trans, Str,"%08X", UInt,NumGet(Translation+0) )
			Return	"", DllCall( "SetLastError", UInt,3 )
		res :=	{}
		For each, attr in params
		{
			subBlock :=	"\StringFileInfo\" SubStr(Trans,-3) SubStr(Trans,1,4) "\" attr
			If	!DllCall( DLL "VerQueryValue" CS, UInt,&FVI, Str,SubBlock, UIntP,InfoPtr, UInt,0 )
				Continue
			
			if	Value :=	( A_IsUnicode ? %StrGet%( InfoPtr, DllCall( "lstrlen" CS, UInt,InfoPtr ) )
		 :  DllCall( "MulDiv", UInt,InfoPtr, Int,1, Int,1, "Str"  ) )
				res.Insert(attr,Value)
		}
		Return	res
	}