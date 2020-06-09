#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; + shift, ^ ctrl, # windows, ! alt

#SingleInstance Force

SetWorkingDir C:\git\Ahk_scripts

#Include  ..\CommandSelector\custom_functions.ahk

;FileCopy, C:\git\Ahk_scripts\CaptureImagesTutorialMaker\Word template.docx, C:\Users\max\Documents\Zoom

MakeFastTutorialInit()

MakeFastTutorialInit()
{
	global capture
	global Folder
	
	Capture = false
	Folder = %A_ScriptDir%	
	
	Hotkey, ^!c, ChooseFolder, On
	Hotkey, LWin, Capture, On
	Hotkey, ^r, RunTemplate, On
}

ChooseFolder(){
	global capture
	global Folder
	
	if(%capture% == true){
		capture = false
		Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, Capture was disabled
		SetTimer, OSD_OFF, -2000
		Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -openImagesFolder true -folderTarget %Folder%
	}else {
		capture = true
		FileSelectFolder, Folder, *%Folder%
		if (Folder = "")
			Folder = %A_ScriptDir%	
		MsgBox, 64, Capture images, 
		(
		- Use [LWin] to take screenshoot
		- Use [CTRL+E] to edit json config
		- Use [CTRL+R] to view docx tutorial
		Capture enabled in folder "%Folder%" 
		), 5
	}
}

Capture(){
	global capture	
	
	if(%capture% == false)
	{
		SendInput, {LWin}
		Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, Capture is disabled
		SetTimer, OSD_OFF, -2000
	}else
		InvokeCapture()
}

InvokeCapture(){		
	global Folder
	
	Clipboard = ;
	Sleep, 150
	SendInput, #+s	
	Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -secondsToWait 20 -folderTarget %Folder%
	
}

RunTemplate(){
	global capture
	global Folder
	
	if(%capture% == true){
		FileCopy, %A_ScriptDir%\Word template.docx, %Folder%, 1
		if ErrorLevel
			MsgBox,,, %ErrorLevel%
		
		ShowProgress("initializing word...")
		
		oWord := ComObjCreate("Word.Application")
		wordFile := % Folder . "\Word template.docx"
		
		ShowProgress(wordFile, 400)
		
		oWord.Documents.Add(wordFile)
		
		
		oWord.Selection.TypeParagraph
		oWord.Selection.Font.Size := 32
		oWord.Selection.TypeText("Tutorial")
		oWord.Selection.TypeParagraph		
		
		
		Loop Files, %Folder%\web\images\*.png
		{
			ShowProgress("adding " . A_LoopFileFullPath, 550
			)
			oWord.Selection.TypeParagraph
			oWord.Selection.Font.Size := 24
			step := % "Step " . A_Index
			oWord.Selection.TypeText(step)
			oWord.Selection.TypeParagraph
			oWord.Selection.InlineShapes.AddPicture(A_LoopFileFullPath,0,1)
			oWord.Selection.TypeParagraph				
		}
		OSD_OFF()
		oWord.Visible := True
		oWord.Activate
		
		
		
		;oWord.ActiveDocument.Save()
		
		;Run, %Folder%\Word template.docx 
		
		;Run, "%A_ScriptDir%\SaveImageFromClipboard.exe" -runHtmlPage true -folderTarget %Folder%
	}
}