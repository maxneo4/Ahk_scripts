WindowGesturesInit(){
	global pos = 1	
	global windows := []
	
	Hotkey, Tab & a, AddWindowById, On
	Hotkey, Tab & s, RemoveActiveWindow, On
	Hotkey, Tab & q, MoveNextWindow, On
	Hotkey, *Tab, SendTab, On	
}

AddWindowById()
{	
	global pos
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A
	windows.Push(active_id)
	pos := windows.MaxIndex()
	currentAddedWindow := % "Added window '" . SubStr(wTitle, 1, 35) . "' in pos " . Windows.MaxIndex()
	showText("gestor window", currentAddedWindow, 1500)	
}


MoveNextWindow()
{
	global pos
	global windows
	
	pos++
	if ( pos > windows.MaxIndex() )	
		pos = 1
	w := windows[pos]
	WinActivate, ahk_id %w%
	;showText("gestor window", pos, 400, 100, 20)
}

RemoveActiveWindow()
{
	global pos
	global windowsDic
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A
	if (ObjIndexOf(windows, active_id))
	{
		posW := ObjIndexOf(windows, active_id)
		windows.RemoveAt(posW)
		messageRemovedW := % "removed window " . SubStr(wTitle, 1, 35) . " from pos " . posW
		showText("gestor window", messageRemovedW, 1500)	
	}
}

SendTab(){
	SendInput {Blind}{Tab}
}
