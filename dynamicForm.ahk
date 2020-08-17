#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8

#Include Ahk Resources\AhkLibs\json.ahk
#include CustomFunctions\custom_functions.ahk
#include CustomFunctions\form_functions.ahk
if(A_Args.MaxIndex() > 1)
{
	configPath := A_Args[1]
	restulPath := A_Args[2]
	FileRead, configValue, %configPath%
	config := JSON.Load(configValue)

	result := DynamicInputBox(config)
	jsonResult := JSON.Dump(result)
	FileDelete, %restulPath%
	FileAppend, %jsonResult%, %restulPath%
}Else
	MsgBox, , Required parameters, Path with json configuration and path to put result is mandatory, 3

ExitApp