WindowGesturesInit(){
	global pos = 1
	global windowsDic := {}
	global windows := []
	
	Hotkey, Tab & a, AddWindowById, On
	Hotkey, Tab & s, RemoveActiveWindow, On
	Hotkey, Tab & q, MoveNextWindow, On
	Hotkey, *Tab, SendTab, On	
}

AddWindowById()
{	
	global pos
	global windowsDic
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A
	windowsDic[active_id] := wTitle
	windows.Push(active_id)
	pos := windows.MaxIndex()
	currentAddedWindow := % "Added window '" . wTitle . "' in pos " . Windows.MaxIndex()
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
	showText("gestor window", %pos%, 500, 200, 20)
}

RemoveActiveWindow()
{
	global pos
	global windowsDic
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A
	if (windowsDic.HasKey(active_id))
	{
		posW := ObjIndexOf(windows, active_id)
		windows.RemoveAt(posW)
		messageRemovedW := % "removed window " . wTitle . " from pos " . posW
		showText("gestor window", messageRemovedW, 1500)	
	}
}

SendTab(){
	SendInput {Blind}{Tab}
}
