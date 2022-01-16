WindowGesturesInit(){	
	Hotkey, ^!Up, setAlwaysOnTop, On
	Hotkey, ^!Down, quitAlwaysOnTop, On
}

setAlwaysOnTop(){
	Winset, Alwaysontop, On, A
	if ErrorLevel = 0
		ShowToolTip("Always On Top activated")
}

quitAlwaysOnTop(){
	Winset, Alwaysontop, Off, A
	if ErrorLevel = 0
		ShowToolTip("Always On Top deactivated")
}