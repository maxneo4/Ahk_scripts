~*CapsLock::        ; Show CapsLock state on screen
if GetKeyState("CapsLock", "T")
    Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, CAPS LOCK ON
else
    Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CT0000FF, CAPS LOCK OFF
SetTimer, OSD_OFF, -2000
return

~*NumLock::     ; Show NumLock state on screen
if GetKeyState("NumLock", "T")
    Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CTFF0000, NUM LOCK ON
else
    Progress, B1 W200 H28 ZH0 FS11 WS900 Y700 CT0000FF, NUM LOCK OFF
SetTimer, OSD_OFF, -2000
return

OSD_OFF:
Progress, off
return