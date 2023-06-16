; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#SingleInstance

twait := 50

higher(){
	MouseClick "left", 1556, 420
}

lower(){
	MouseClick "left", 1556, 528
}

graphicT(){
	MouseClick "left", 108, 700
}

candleT(){
	MouseClick "left", 100, 650
}

line(){
	MouseClick "left", 108, 700
	Sleep twait
	MouseClick "left", 212, 608
}

tline(){
	MouseClick "left", 108, 700
	Sleep twait
	MouseClick "left", 201, 640
}

hLine(){
	MouseClick "left", 108, 700
	Sleep twait*3
	MouseClick "left", 201, 680
}

changeColorY(){
	MouseClick "left", 145, 730
	Sleep twait
	MouseClick "left", 220, 492
	Sleep 50
	Send "{Esc}"
}

changeColorM(){
	MouseClick "left", 145, 730
	Sleep twait
	MouseClick "left", 351, 492
	Sleep twait
	Send "{Esc}"
}

changeColorW(){
	MouseClick "left", 145, 730
	Sleep twait
	MouseClick "left", 159, 595
	Sleep twait
	Send "{Esc}"
}

changeColorG(){
	MouseClick "left", 145, 730
	Sleep twait
	MouseClick "left", 249, 493
	Sleep twait
	Send "{Esc}"
}

changeColorR(){
	MouseClick "left", 145, 730
	Sleep twait
	MouseClick "left", 157, 491
	Sleep twait
	Send "{Esc}"
}


clone(){
	MouseClick "left", 242, 731
}

scriptOptions(){
	MouseClick "left", 102, 729
	Sleep twait
	MouseClick "left", 200, 430
	Sleep twait
	MouseClick "left", 550, 470
}

;#HotIf WinActive("IQ Option")
;^w::higher()
;#HotIf WinActive("IQ Option")
;^s::lower()
#HotIf WinActive("IQ Option")
c:: candleT()
#HotIf WinActive("IQ Option")
f:: graphicT()
#HotIf WinActive("IQ Option")
l:: line()
#HotIf WinActive("IQ Option")
t:: tline()
#HotIf WinActive("IQ Option")
h:: hLine()
#HotIf WinActive("IQ Option")
y:: changeColorY()
#HotIf WinActive("IQ Option")
m:: changeColorM()
#HotIf WinActive("IQ Option")
w:: changeColorW()
#HotIf WinActive("IQ Option")
g:: changeColorG()
#HotIf WinActive("IQ Option")
r:: changeColorR()
#HotIf WinActive("IQ Option")
^d:: clone()
#HotIf WinActive("IQ Option")
s::scriptOptions()

;add change velas time