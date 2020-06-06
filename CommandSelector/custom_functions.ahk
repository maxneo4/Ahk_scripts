copySelectedFileContentToClipboard(){
	GroupAdd, FileListers, ahk_class CabinetWClass
	GroupAdd, FileListers, ahk_class WorkerW
	GroupAdd, FileListers, ahk_class #32770, ShellView
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	if path {		
		if InStr(FileExist(path), "A")
		{
			FileRead, contentFile, %path%
			Clipboard := contentFile
		}
	}
}

addSelectedFileAsCommand(){		
	GroupAdd, FileListers, ahk_class CabinetWClass
	GroupAdd, FileListers, ahk_class WorkerW
	GroupAdd, FileListers, ahk_class #32770, ShellView
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	Clipboard := path
	addClipboardContentAsCommand()
}

addSelectedTextAsCommand(){
	sendCopy()
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
				Reload 
			}else{
				showFailMessage("You enter an incorrect format", 1000)
			}			
		}
	}
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
   path :=  clipboard
   StringReplace, path, path, `\, /, 1   
   Clipboard :=  path
   Sleep, 100
   Send ^v
   return
}

sendLiteCopy(){
	Clipboard :=
	Send ^c
	ClipWait 1
	if ErrorLevel  ; ClipWait timed out.
		return	
}

sendCopy(){
   Sleep, 100
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
   Sleep, 100
   return
}

RemoveBreakLinesAndTrimClipboard(){	
	;Clipboard := RegExReplace(Clipboard, "`am)^[\s\R]*") ;remove al empty lines if is useful to another flow tool
	Clipboard := Trim(Clipboard, "`r`n")
	Clipboard := Trim(Clipboard)
}

listToWhereIn(){
 sendCopy()
 joined := ""
 Loop, Parse, clipboard, `r`n
   if A_loopfield
      joined .= "'" A_loopfield "'," 
 Clipboard := joined
 return
}

copyFileFromFullPath(){
   sendCopy()
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
 sendCopy()
 StringLower, Clipboard, Clipboard
   return
}

toUpper(){
 sendCopy()
 StringUpper, Clipboard, Clipboard
 return
}

getFileInfo(){
  f := FileGetVersionInfo_AW(Clipboard, "ProductVersion", "FileVersion")
  pv := f.productVersion 
  fv := f.fileVersion
  Clipboard = %pv% %fv%
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

 FileToClipboard(PathToCopy,Method="copy") {
   FileCount:=0
   PathLength:=0

   ; Count files and total string length
   Loop,Parse,PathToCopy,`n,`r
      {
      FileCount++
      PathLength+=StrLen(A_LoopField)
      }

   pid:=DllCall("GetCurrentProcessId","uint")
   hwnd:=WinExist("ahk_pid " . pid)
   ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
   hPath := DllCall("GlobalAlloc","uint",0x42,"uint",20 + (PathLength + FileCount + 1) * 2,"UPtr")
   pPath := DllCall("GlobalLock","UPtr",hPath)
   NumPut(20,pPath+0),pPath += 16 ; DROPFILES.pFiles = offset of file list
   NumPut(1,pPath+0),pPath += 4 ; fWide = 0 -->ANSI,fWide = 1 -->Unicode
   Offset:=0
   Loop,Parse,PathToCopy,`n,`r ; Rows are delimited by linefeeds (`r`n).
      offset += StrPut(A_LoopField,pPath+offset,StrLen(A_LoopField)+1,"UTF-16") * 2

   DllCall("GlobalUnlock","UPtr",hPath)
   DllCall("OpenClipboard","UPtr",hwnd)
   DllCall("EmptyClipboard")
   DllCall("SetClipboardData","uint",0xF,"UPtr",hPath) ; 0xF = CF_HDROP

   ; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
   ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
   mem := DllCall("GlobalAlloc","uint",0x42,"uint",4,"UPtr")
   str := DllCall("GlobalLock","UPtr",mem)

   if (Method="copy")
      DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x05)
   else if (Method="cut")
      DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x02)
   else
      {
      DllCall("CloseClipboard")
      return
      }

   DllCall("GlobalUnlock","UPtr",mem)

   cfFormat := DllCall("RegisterClipboardFormat","Str","Preferred DropEffect")
   DllCall("SetClipboardData","uint",cfFormat,"UPtr",mem)
   DllCall("CloseClipboard")
   return
}