; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

getCurrentTitle(){
	active_id := WinGetID("A")
	title := WinGetTitle(active_id)
	MsgBox title
}

^d::getCurrentTitle()

match(text){
	index := IntStr( getCurrentTitle(), text)
	return index !=-1
}
MyWinText := "Visual"
#HotIf match(MyWinText)
^Space::MsgBox "You pressed Win+Spacebar"

while 1
{
    Sleep 5000
	;Send "^s"
}