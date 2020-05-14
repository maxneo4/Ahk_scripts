coordmode, mouse, screen
mousegetpos theX, theY
Gui destroy ; destroy previously opened gui

Gui add, activeX, w110 h70 vTest, D:\htmgui.html
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  
CustomColor = EEAA99 
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor% 255 
test.silent := true 
while test.readyState != 4 or test.busy
    sleep 100

divs := test.document.getElementById("div1")
ComObjConnect(divs, "divs_")
Gui, Show, x%theX% y%theY%, divclick_tester

divs_onClick(){
	soundbeep
  	msgbox ThumbsUp!
  	gui destroy
}