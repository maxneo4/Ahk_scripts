;https://www.autohotkey.com/docs/Hotstrings.htm#EndChars

:*b0:<em>::</em>{left 5}
:X:_mb::MsgBox



:*O:reb`t::\\dev-edwinbtmp\
:*O:rorcl`t::\\dev-oracle122\
:*O:rorcll`t::\\orcl-12-2-w1252\
:*O:rbs`t::\\biz-studio\
:*O:baorcl`t::User Id=BizagiAdmon;Password=bizagi;Data Source=dev-oracle122:1521/orcl
:*O:baorcll`t::User Id=BizagiAdmon;Password=bizagi;Data Source=orcl-12-2-w1252:1521/orcl

:*:vcat::VWBA_CATALOG_BABIZAGICATALOG
:*:vcaa::VWBA_CATALOG_BABIZAGICAT_ALL
:*:tcat::BABIZAGICATALOG
:*:wgi::where guidObject in(){left 1}
::btc::fnBA_DB_ClobToBlob
::ctb::fnBA_DB_BlobToClob
:?*:obj`t::object
:*O:th`t::Thank you

^Del::
SendInput ^a
SendInput {Delete}
return

!Del::
SendInput +{Home}
SendInput {Delete}
return

replaceFileSeparator:
   path :=  clipboard
   StringReplace, path, path, `\, /, 1   
   Clipboard :=  path
   Sleep, 100
   Send ^v
return

sendCopy:
   Sleep, 100
   Send ^c
   ClipWait 1
   if ErrorLevel  ; ClipWait timed out.
    return
   Sleep, 100
return

listToWhereIn: 
 gosub sendCopy
 joined := ""
 Loop, Parse, clipboard, `r`n
   if A_loopfield
      joined .= "'" A_loopfield "'," 
 Clipboard := joined
return

copyFileFromFullPath:
   gosub sendCopy
   fullPath := Clipboard
   InvokeVerb(fullPath, "Copy")
return

generateGuidInClipboard:
   TypeLib := ComObjCreate("Scriptlet.TypeLib")
   NewGUID := TypeLib.Guid
   NewGUID := RegExReplace(NewGUID, "[{}]")
   StringLower, NewGUID, NewGuid
   Clipboard := NewGuid
   Sleep, 100
   Send ^v
return

toLower:
 gosub sendCopy
 StringLower, Clipboard, Clipboard
return

toUpper:
 gosub sendCopy
 StringUpper, Clipboard, Clipboard
return

ActivateOpenShortCut(shortCut, runAs, selectedTitle)
{       
    FileGetShortcut, %shortCut%, exePath
    ActivateOpenExe(exePath, runAs, selectedTitle)
}

ActivateOpenExe(exePath, runAs, selectedTitle)
{   
   if selectedTitle
   {
      ActivateOpenExeByTitle(exePath, runAs, selectedTitle)
      return
   }
    SplitPath, exePath, exeName
    IfWinExist ahk_exe %exeName%
       WinActivate ahk_exe %exeName%        
    else        
    {      
      if runAs
        Run *RunAs "%exePath%"
      else
        run, %exePath%
     WinWait ahk_exe %exeName%
     WinActivate ahk_exe %exeName%
    }
   return
}

ActivateOpenExeByTitle(exePath, runAs, title)
{       
    IfWinExist %title%
       WinActivate     
    else        
    {      
      if runAs
        Run *RunAs "%exePath%"
      else
        run, %exePath%
     WinWait %title%
     WinActivate
    }
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


 FileToClipboard(PathToCopy,Method="copy")
   {
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