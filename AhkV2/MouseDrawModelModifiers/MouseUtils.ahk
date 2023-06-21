; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#SingleInstance


~s & LButton::
{
	Click "Middle Down"
}


~s::
{
	KeyWait "s"
	Click "Middle Up"
}

~space::
{
	Click "Middle Up"
}


~LCtrl & LButton::Click "Middle Down"

~LAlt & LButton::Click "Middle"