; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#SingleInstance


~r & LButton::
{
	Click "Middle Down"
}


~r::
{
	KeyWait "r"
	Click "Middle Up"
}

~space::
{
	Click "Middle Up"
}


~LCtrl & LButton::Click "Middle Down"

~LAlt & LButton::Click "Middle"