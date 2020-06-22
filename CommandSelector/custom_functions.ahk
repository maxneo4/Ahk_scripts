DoubleKey(key){
	if(A_PriorHotkey != "~" . key or A_TimeSincePriorHotkey > 400)
	{
		KeyWait, %key%
		return false
	}
	return true
}

ObjIndexOf(obj, item, case_sensitive:=false)
{
	for i, val in obj {
		if (case_sensitive ? (val == item) : (val = item))
			return i
	}
}

showText(title, text, milis_time, width=300, height=60)
{	
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
	}else{
		Send ^c
		ClipWait 1
		if ErrorLevel
			showFailMessage("Error...",1000)
		Sleep, 100
	}
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

getFileInfo(){
	filePath := getSmartSelectedFile()	
	FileGetTime, dateModified, filePath, M
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