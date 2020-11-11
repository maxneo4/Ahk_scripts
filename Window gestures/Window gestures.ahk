WindowGesturesInit(){
	global pos = 1	
	global windows := []
	
	Hotkey, ^Up, AddWindowById, On
	Hotkey, ^Down, RemoveActiveWindow, On
	Hotkey, ^Right, MoveNextWindow, On
	Hotkey, ^Left, MovePreviousWindow, On
	Hotkey, ^+Down, RemoveAll, On
}

RemoveAll()
{
	global pos = 1
	global windows := []
	showText("gestor windows", "Removed all windows", 800)
}

AddWindowById()
{	
	global pos
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A

	if (ObjIndexOf(windows, active_id) = 0)
	{
		windows.Push(active_id)
		pos := windows.MaxIndex()
		currentAddedWindow := % "Added window '" . SubStr(wTitle, 1, 35) . "' in pos " . Windows.MaxIndex()
		showText("gestor window", currentAddedWindow, 1000)	
	}else
	{
		showText("gestor window", "Windows added already", 500)	
	}
}


MoveNextWindow()
{	
	global pos
	global windows
	
	updtePosToActiveWindow()
	
	pos++
	if ( pos > windows.MaxIndex() && windows.MaxIndex() > 0)	
		pos = 1
	w := windows[pos]
	if WinExist("ahk_id" . w)
		WinActivate, ahk_id %w%
	Else if w
		{
			windows.RemoveAt(pos)
			MoveNextWindow()
		}
	;showText("gestor window", pos, 400, 100, 20)
}

MovePreviousWindow()
{
	global pos
	global windows
	
	updtePosToActiveWindow()
	
	pos--	
	if ( pos < 1 && windows.MaxIndex() > 0)	
		pos := windows.MaxIndex()	
	w := windows[pos]
	if WinExist("ahk_id" . w)
		WinActivate, ahk_id %w%
	Else if w
		{
			windows.RemoveAt(pos)
			MovePreviousWindow()
		}
	;showText("gestor window", pos, 400, 100, 20)
}

RemoveActiveWindow()
{
	global pos
	global windows
	
	WinGet, active_id, ID, A
	WinGetTitle, wTitle, A
	if (ObjIndexOf(windows, active_id))
	{
		posW := ObjIndexOf(windows, active_id)		
		messageRemovedW := % "removed window " . SubStr(wTitle, 1, 35) . " from pos " . posW . " of " . Windows.MaxIndex()
		windows.RemoveAt(posW)
		showText("gestor window", messageRemovedW, 1000)	
	}
}

updtePosToActiveWindow()
{
	global pos
	global windows
	
	WinGet, active_id, ID, A

	if(active_id)
		posFound := ObjIndexOf(windows, active_id)
	if posFound		
		pos := posFound		
}