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

time(){
	MouseClick "left", 1523, 105
	MouseMove 1294, 270
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

changeGraphicLine(){
	MouseClick "left", 100, 600
	Sleep twait
	MouseClick "left", 150, 590
	Sleep twait
	MouseClick "left", 480, 650
	;Sleep twait
	Send "{Esc}"
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

up(){
	MouseMove 1535, 412
}

down(){
	MouseMove 1535, 533
}

amount(){
	MouseClick "left", 1510, 175
	MouseMove 1400, 192
}

;#HotIf WinActive("IQ Option")
;^w::higher()
;#HotIf WinActive("IQ Option")
;^s::lower()
#HotIf WinActive("IQ Option")
c:: candleT()
#HotIf WinActive("IQ Option")
g:: graphicT()
#HotIf WinActive("IQ Option")
t:: time()
#HotIf WinActive("IQ Option")
l:: tline()
#HotIf WinActive("IQ Option")
h:: hLine()
#HotIf WinActive("IQ Option")
p:: changeGraphicLine()

#HotIf WinActive("IQ Option")
y:: changeColorY()
#HotIf WinActive("IQ Option")
m:: changeColorM()
#HotIf WinActive("IQ Option")
w:: changeColorW()
#HotIf WinActive("IQ Option")
^g:: changeColorG()
#HotIf WinActive("IQ Option")
r:: changeColorR()
#HotIf WinActive("IQ Option")
^d:: clone()
#HotIf WinActive("IQ Option")
s::scriptOptions()

#HotIf WinActive("IQ Option")
u::up()

#HotIf WinActive("IQ Option")
d::down()

#HotIf WinActive("IQ Option")
a::amount()


SetTimer OpenIQOption, 30000

OpenIQOption(){
	TimeString := FormatTime(, "mm:ss")
	Arr := StrSplit(TimeString, ":")
	minutes := Integer(Arr[1])
	seconds := Integer(Arr[2])
	minPlus := 1
	if(seconds > 30){
		minPlus := 2
	}
	if( mod(minutes+minPlus, 5) == 0){
		for i in [1,2,3,4]
		{
			if WinWait("ahk_class IQ_OPTION", , 1)
			{}else
			{
				Send "^#{Right}"
			}
		}
		WinActivate "ahk_class IQ_OPTION"
		;MsgBox "The current time and date (time first) is " Arr[1] ":" Arr[2]
	}
	Sleep 30000
}