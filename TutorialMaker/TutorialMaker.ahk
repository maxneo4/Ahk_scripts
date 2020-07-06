﻿InitTutorialMaker(){
	global capture = "OFF"
	global tutorialFolder	
	
	Hotkey, ^!c, ChooseEnabledTutorialFolder, On
	Hotkey, ^!d, DisableTutorialFolder, On
	
	global fnCaptureEnabled := Func("CaptureEnabled")	
	Hotkey, If, % fnCaptureEnabled
	
	Hotkey, #s, InvokeTutorialCapture, On
	Hotkey, #e, openCaptureEdit, On
	Hotkey, #c, ClipboardTutorialCapture, On
	Hotkey, #o, showTutorialFolder, On
	Hotkey, #r, RunTemplate, On
	
	Hotkey, #t, EditTextImage, On
	
	Hotkey, if	
}
;enable tutorial maker mode
CaptureEnabled()
{
	global capture
	if capture = "ON"
		return true
	else 
		return false
}

;disable tutorial maker mode
DisableTutorialFolder(){
	global capture
	capture = "OFF"
	showFailMessage("Tutorial capture was disabled",1000)
}

ChooseEnabledTutorialFolder(){		
	global tutorialFolder
	global capture
	
	newFolder := getSmartCurrentFolder()
	if(newFolder)
	{
		capture = "ON"
		tutorialFolder := StrReplace(newFolder, "file:", "")		
		showText("","Folder tutorial was changed to " . tutorialFolder, 2000, 500, 60)
	}else
		showFailMessage("Use windows explorer, the current folder will be used", 2500)
}


showTutorialFolder(){
	global tutorialFolder
	if(tutorialFolder)		
		Run, %tutorialFolder%\TImages\
	else
		showFailMessage("tutorial Folder has not been configured", 1500)
}

InvokeTutorialCapture(sendToCaptureScreen=1){
	global tutorialFolder
	global ownFolder
	
	FormatTime, TimeString,, yyyy-MM-dd HH-mm-ss
	IfNotExist, %tutorialFolder%\TImages
		FileCreateDir, %tutorialFolder%\TImages
	if sendToCaptureScreen
		SendInput, #+s
	Run, %A_ScriptDir%\%ownFolder%\ClipboardImageToFile.exe -secondsToWait 20 -imagePath "%tutorialFolder%\TImages\%TimeString%.png"
	return
}

ClipboardTutorialCapture(){
	InvokeTutorialCapture(0)
	showMessage("Saving clipboard image to tutorial folder",1000)
}

RunTemplate(){	
	global tutorialFolder
	global capture	
	if capture = "ON" 
	{		
		FileCopy, %A_ScriptDir%\TutorialMaker\Word template.docx, %tutorialFolder%, 1
		if ErrorLevel
			MsgBox,,, %ErrorLevel%
		
		ShowProgress("initializing word...")
		
		oWord := ComObjCreate("Word.Application")
		wordFile := % tutorialFolder . "\Word template.docx"
		
		ShowProgress(wordFile, 400)
		
		oWord.Documents.Add(wordFile)
		
		
		oWord.Selection.TypeParagraph
		oWord.Selection.Font.Size := 32
		oWord.Selection.TypeText("Tutorial")
		oWord.Selection.TypeParagraph		
		
		
		Loop Files, %tutorialFolder%\TImages\*.png
		{
			ShowProgress("adding " . A_LoopFileFullPath, 550)
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
	}
}

EditTextImage(){
	static title
	static description
	static step
	global tutorialFolder
	static path
	
	path := getSmartSelectedItem()	
	
	if(path){
		SplitPath, path, , dir
		if dir != %tutorialFolder%\TImages
			MsgBox,,, image doesn´t belong to tutorial folder
		else
		{
			Gui, editTextGui:New, AlwaysOnTop -DPIScale ToolWindow
			Gui, Add, Text,, Step:
			Gui, Add, Edit
			Gui, Add, UpDown, vstep Range0-100, 0
			Gui, Add, Text,, Title:
			Gui, Add, Edit, vtitle w300
			Gui, Add, Text,, Description:
			Gui, Add, Edit, vdescription r5 w300
			Gui, Add, Button, Default gSaveIM, Ok
			
			Gui, editTextGui:show, AutoSize Center, Edit image metadata
		}
	}
	
	return
	
	SaveIm:	
	Gui, Submit	
	configImg := { step: step, title: title, description: description }
	fullJsonPath := path . ".json"
	MsgBox,,, % fullJsonPath
	fullJsonContent := JSON.Dump(configImg,,2)
	FileDelete, %fullJsonPath% 
	FileAppend, %fullJsonContent% ,%fullJsonPath%
	return
}
