InitTutorialMaker(){
	global capture = "OFF"
	global tutorialFolder	
	
	Hotkey, ^!c, ChooseEnabledTutorialFolder, On
	Hotkey, ^!d, DisableTutorialFolder, On
	
	global fnCaptureEnabled := Func("CaptureEnabled")	
	Hotkey, If, % fnCaptureEnabled
	
	Hotkey, #s, InvokeTutorialCapture, On
	Hotkey, #e, openTutorialCaptureEdit, On
	Hotkey, #c, ClipboardTutorialCapture, On
	Hotkey, #o, showTutorialFolder, On
	Hotkey, #r, RunTemplate, On
	
	Hotkey, #t, EditTextImage, On
	
	Hotkey, if	
	
	;OnClipboardChange("ClipChanged")	
}

openTutorialCaptureEdit(){
	SendInput, ^{PrintScreen}
	ClipWait, 5
	ClipboardTutorialCapture()
}

ClipChanged(Type) {
	MsgBox,,, trigered
	ToolTip Clipboard data type: %Type%
	Sleep 1000
	ToolTip  ; Turn off the tip.
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
		wordFile := % tutorialFolder . "\Tutorial.docx"
		
		FileCopy, %A_ScriptDir%\TutorialMaker\Word template.docx, %wordFile%, 1
		if ErrorLevel
			MsgBox,,, error coping template %ErrorLevel%
		
		ShowProgress("initializing word...")
		
		oWord := ComObjCreate("Word.Application")		
		
		ShowProgress(wordFile, 400)
		
		wDoc := oWord.Documents.Open(wordFile)
		
		
		oWord.Selection.TypeParagraph
		oWord.Selection.Font.Size := 32
		oWord.Selection.TypeText("Tutorial")
		oWord.Selection.TypeParagraph		
		
		
		Loop Files, %tutorialFolder%\TImages\*.png
		{
			ShowProgress("adding " . A_LoopFileFullPath, 550)
			
			fullJsonPath := A_LoopFileFullPath . ".json"
			if FileExist(fullJsonPath)
			{
				FileRead, jsonContent, %fullJsonPath%
				valueImageMetadata := JSON.Load( jsonContent )
			}
			
			oWord.Selection.TypeParagraph
			oWord.Selection.Font.Size := 24
			step := % valueImageMetadata? ( valueImageMetadata.step > 0 ? "Step" . valueImageMetadata.step : "" ) : ""
			oWord.Selection.BoldRun
			oWord.Selection.TypeText(step)
			oWord.Selection.BoldRun
			
			oWord.Selection.Font.Size := 32
			title := % valueImageMetadata? valueImageMetadata.title : ""
			oWord.Selection.TypeParagraph
			oWord.Selection.TypeText(title)
			oWord.Selection.TypeParagraph
			
			oWord.Selection.Font.Size := 14
			description := % valueImageMetadata? valueImageMetadata.description : ""
			oWord.Selection.TypeText(description)
			oWord.Selection.TypeParagraph
			oWord.Selection.InlineShapes.AddPicture(A_LoopFileFullPath,0,1)
			oWord.Selection.TypeParagraph		
			
			valueImageMetadata = 
		}
		OSD_OFF()
		
		wDoc.Save()
		wDoc.Close()
		oWord.Quit()
		Sleep, 500
		
		Run, %wordFile%	
	}
}

EditTextImage(){
	static title
	static description
	static step
	global tutorialFolder
	static fullJsonPath
	static configImg
	
	path := getSmartSelectedItem()	
	
	if(path){
		fullJsonPath := path . ".json"
		SplitPath, path, , dir
		if dir != %tutorialFolder%\TImages
			MsgBox,,, image doesn´t belong to tutorial folder
		else
		{
			if FileExist(fullJsonPath)
			{
				FileRead, fullJsonContent, %fullJsonPath%
				configImg := JSON.Load(fullJsonContent)
			}else
				configImg := { step: "0", title: "", description: "" }
			
			step := configImg.step
			
			Gui, editTextGui:New, AlwaysOnTop -DPIScale ToolWindow
			Gui, Add, Text,, Step:
			Gui, Add, Edit,, 
			Gui, Add, UpDown, vstep Range0-100, %step%
			Gui, Add, Text,, Title:
			Gui, Add, Edit, vtitle w300, % configImg.title
			Gui, Add, Text,, Description:
			Gui, Add, Edit, vdescription r5 w300, % configImg.description
			Gui, Add, Button, Default gSaveIM, Ok
			
			Gui, editTextGui:show, AutoSize Center, Edit image metadata
		}
	}
	
	return
	
	SaveIm:	
	Gui, Submit	
	configImg := { step: step, title: title, description: description }
	
	fullJsonContent := JSON.Dump(configImg,,2)
	FileDelete, %fullJsonPath% 
	FileAppend, %fullJsonContent% ,%fullJsonPath%
	return
}

