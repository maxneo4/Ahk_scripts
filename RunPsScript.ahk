#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
	try
	{
		if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart
		else
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
	}
	ExitApp
}

#include CustomFunctions\custom_functions.ahk
#include CustomFunctions\form_functions.ahk

controls := [{name: "Delete Dbs", type: "CheckBox", state: "0"}, {name: "limit MB", type: "DropDownList", state: "5000", value: "500|1000|2000|3000|4000|5000|10000|20000"}, {name: "limit days", type: "DropDownList", state:"365", value: "8|15|30|90|180|365"}]
value := DynamicInputBox({title: "Free disk space", width: 200, vspace: 32, Margin: 10, controls: controls, storeFileIni: "storedValues.ini" } )

if value != "Canceled"
{
	deleteDbs := value["Delete Dbs"]
	limitMb := value["limit Mb"]
	limitDays := value["limit days"]
	Run, powershell.exe -file FreeDiskSpaceBizStudio.ps1 -deleteDbs %deleteDbs% -limitMb %limitMb% -limitDays %limitDays%
}

ExitApp