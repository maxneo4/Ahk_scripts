/*
	Name: Pixel Predator v1.2.1 (Release Copy)
	Written By: Hellbent aka CivReborn
	Date Started: June 2nd, 2019
	Date Of Last Edit: June 3rd,2019
	Paste: https://pastebin.com/JqpTYAFT
	Description: Pixel Search Script
*/
#SingleInstance,Force
#NoEnv
ListLines,Off
SetBatchLines,-1
CoordMode,Mouse,Screen
CoordMode,Pixel,Screen
SetKeyDelay,30
SetMouseDelay,30
SetDefaultMouseSpeed,0
Gdip_Startup()
global HB_Button:=[],Selected_Color:="610094",Color_Edit:="0x610094",Stop:=1,X_Pos:="",Y_Pos:="",W_Pos:="",H_Pos:="",cx2:="",cy2:="",cx:="",cy:="",Commands:="",Variation:=0,Start_Key :="Numpad1",Stop_Key:="Numpad2",RTimes:=1,CMove:=1,CTimes:=1,XOff:=10,YOff:=10,TypeC:="Left",Send_Stuff:="",M_Delay:=30,Key_Delay:=30,Delay:=500
Hotkey,%Start_Key%,Start_Search
Hotkey,%Stop_Key%,Stop_Search
Main := New Custom_Window( x:= 0 , y:= 0 , w:= 450 , h:= 300 , Name:= "1" , Options:= "+AlwaysOnTop -Caption -DPIScale" , Title:= "Pixel Predator v1.2" , Background_Bitmap:= PixelPredatorBG() )
Gui,1:Add,Text,x5 y5 w30 h30 BackgroundTrans gTag
Gui,1:Add,Text,x85 y6 w280 h28 BackgroundTrans gMove_Window
Gui,1:Add,Text,x409 y6 w15 h15 BackgroundTrans gMin_Window
Gui,1:Add,Text,x429 y6 w15 h15 BackgroundTrans gGuiClose
Gui,1:Color,222222,222222
Gui,1:Font,cffffff s8 ,arial
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=30  , y := 52 , w := 100 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "Set Color" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "SetColor" , Default_Button := 0 , Roundness:=2 ) )
Gui,1:Add,Progress,x145 y54 w50 h24 Background000000 c%Selected_Color% vSelected_Color,100
Gui,1:Add,Edit, x210 y55 w80 h22 Center vColor_Edit,% Color_Edit
Gui,1:Add,Edit, x365 y55 w50 h22 Center Number Limit2 vVariation,% Variation
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=30  , y := 97 , w := 100 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "Set Search Area" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "Set_Position" , Default_Button := 0 , Roundness:=2 ) )
Gui,1:Add,Edit, x175 y100 w40 h22 Center ReadOnly vX_Pos,null
Gui,1:Add,Edit, x245 y100 w40 h22 Center ReadOnly vY_Pos,null
Gui,1:Add,Edit, x315 y100 w40 h22 Center ReadOnly vW_Pos,null
Gui,1:Add,Edit, x385 y100 w40 h22 Center ReadOnly vH_Pos,null
Global Truth:=[]
Truth[1]:=New Flat_Round_Radio_Type_1(x:=35,y:=147,w:=60,Text:="True",Font:="Arial",FontSize:= "10 Bold" , FontColor:="FFFFFF" ,Window:="1",Background_Color:="333333",HighLightColor:="A866E2",State:=1,GroupArray:=Truth)
Truth[2]:=New Flat_Round_Radio_Type_1(x+=w,y:=147,w:=80,Text:="False",Font:="Arial",FontSize:= "10 Bold" , FontColor:="FFFFFF" ,Window:="1",Background_Color:="333333",HighLightColor:="A866E2",State:=0,GroupArray:=Truth)
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=210  , y := 138 , w := 195 , h := 38 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "Open   ""Send""   Documentation" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "OpenDoc" , Default_Button := 0 , Roundness:=2 ) )
Gui,1:Add,Edit, x25 y190 w260 h22 vCommands,% Commands
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=293  , y := 187 , w := 30 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "C" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "Defall" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x+=w+5  , y := 187 , w := 30 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "M" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "DefallM" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x+=w+5  , y := 187 , w := 30 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "T" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "DefallT" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x+=w+5  , y := 187 , w := 30 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "?" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "Run_Command_Window" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=50  , y := 225 , w := 350 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "<><><><>   Hotkeys & Info   <><><><>" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "Run_Hotkey_Window" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=20  , y += h+3 , w := 130 , h := 30 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "Start" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "StartBB" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x+=w+10  , y , w  , h := 30 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "Stop" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "StopBB" , Default_Button := 0 , Roundness:=2 ) )
HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x+=w+10  , y , w  , h := 30 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "Reload" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "1" , Label := "Reload" , Default_Button := 0 , Roundness:=2 ) )
Main.Show_Window()
GuiControl , % HB_Button[ 1 ].Window ": Focus" , % HB_Button[ 1 ].Hwnd
SetTimer, HB_Button_Hover , 50
return
GuiClose:
	ExitApp
Tag(){
	Stop:=1
	try
		run,https://www.youtube.com/channel/UCge0TKjySLXd8xeLib8F0rA
}
Move_Window(){
	PostMessage,0xA1,2
}
Min_Window(){
	Gui,1:Minimize
}
Reload(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	Reload
}
OpenDoc(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	try	{
		Run, https://autohotkey.com/docs/commands/Send.htm
	}catch	{
		Gui,1:+OwnDialogs
		msgbox,,Failed to open Send Documentation Page,Google Search - Autohotkey Send
	}
}
Defall(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	GuiControl,1:,Commands,*1*1*1*10*10*Left*%M_Delay%*%Key_Delay%*%Delay%*
}
DefallM(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	GuiControl,1:,Commands,*1*0*1*10*10*Left*%M_Delay%*%Key_Delay%*%Delay%*
}
DefallT(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	GuiControl,1:,Commands,*1*0*0*10*10*Left*%M_Delay%*%Key_Delay%*%Delay%*
}
SetColor(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	While(!GetKeyState("ctrl")){
		ToolTip,Press ""Ctrl"" to set Search Color
		MouseGetPos,tpx,tpy
		PixelGetColor,Selected_Color,%tpx%,%tpy%,RGB
		GuiControl,1:+c%Selected_Color%,Selected_Color
		GuiControl,1:,Color_Edit,% Selected_Color
	}
	ToolTip,
}
StartBB(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	Start_Search()
}
StopBB(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
}
Set_Position(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	SPOS()
}
SPOS(){
	global
	Gui,3:-Caption -DPIScale +LastFound +E0x80000 +ToolWindow +AlwaysOnTop
	Gui,3:Show,x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NA
	hwnd1:=WinExist(),hbm := CreateDIBSection(A_ScreenWidth,A_ScreenHeight),hdc := CreateCompatibleDC(),obm := SelectObject(hdc,hbm)
	G := Gdip_GraphicsFromHDC(hdc),Gdip_SetSmoothingMode(G,4),UpdateLayeredWindow(hwnd1, hdc, 0, 0,A_ScreenWidth,A_ScreenHeight)
	Br1:=New_Brush("ff0066","ff"),Br2:=New_Brush("12e854","55"),Br3:=New_Brush("de0d0a","aa")
	UpdateLayeredWindow(hwnd1, hdc),Pos_Setting_Active:=1,TL:=1
	SetTimer,Draw_Cross,10
}
Draw_Cross:
	Gdip_GraphicsClear(G)
	if(TL=1){
		MouseGetPos,cx,cy
		Fill_Box(G,Br1,0,cy,A_ScreenWidth,1),Fill_Box(G,Br1,cx,0,1,A_ScreenHeight)
		GuiControl,1:,X_Pos,% cx
		GuiControl,1:,Y_Pos,% cy
		X_Pos:=cx,Y_Pos:=cy
	}
	else if(TL=2){
		MouseGetPos,cx2,cy2
		if(cx2-cx>=0&&cy2-cy>=0){
			OB:=0
			Fill_Box(G,Br1,0,cy2,A_ScreenWidth,1),Fill_Box(G,Br1,cx2,0,1,A_ScreenHeight),Fill_Box(G,Br1,0,cy,A_ScreenWidth,1)
			Fill_Box(G,Br1,cx,0,1,A_ScreenHeight),Fill_Box(G,Br2,cx,cy,cx2-cx,cy2-cy)
			GuiControl,1:,W_Pos,% cx2 - cx
			GuiControl,1:,H_Pos,% cy2 - cy
		}
		else if(cx2-cx>=0&&cy2-cy<0){
			OB:=1
			Fill_Box(G,Br1,0,cy2,A_ScreenWidth,1),Fill_Box(G,Br1,cx2,0,1,A_ScreenHeight),Fill_Box(G,Br1,0,cy,A_ScreenWidth,1)
			Fill_Box(G,Br1,cx,0,1,A_ScreenHeight),Fill_Box(G,Br3,cx,cy2,cx2-cx,cy-cy2)
			GuiControl,1:,W_Pos,% (cx2 - cx)
			GuiControl,1:,H_Pos,% (cy2 - cy)*-1
		}
		else if(cx2-cx<0&&cy2-cy>=0){
			OB:=1
			Fill_Box(G,Br1,0,cy2,A_ScreenWidth,1),Fill_Box(G,Br1,cx2,0,1,A_ScreenHeight),Fill_Box(G,Br1,0,cy,A_ScreenWidth,1)
			Fill_Box(G,Br1,cx,0,1,A_ScreenHeight),Fill_Box(G,Br3,cx2,cy,cx-cx2,cy2-cy)
			GuiControl,1:,W_Pos,% (cx2 - cx)*-1
			GuiControl,1:,H_Pos,% (cy2 - cy)
		}
		else if(cx2-cx<0&&cy2-cy<0){
			OB:=1
			Fill_Box(G,Br1,0,cy2,A_ScreenWidth,1),Fill_Box(G,Br1,cx2,0,1,A_ScreenHeight),Fill_Box(G,Br1,0,cy,A_ScreenWidth,1)
			Fill_Box(G,Br1,cx,0,1,A_ScreenHeight),Fill_Box(G,Br3,cx2,cy2,cx-cx2,cy-cy2)
			GuiControl,1:,W_Pos,% (cx2 - cx)*-1
			GuiControl,1:,H_Pos,% (cy2 - cy)*-1
		}
	}
	UpdateLayeredWindow(hwnd1, hdc)	
	return
SortCommandList(){
	GuiControlGet,Commands,1:,Commands
	stringleft,tep,Commands,1
	if(tep="*"){
		CMove:="",CTimes:="",XOff:="",YOff:="",TypeC:="Left",RTimes:=1,Send_Stuff:=""
		Loop, Parse, Commands,*
		{
			(A_Index=2)?(RTimes:=A_LoopField)
			:(A_Index=3)?(CMove:=A_LoopField)
			:(A_Index=4)?(CTimes:=A_LoopField)
			:(A_Index=5)?(XOff:=A_LoopField)
			:(A_Index=6)?(YOff:=A_LoopField)
			:(A_Index=7)?(TypeC:=A_LoopField)
			:(A_Index=8)?(M_Delay:=A_LoopField)
			:(A_Index=9)?(Key_Delay:=A_LoopField)
			:(A_Index=10)?(Delay:=A_LoopField)
			:(A_Index=11)?(Send_Stuff:=A_LoopField)
		}
		Return True
	}else	{
		Gui,1:+OwnDialogs
		MsgBox,,Error,There is a error with your command setup
		Stop:=1
		return False
	}
}
Click_Function(x,y,LT,BTN){
	CoordMode,Mouse,Screen
	SetMouseDelay,%M_Delay%
	index:=0
	While(Index<LT&&!Stop){
		Click %BTN%,%x%,%y%
		index++
	}
}
Move_Function(x,y){
	CoordMode,Mouse,Screen
	MouseMove,x,y,0
}
Send_Function(SS){
	SetKeyDelay,%Key_Delay%
	Send,% SS
}
Start_Search(){
	Stop:=0
	if(!SortCommandList())
		return
	GuiControlGet,Color_Edit,1:,Color_Edit
	GuiControlGet,Variation,1:,Variation 
	While(!Stop){
		PixelSearch,px,py,X_Pos,Y_Pos,cx2,cy2,Color_Edit,Variation,Fast|RGB
		if(!ErrorLevel&&Truth[1].State=1){
			if(CMove=1)
				Click_Function(px+XOff,py+YOff,CTimes,TypeC)
			else if(CMove=0&&CTimes>=1)
				Move_Function(px+XOff,py+YOff)
			if(Send_Stuff)
				Send_Function(Send_Stuff)
			if(RTimes=0){
				Stop:=1
				return
			}
			Sleep,% Delay
		}else if(ErrorLevel=1&&Truth[2].State=1){
			if(Send_Stuff)
				Send_Function(Send_Stuff)
			if(RTimes=0){
				Stop:=1
				return
			}
			Sleep,% Delay
		}
	}
}
Stop_Search(){
	Stop:=1
}
#If (Pos_Setting_Active=1)
*Lbutton::
	if(TL=1)
		TL:=2
	else if(TL=2&&OB=0){
		Gui,3:Destroy
		Pos_Setting_Active:=0
		SetTimer,Draw_Cross,Off
	}
	return
#If
Run_Hotkey_Window(){
	static HKWindow:={}
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	if(!HKWindow.Hwnd){
		HKWindow := New Custom_Window( x:= 0 , y:= 0 , w:= 300 , h:= 250 , Name:= "6" , Options:= "+AlwaysOnTop -Caption -DPIScale +Owner1" , Title:= "Command Window" , Background_Bitmap:= HotkeyWindow() )
		Gui,6:Add,Text,x50 y6 w200 h26 BackgroundTrans gMove_Window
		Gui,6:Add,Hotkey,x60 y125 w140 h22 vStart_Key,% Start_Key
		Gui,6:Add,Hotkey,x60 y162 w140 h22 vStop_Key,% Stop_Key
		HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=208  , y:=123 , w:=70  , h := 28 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "Update" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "6" , Label := "UpdateStartKey" , Default_Button := 0 , Roundness:=2 ) )
		HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=208  , y:=160 , w:=70  , h := 28 , Button_Color := "22005C" , Button_Background_Color := "333333" , Text := "Update" , Font := "Arial" , Font_Size := 10 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "6" , Label := "UpdateStopKey" , Default_Button := 0 , Roundness:=2 ) )
		HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=50  , y:=195 , w:=200  , h := 40 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "OK" , Font := "Arial" , Font_Size := 14 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "6" , Label := "CloseHKWindow" , Default_Button := 0 , Roundness:=2 ) )
	}
	HKWindow.Show_Window()
}
CloseHKWindow(){
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	Gui,6:Hide
}
UpdateStartKey(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	GuiControlGet,New_Key,6:,Start_Key
	if(New_Key!=Start_Key&&New_Key!=null){
		Hotkey,%Start_Key%,Start_Search,Off
		Hotkey,% Start_Key:=New_Key,Start_Search,On
	}
}
UpdateStopKey(){
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	GuiControlGet,New_Key,6:,Stop_Key
	if(New_Key!=Stop_Key&&New_Key!=null){
		Hotkey,%Stop_Key%,Stop_Search,Off
		Hotkey,% Stop_Key:=New_Key,Stop_Search,On
	}
}
Run_Command_Window(){
	static CommandWindow:={}
	Stop:=1
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	if(!CommandWindow.Hwnd){
		CommandWindow := New Custom_Window( x:= 0 , y:= 0 , w:= 400 , h:= 500 , Name:= "5" , Options:= "+AlwaysOnTop -Caption -DPIScale +Owner1" , Title:= "Command Window" , Background_Bitmap:= CommandWindow() )
		Gui,5:Add,Text,x50 y6 w300 h29 BackgroundTrans gMove_Window
		HB_Button.Push( New HB_Flat_Rounded_Button_Type_1( x:=100  , y:=440 , w:=200  , h := 40 , Button_Color := "22005C" , Button_Background_Color := "252525" , Text := "OK" , Font := "Arial" , Font_Size := 14 " Bold" , Font_Color_Top := "aaaaaa" , Font_Color_Bottom := "000000" , Window := "5" , Label := "CloseCommandWindow" , Default_Button := 0 , Roundness:=5 ) )
	}
	CommandWindow.Show_Window()
}
CloseCommandWindow(){
	GuiControl , % HB_Button[ A_GuiControl ].Window ": Focus" , % HB_Button[ A_GuiControl ].Hwnd
	if( ! HB_Button[ A_GuiControl ].Draw_Pressed() )
		return
	Gui,5:Hide
}
class Flat_Round_Radio_Type_1	{
	__New(x,y,w:=19,Text:="Text",Font:="Arial",FontSize:= "10 Bold" , FontColor:="FFFFFF" ,Window:="1",Background_Color:="36373A",HighLightColor:="1A1C1F",State:=0,GroupArray:=""){
		This.State:=State,This.X:=x,This.Y:=y,This.W:=W,This.H:=19,This.Text:=Text,This.Font:=Font,This.FontSize:=FontSize,This.FontColor:="0xFF" FontColor
		This.HighLightColor:= "0xFF" HighLightColor,This.GroupArray:=GroupArray,This.Name:=This.GroupArray.Length()+1,This.Background_Color:="0xFF" Background_Color,This.Window:=Window
		This.Create_Off_Bitmap(),This.Create_On_Bitmap(),This.Create_Trigger()
		sleep,20
		if(This.State)
			This.Draw_On()
		else
			This.Draw_Off()
		udb := THIS.UpdateValue.BIND( THIS )
		SetTimer,% udb,-100
	}
	Create_Trigger(){
		Gui , % This.Window ": Add" , Picture , % "x" This.X " y" This.Y " w" This.W " h" This.H " 0xE hwndHwnd"
		This.Hwnd:=hwnd
		BD := THIS.Switch_State.BIND( THIS ) 
		GUICONTROL +G , % This.Hwnd , % BD
	}
	Create_Off_Bitmap(){
		;Bitmap Created Using: HB Bitmap Maker
		pBitmap:=Gdip_CreateBitmap( This.W , 19 ) 
		 G := Gdip_GraphicsFromImage( pBitmap )
		Gdip_SetSmoothingMode( G , 2 )
		Brush := Gdip_BrushCreateSolid( This.Background_Color )
		Gdip_FillRectangle( G , Brush , -1 , -1 , This.W+2 , 21 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF313436" )
		Gdip_FillEllipse( G , Brush , 1 , 1 , 17 , 17 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF1A1C1F" )
		Gdip_FillEllipse( G , Brush , 1 , 0 , 17 , 17 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 7 , 1 , 10 , 14 , "0xFF60646A" , "0xFF393B3F" , 1 , 1 )
		Gdip_FillEllipse( G , Brush , 2 , 1 , 15 , 15 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 7 , 2 , 10 , 14 , "0xFF4A4D52" , "0xFF393B3F" , 1 , 1 )
		Gdip_FillEllipse( G , Brush , 3 , 2 , 13 , 13 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF4D5055" )
		Gdip_FillEllipse( G , Brush , 7 , 7 , 5 , 6 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF222325" )
		Gdip_FillEllipse( G , Brush , 7 , 6 , 5 , 5 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( This.FontColor )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c0xFF000000 x22 y-1" , This.Font , This.W-23, This.H )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c" Brush " x23 y0" , This.Font , This.W-23, This.H )
		Gdip_DeleteBrush( Brush )
		Gdip_DeleteGraphics( G )
		This.Off_Bitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
		Gdip_DisposeImage(pBitmap)
	}
	Create_On_Bitmap(){
		;Bitmap Created Using: HB Bitmap Maker
		pBitmap:=Gdip_CreateBitmap( This.W , 19 ) 
		 G := Gdip_GraphicsFromImage( pBitmap )
		Gdip_SetSmoothingMode( G , 2 )
		Brush := Gdip_BrushCreateSolid( This.Background_Color )
		Gdip_FillRectangle( G , Brush , -1 , -1 , This.W+2 , 21 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF484A4B" )
		Gdip_FillEllipse( G , Brush , 1 , 1 , 17 , 17 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF1A1C1F" )
		Gdip_FillEllipse( G , Brush , 1 , 0 , 17 , 17 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF29292F" )
		Gdip_FillEllipse( G , Brush , 2 , 1 , 15 , 15 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 5 , 1 , 10 , 14 , "0xFF2E2F31" , "0xFF333337" , 1 , 1 )
		Gdip_FillEllipse( G , Brush , 3 , 2 , 13 , 13 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF4D5055" )
		Gdip_FillEllipse( G , Brush , 7 , 7 , 5 , 5 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( This.HighLightColor )
		Gdip_FillEllipse( G , Brush , 7 , 6 , 5 , 5 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFFA866E2" )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c0xFF000000 x22 y-1" , This.Font , This.W-23, This.H )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c0xFF000000 x24 y-1" , This.Font , This.W-23, This.H )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c0xFF000000 x22 y1" , This.Font , This.W-23, This.H )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c0xFF000000 x24 y1" , This.Font , This.W-23, This.H )
		Gdip_TextToGraphics( G , This.Text , "s" This.FontSize " vCenter c" Brush " x23 y0" , This.Font , This.W-23, This.H )
		Gdip_DeleteBrush( Brush )
		Gdip_DeleteGraphics( G )
		This.On_Bitmap := Gdip_CreateHBITMAPFromBitmap( pBitmap )
		Gdip_DisposeImage( pBitmap )
	}
	UpdateValue(){
		Loop,% This.GroupArray.Length()	
			if(This.GroupArray[A_Index].State=1){
				lc:=A_Index
				Loop,% This.GroupArray.Length()	
					This.GroupArray[A_Index].Value:=lc
			}
	}
	Switch_State(){
		if(This.State!=1){
			This.State:=1
			This.Draw_On()
			Loop,% This.GroupArray.Length()	{
				if(This.GroupArray[A_Index].Name!=This.Name){
					This.GroupArray[A_Index].State:=0
					This.GroupArray[A_Index].Draw_Off()
				}
			}
			Loop,% This.GroupArray.Length()	{
				if(This.GroupArray[A_Index].State=1){
					This.Value:=A_Index
					break
				}
			}
			Loop,% This.GroupArray.Length()	{
					This.GroupArray[A_Index].Value:=This.Value
			}
		}
	}
	Draw_Off(){
		SetImage( This.Hwnd , This.Off_Bitmap )
	}
	Draw_On(){
		SetImage( This.Hwnd , This.On_Bitmap )
	}
}
HB_Button_Hover(){
	Static Index , Hover_On
	MouseGetPos,,,, ctrl , 2
	if( ! Hover_On && ctrl ){
		loop , % HB_Button.Length()
			if( ctrl = HB_Button[ A_Index ].hwnd )
				HB_Button[ A_Index ].Draw_Hover() , Index := A_Index , Hover_On := 1 , break
	}else if( Hover_On = 1 )
		if( ctrl != HB_Button[ Index ].Hwnd )
			HB_Button[ Index ].Draw_Default() , Hover_On := 0
}
class HB_Flat_Rounded_Button_Type_1	{
	__New( x := 10 , y := 10 , w := 150 , h := 40 , Button_Color := "FF0000" , Button_Background_Color := "222222" , Text := "Button" , Font := "Arial" , Font_Size := 16 , Font_Color_Top := "000000" , Font_Color_Bottom := "FFFFFF" , Window := "1" , Label := "" , Default_Button := 1, Roundness:=5 ){
		This.Roundness:=Roundness,This.Text_Color_Top := "0xFF" Font_Color_Top,This.Text_Color_Bottom := "0xFF" Font_Color_Bottom,This.Font := Font 
		This.Font_Size := Font_Size,This.Text := Text,This.X:=x,This.Y:=y,This.W := w,This.H := h 
		This.Button_Background_Color := "0xFF" Button_Background_Color,This.Button_Color := "0xFF" Button_Color,This.Window := Window,This.Label := Label 
		This.Default_Button := Default_Button,This.Create_Default_Bitmap(),This.Create_Hover_Bitmap(),This.Create_Pressed_Bitmap(),This.Create_Trigger()
		sleep, 20
		This.Draw_Default()
	}
	Create_Trigger(){
		global
		num := HB_Button.Length()+1
		Gui , % This.Window ": Add" , Picture , % "x" This.X " y" This.Y " w" This.W " h" This.H " hwndHwnd v" Num " g" This.Label " 0xE"
		This.Number := Num , This.Hwnd := Hwnd
	}
	Create_Default_Bitmap(){
		;Bitmap Created Using: HB Bitmap Maker
		pBitmap:=Gdip_CreateBitmap( This.W , This.H )
		 G := Gdip_GraphicsFromImage( pBitmap )
		Gdip_SetSmoothingMode( G , 2 )
		Brush := Gdip_BrushCreateSolid( This.Button_Background_Color )
		Gdip_FillRectangle( G , Brush , -1 , -1 , This.W+2 , This.H+2 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xFF61646A" , "0xFF2E2124" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 0 , 1 , This.W , This.H-3 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		if(This.Default_Button)
			Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xFF4C4F54" , "0xFF35373B" , 1 , 1 )
		else 	
			Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , This.Button_Color , "0xFF222222" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 1 , 2 , This.W-2 , This.H-5 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Pen := Gdip_CreatePen( "0xFF000000" , 1 )
		Gdip_DrawRoundedRectangle( G , Pen , 0 , 0 , This.W-1 , This.H-3 , This.Roundness )
		Gdip_DeletePen( Pen )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Bottom )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x1 y2 " , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Top )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x0 y1 " , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Gdip_DeleteGraphics( G )
		This.Default_Bitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
		Gdip_DisposeImage(pBitmap)
	}
	Create_Hover_Bitmap(){
		;Bitmap Created Using: HB Bitmap Maker
		pBitmap:=Gdip_CreateBitmap( This.W , This.H )
		 G := Gdip_GraphicsFromImage( pBitmap )
		Gdip_SetSmoothingMode( G , 2 )
		Brush := Gdip_BrushCreateSolid( This.Button_Background_Color )
		Gdip_FillRectangle( G , Brush , -1 , -1 , This.W+2 , This.H+2 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xFF61646A" , "0xFF2E2124" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 0 , 1 , This.W , This.H-3 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		if(This.Default_Button)
			Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xFF55585D" , "0xFF3B3E41" , 1 , 1 )
		else 
			Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xff620096" , "0xFF333333" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 1 , 2 , This.W-2 , This.H-5 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Pen := Gdip_CreatePen( "0xFF1A1C1F" , 1 )
		Gdip_DrawRoundedRectangle( G , Pen , 0 , 0 , This.W-1 , This.H-3 , This.Roundness )
		Gdip_DeletePen( Pen )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Bottom )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x1 y2" , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Top )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x0 y1" , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Gdip_DeleteGraphics( G )
		This.Hover_Bitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
		Gdip_DisposeImage(pBitmap)
	}
	Create_Pressed_Bitmap(){
		pBitmap:=Gdip_CreateBitmap( This.W , This.H )
		 G := Gdip_GraphicsFromImage( pBitmap )
		Gdip_SetSmoothingMode( G , 2 )
		Brush := Gdip_BrushCreateSolid( This.Button_Background_Color )
		Gdip_FillRectangle( G , Brush , -1 , -1 , This.W+2 , This.H+2 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 0 , 0 , This.W , This.H , "0xFF2A2C2E" , "0xFF45474E" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 0 , 1 , This.W , This.H-3 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF2A2C2E" )
		Gdip_FillRoundedRectangle( G , Brush , 0 , 0 , This.W , This.H-8 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( "0xFF46474D" )
		Gdip_FillRoundedRectangle( G , Brush , 0 , 7 , This.W , This.H-8 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_CreateLineBrushFromRect( 5 , 3 , This.W ,This.H-7 , "0xFF111111" , "0xFF610094" , 1 , 1 )
		Gdip_FillRoundedRectangle( G , Brush , 1 , 2 , This.W-3 , This.H-6 , This.Roundness )
		Gdip_DeleteBrush( Brush )
		Pen := Gdip_CreatePen( "0xFF1A1C1F" , 1 )
		Gdip_DrawRoundedRectangle( G , Pen , 0 , 0 , This.W-1 , This.H-3 , This.Roundness )
		Gdip_DeletePen( Pen )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Bottom )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x1 y3" , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Brush := Gdip_BrushCreateSolid( This.Text_Color_Top )
		Gdip_TextToGraphics( G , This.Text , "s" This.Font_Size " Center vCenter c" Brush " x0 y2" , This.Font , This.W , This.H-1 )
		Gdip_DeleteBrush( Brush )
		Gdip_DeleteGraphics( G )
		This.Pressed_Bitmap := Gdip_CreateHBITMAPFromBitmap( pBitmap )
		Gdip_DisposeImage( pBitmap )
	}
	Draw_Default(){
		SetImage( This.Hwnd , This.Default_Bitmap )
	}
	Draw_Hover(){
		SetImage( This.Hwnd , This.Hover_Bitmap )
	}
	Draw_Pressed(){
		SetImage( This.Hwnd , This.Pressed_Bitmap )
		SetTimer , HB_Button_Hover , Off
		While( GetKeyState( "LButton" ) )
			sleep , 10
		SetTimer , HB_Button_Hover , On
		MouseGetPos,,,, ctrl , 2
		if( This.Hwnd != ctrl ){
			This.Draw_Default()
			return False
		}else	{
			This.Draw_Hover()
			return true
		}
	}
}
Class Custom_Window	{
	__New(x:="",y:="",w:=300,h:=200,Name:=1,Options:="+AlwaysOnTop -Caption -DPIScale",Title:="",Background_Bitmap:=""){
		This.X:=x,This.Y:=y,This.W:=w,This.H:=h,This.Name:=Name,This.Title:=Title,This.Options:=Options,This.Background_Bitmap:=Background_Bitmap,This.Create_Window()
	}
	Create_Window(){
		Gui,% This.Name ":New",%  This.Options " +LastFound"
		This.Hwnd:=WinExist()
		if(This.Background_Bitmap)
			This.Draw_Background_Bitmap()
	}
	Draw_Background_Bitmap(){
		This.Bitmap:=Gdip_CreateHBITMAPFromBitmap(This.Background_Bitmap)
		Gdip_DisposeImage(This.Background_Bitmap)
		Gui,% This.Name ":Add",Picture,% "x0 y0 w" This.W " h" This.H " 0xE hwndhwnd"
		This.Background_Hwnd:=hwnd
		SetImage(This.Background_Hwnd,This.Bitmap)
	}
	Show_Window(){
		if(This.X&&This.Y)
			Gui,% This.Name ":Show",% "x" This.X " y" This.Y " w" This.W " h" This.H,% This.Title
		else if(This.X&&!This.Y)
			Gui,% This.Name ":Show",% "x" This.X  " w" This.W " h" This.H,% This.Title
		else if(!This.X&&This.Y)
			Gui,% This.Name ":Show",% "y" This.Y  " w" This.W " h" This.H,% This.Title
		else
			Gui,% This.Name ":Show",% " w" This.W " h" This.H,% This.Title
	}
}
PixelPredatorBG(){
	;Bitmap Created Using: HB Bitmap Maker
	pBitmap:=Gdip_CreateBitmap( 450 , 300 ) 
	 G := Gdip_GraphicsFromImage( pBitmap )
	Gdip_SetSmoothingMode( G , 4 )
	Brush := Gdip_CreateLineBrush( 66 , 77 , 100 , 100 , "0xFF111111" , "0xFF22005E" , 1 )
	Gdip_FillRectangle( G , Brush , -2 , -2 , 454 , 303 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF252525" )
	Gdip_FillRectangle( G , Brush , 10 , 40 , 430 , 250 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 0 , 0 , 449 , 299 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawRectangle( G , Pen , 10 , 40 , 430 , 250 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_CreateLineBrush( 14 , 9 , 21 , 22 , "0xFF7200AE" , "0xFF010101" , 1 )
	Gdip_FillRectangle( G , Brush , 5 , 5 , 30 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_CreateLineBrush( 154 , 9 , 182 , 47 , "0xFF7200AE" , "0xFF010101" , 1 )
	Gdip_FillRectangle( G , Brush , 85 , 6 , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_CreateLineBrush( 412 , 8 , 418 , 15 , "0xFF7200AE" , "0xFF010101" , 1 )
	Gdip_FillRectangle( G , Brush , 409 , 6 , 15 , 15 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_CreateLineBrush( 433 , 9 , 437 , 16 , "0xFF7200AE" , "0xFF010101" , 1 )
	Gdip_FillRectangle( G , Brush , 429 , 6 , 15 , 15 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 5 , 5 , 30 , 30 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 85 , 6 , 280 , 28 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 409 , 6 , 15 , 15 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 429 , 6 , 15 , 15 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "HB" , "s14 Center vCenter Bold c" Brush " x-5 y-4" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "HB" , "s14 Center vCenter Bold c" Brush " x-4 y-3" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x84 y5" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x85 y5" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x86 y5" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x86 y6" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x85 y6" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x84 y6" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x84 y7" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x85 y7" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x86 y7" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Pixel Predator" , "s16 Center vCenter Bold c" Brush " x85 y6" , "Segoe UI" , 280 , 28 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x392 y-16" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x393 y-16" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x394 y-16" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x394 y-15" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x393 y-15" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x392 y-15" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x392 y-14" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x393 y-14" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x394 y-14" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "_" , "s14 Center vCenter Bold c" Brush " x393 y-15" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x412 y-12" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x413 y-12" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x414 y-12" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x414 y-11" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x413 y-11" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x412 y-11" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x412 y-10" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x413 y-10" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x414 y-10" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "x" , "s14 Center vCenter Bold c" Brush " x413 y-11" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 449 , 0 , 449 , 300 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 0 , 299 , 449 , 299 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 11 , 290 , 440 , 290 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 440 , 40 , 440 , 289 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 35 , 5 , 35 , 35 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 5 , 35 , 35 , 35 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 85 , 34 , 365 , 34 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 365 , 6 , 365 , 34 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 424 , 6 , 424 , 21 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 444 , 6 , 444 , 21 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 429 , 21 , 444 , 21 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 409 , 21 , 424 , 21 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 16 , 45 , 419 , 40 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 45 , 420 , 40 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 16 , 90 , 419 , 40 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 90 , 420 , 40 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 16 , 135 , 159 , 40 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 135 , 160 , 40 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 16 , 180 , 419 , 40 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 180 , 420 , 40 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 85 , 435 , 85 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 130 , 435 , 130 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 175 , 175 , 175 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 220 , 435 , 220 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 435 , 45 , 435 , 84 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 435 , 90 , 435 , 129 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 175 , 135 , 175 , 174 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 435 , 180 , 435 , 219 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 3 )
	Gdip_DrawEllipse( G , Pen , 290 , 12 , 15 , 15 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFFF0F0F0" , 1 )
	Gdip_DrawEllipse( G , Pen , 290 , 12 , 15 , 15 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_FillRectangle( G , Brush , 296 , 7 , 3 , 10 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_FillRectangle( G , Brush , 296 , 22 , 3 , 10 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_FillRectangle( G , Brush , 285 , 18 , 10 , 3 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_FillRectangle( G , Brush , 300 , 18 , 10 , 3 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_FillRectangle( G , Brush , 297 , 8 , 1 , 8 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_FillRectangle( G , Brush , 297 , 23 , 1 , 8 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_FillRectangle( G , Brush , 301 , 19 , 8 , 1 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_FillRectangle( G , Brush , 286 , 19 , 8 , 1 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFff0000" )
	Gdip_FillRectangle( G , Brush , 297 , 19 , 2 , 2 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Var:" , "s12 Center vCenter Bold c" Brush " x319 y41" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFaaaaaa" )
	Gdip_TextToGraphics( G , "Var:" , "s12 Center vCenter Bold c" Brush " x320 y42" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "X:" , "s12 Center vCenter Bold c" Brush " x136 y86" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFaaaaaa" )
	Gdip_TextToGraphics( G , "X:" , "s12 Center vCenter Bold c" Brush " x137 y87" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Y:" , "s12 Center vCenter Bold c" Brush " x206 y86" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFaaaaaa" )
	Gdip_TextToGraphics( G , "Y:" , "s12 Center vCenter Bold c" Brush " x207 y87" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "W:" , "s12 Center vCenter Bold c" Brush " x275 y86" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFaaaaaa" )
	Gdip_TextToGraphics( G , "W:" , "s12 Center vCenter Bold c" Brush " x276 y87" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "H:" , "s12 Center vCenter Bold c" Brush " x345 y86" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFaaaaaa" )
	Gdip_TextToGraphics( G , "H:" , "s12 Center vCenter Bold c" Brush " x346 y87" , "Arial" , 50 , 50 )
	Gdip_DeleteBrush( Brush )
	Gdip_DeleteGraphics( G )
	return pBitmap
}
CommandWindow(){
	;Bitmap Created Using: HB Bitmap Maker
	pBitmap:=Gdip_CreateBitmap( 400 , 500 ) 
	 G := Gdip_GraphicsFromImage( pBitmap )
	Gdip_SetSmoothingMode( G , 4 )
	Brush := Gdip_CreateLineBrush( 49 , 40 , 112 , 82 , "0xFF111111" , "0xFF22005E" , 1 )
	Gdip_FillRectangle( G , Brush , -1 , -1 , 404 , 504 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF252525" )
	Gdip_FillRectangle( G , Brush , 10 , 40 , 380 , 450 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 0 , 0 , 399 , 499 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 10 , 40 , 380 , 450 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 399 , 0 , 399 , 499 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 0 , 499 , 399 , 499 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 390 , 40 , 390 , 490 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 10 , 490 , 390 , 490 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_CreateLineBrush( 76 , 6 , 118 , 59 , "0xFF7100AD" , "0xFF000000" , 1 )
	Gdip_FillRectangle( G , Brush , 50 , 6 , 300 , 29 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 50 , 6 , 300 , 29 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 50 , 35 , 350 , 35 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 350 , 7 , 350 , 34 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x49 y7" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x50 y7" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x51 y7" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x51 y8" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x50 y8" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x49 y8" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x49 y9" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x50 y9" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AE" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x51 y9" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Command Line Format" , "s16 Center vCenter Bold c" Brush " x50 y8" , "Arial" , 300 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 51 , 51 , 298 , 50 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 52 , 52 , 297 , 49 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 52 , 101 , 349 , 101 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 349 , 52 , 349 , 101 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AD" )
	Gdip_TextToGraphics( G , "Format" , "s16 Center vCenter Bold c" Brush " x50 y47" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AD" )
	Gdip_TextToGraphics( G , "Format" , "s16 Center vCenter Bold c" Brush " x52 y47" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AD" )
	Gdip_TextToGraphics( G , "Format" , "s16 Center vCenter Bold c" Brush " x52 y49" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7200AD" )
	Gdip_TextToGraphics( G , "Format" , "s16 Center vCenter Bold c" Brush " x50 y49" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Format" , "s16 Center vCenter Bold c" Brush " x51 y48" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "_________" , "s16 Center vCenter Bold c" Brush " x51 y50" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x50 y70" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x51 y70" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x52 y70" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x52 y71" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x51 y71" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x50 y71" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x50 y72" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x51 y72" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x52 y72" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "*1*2*3*4*5*6*7*8*9*10" , "s16 Center vCenter Bold c" Brush " x51 y71" , "Segoe UI" , 298 , 30 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 20 , 106 , 360 , 304 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawRectangle( G , Pen , 20 , 106 , 360 , 304 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 20 , 106 , 379 , 106 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 20 , 106 , 20 , 409 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 136 , 359 , 136 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 166 , 359 , 166 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 196 , 359 , 196 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 226 , 359 , 226 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 256 , 359 , 256 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 286 , 359 , 286 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 316 , 359 , 316 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 346 , 359 , 346 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 346 , 359 , 346 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 316 , 359 , 316 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 286 , 359 , 286 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 256 , 359 , 256 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 226 , 359 , 226 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 196 , 359 , 196 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 166 , 359 , 166 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 136 , 359 , 136 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF7000AC" , 3 )
	Gdip_DrawLine( G , Pen , 41 , 376 , 359 , 376 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 41 , 376 , 359 , 376 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*1*" , "s16 Center vCenter Bold c" Brush " x-7 y98" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*1*" , "s16 Center vCenter Bold c" Brush " x-5 y98" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*1*" , "s16 Center vCenter Bold c" Brush " x-5 y100" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*1*" , "s16 Center vCenter Bold c" Brush " x-7 y100" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*1*" , "s16 Center vCenter Bold c" Brush " x-6 y99" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*2*" , "s16 Center vCenter Bold c" Brush " x-7 y128" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*2*" , "s16 Center vCenter Bold c" Brush " x-5 y128" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*2*" , "s16 Center vCenter Bold c" Brush " x-5 y130" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*2*" , "s16 Center vCenter Bold c" Brush " x-7 y130" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*2*" , "s16 Center vCenter Bold c" Brush " x-6 y129" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*3*" , "s16 Center vCenter Bold c" Brush " x-7 y158" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*3*" , "s16 Center vCenter Bold c" Brush " x-5 y158" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*3*" , "s16 Center vCenter Bold c" Brush " x-5 y160" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*3*" , "s16 Center vCenter Bold c" Brush " x-7 y160" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*3*" , "s16 Center vCenter Bold c" Brush " x-6 y159" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*4*" , "s16 Center vCenter Bold c" Brush " x-7 y188" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*4*" , "s16 Center vCenter Bold c" Brush " x-5 y188" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*4*" , "s16 Center vCenter Bold c" Brush " x-5 y190" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*4*" , "s16 Center vCenter Bold c" Brush " x-7 y190" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*4*" , "s16 Center vCenter Bold c" Brush " x-6 y189" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*5*" , "s16 Center vCenter Bold c" Brush " x-7 y218" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*5*" , "s16 Center vCenter Bold c" Brush " x-5 y218" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*5*" , "s16 Center vCenter Bold c" Brush " x-5 y220" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*5*" , "s16 Center vCenter Bold c" Brush " x-7 y220" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*5*" , "s16 Center vCenter Bold c" Brush " x-6 y219" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*6*" , "s16 Center vCenter Bold c" Brush " x-7 y248" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*6*" , "s16 Center vCenter Bold c" Brush " x-5 y248" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*6*" , "s16 Center vCenter Bold c" Brush " x-5 y250" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*6*" , "s16 Center vCenter Bold c" Brush " x-7 y250" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*6*" , "s16 Center vCenter Bold c" Brush " x-6 y249" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*7*" , "s16 Center vCenter Bold c" Brush " x-7 y278" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*7*" , "s16 Center vCenter Bold c" Brush " x-5 y278" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*7*" , "s16 Center vCenter Bold c" Brush " x-5 y280" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*7*" , "s16 Center vCenter Bold c" Brush " x-7 y280" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*7*" , "s16 Center vCenter Bold c" Brush " x-6 y279" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*8*" , "s16 Center vCenter Bold c" Brush " x-7 y308" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*8*" , "s16 Center vCenter Bold c" Brush " x-5 y308" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*8*" , "s16 Center vCenter Bold c" Brush " x-5 y310" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*8*" , "s16 Center vCenter Bold c" Brush " x-7 y310" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*8*" , "s16 Center vCenter Bold c" Brush " x-6 y309" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*9*" , "s16 Center vCenter Bold c" Brush " x-7 y338" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*9*" , "s16 Center vCenter Bold c" Brush " x-5 y338" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*9*" , "s16 Center vCenter Bold c" Brush " x-5 y340" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*9*" , "s16 Center vCenter Bold c" Brush " x-7 y340" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*9*" , "s16 Center vCenter Bold c" Brush " x-6 y339" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*10" , "s16 Center vCenter Bold c" Brush " x-7 y368" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*10" , "s16 Center vCenter Bold c" Brush " x-5 y368" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*10" , "s16 Center vCenter Bold c" Brush " x-5 y370" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "*10" , "s16 Center vCenter Bold c" Brush " x-7 y370" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "*10" , "s16 Center vCenter Bold c" Brush " x-6 y369" , "Arial" , 90 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Turn On/Off Search Loop ( 1: Loop , 0: Find Once )" , "s12  vCenter Bold c" Brush " x69 y97" , "Arial" , 300 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Turn On/Off Search Loop ( 1: Loop , 0: Find Once )" , "s12  vCenter Bold c" Brush " x70 y98" , "Arial" , 300 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Click or Move ( 0: Move , 1: Click )" , "s12  vCenter Bold c" Brush " x69 y127" , "Arial" , 300 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Click or Move ( 0: Move , 1: Click )" , "s12  vCenter Bold c" Brush " x70 y128" , "Arial" , 300 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Number of Clicks Per Loop (Range: 1+)(*See Below)" , "s12  vCenter Bold c" Brush " x69 y157" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Number of Clicks Per Loop (Range: 1+)(*See Below)" , "s12  vCenter Bold c" Brush " x70 y158" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "X-Offset (Click & Move)" , "s12  vCenter Bold c" Brush " x69 y187" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "X-Offset (Click & Move)" , "s12  vCenter Bold c" Brush " x70 y188" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Y-Offset (Click & Move)" , "s12  vCenter Bold c" Brush " x69 y217" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Y-Offset (Click & Move)" , "s12  vCenter Bold c" Brush " x70 y218" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Which Mouse Button to use  (Values: L , M , R )" , "s12  vCenter Bold c" Brush " x69 y247" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Which Mouse Button to use  (Values: L , M , R )" , "s12  vCenter Bold c" Brush " x70 y248" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Amount of time a click is held (in ms)" , "s12  vCenter Bold c" Brush " x69 y277" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Amount of time a click is held (in ms)" , "s12  vCenter Bold c" Brush " x70 y278" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Amount of time between key strokes (in ms)" , "s12  vCenter Bold c" Brush " x69 y307" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Amount of time between key strokes (in ms)" , "s12  vCenter Bold c" Brush " x70 y308" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Loop Delay (Delay between Search Loops (in ms))" , "s12  vCenter Bold c" Brush " x69 y337" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Loop Delay (Delay between Search Loops (in ms))" , "s12  vCenter Bold c" Brush " x70 y338" , "Arial" , 330 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Commands to ""send"" (e.g. {Enter} r) See Documentation For List of values" , "s12  vCenter Bold c" Brush " x69 y370" , "Arial" , 240 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Commands to ""send"" (e.g. {Enter} r) See Documentation For List of values" , "s12  vCenter Bold c" Brush " x70 y371" , "Arial" , 240 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Set *2*3* both to a value of 0 to disable Click and Move" , "s12  vCenter Bold c" Brush " x31 y400" , "Arial" , 400 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Set *2*3* both to a value of 0 to disable Click and Move" , "s12  vCenter Bold c" Brush " x33 y400" , "Arial" , 400 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Set *2*3* both to a value of 0 to disable Click and Move" , "s12  vCenter Bold c" Brush " x33 y402" , "Arial" , 400 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Set *2*3* both to a value of 0 to disable Click and Move" , "s12  vCenter Bold c" Brush " x31 y402" , "Arial" , 400 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFff0000" )
	Gdip_TextToGraphics( G , "Set *2*3* both to a value of 0 to disable Click and Move" , "s12  vCenter Bold c" Brush " x32 y401" , "Arial" , 400 , 50 )
	Gdip_DeleteBrush( Brush )
	Gdip_DeleteGraphics( G )
	return pBitmap
}
HotkeyWindow(){
	;Bitmap Created Using: HB Bitmap Maker
	pBitmap:=Gdip_CreateBitmap( 300 , 250 ) 
	 G := Gdip_GraphicsFromImage( pBitmap )
	Gdip_SetSmoothingMode( G , 4 )
	Brush := Gdip_CreateLineBrush( 19 , 15 , 52 , 59 , "0xFF22005D" , "0xFF111111" , 1 )
	Gdip_FillRectangle( G , Brush , -1 , -1 , 303 , 253 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF252525" )
	Gdip_FillRectangle( G , Brush , 10 , 40 , 279 , 200 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawRectangle( G , Pen , 0 , 0 , 299 , 249 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawRectangle( G , Pen , 10 , 40 , 279 , 200 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 299 , 0 , 299 , 249 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawLine( G , Pen , 0 , 249 , 299 , 249 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 289 , 40 , 289 , 239 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 11 , 240 , 289 , 240 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 2 )
	Gdip_DrawRectangle( G , Pen , 50 , 6 , 199 , 25 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF000000" , 2 )
	Gdip_DrawRectangle( G , Pen , 51 , 7 , 199 , 25 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_CreateLineBrush( 74 , 15 , 86 , 39 , "0xFF7100AD" , "0xFF000000" , 1 )
	Gdip_FillRectangle( G , Brush , 50 , 6 , 200 , 26 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x49 y-5" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x50 y-5" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x51 y-5" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x51 y-4" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x50 y-4" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x49 y-4" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x49 y-3" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x50 y-3" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x51 y-3" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Hotkeys & Info" , "s16 Center vCenter Bold c" Brush " x50 y-4" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 15 , 45 , 270 , 70 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Info" , "s12 Center vCenter Bold c" Brush " x49 y32" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Info" , "s12 Center vCenter Bold c" Brush " x51 y32" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Info" , "s12 Center vCenter Bold c" Brush " x51 y34" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFF0F0F0" )
	Gdip_TextToGraphics( G , "Info" , "s12 Center vCenter Bold c" Brush " x49 y34" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Info" , "s12 Center vCenter Bold c" Brush " x50 y33" , "Arial" , 200 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Written By:           Hellbent aka CivReborn" , "s10  vCenter Bold c" Brush " x48 y48" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFffffff" )
	Gdip_TextToGraphics( G , "Written By:           Hellbent aka CivReborn" , "s10  vCenter Bold c" Brush " x50 y50" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "Date:                     June 3rd, 2019" , "s10  vCenter Bold c" Brush " x48 y63" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFffffff" )
	Gdip_TextToGraphics( G , "Date:                     June 3rd, 2019" , "s10  vCenter Bold c" Brush " x50 y65" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF000000" )
	Gdip_TextToGraphics( G , "All Rights Reserved" , "s10  vCenter Bold c" Brush " x108 y80" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFFffffff" )
	Gdip_TextToGraphics( G , "All Rights Reserved" , "s10  vCenter Bold c" Brush " x110 y82" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 45 , 270 , 70 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 45 , 15 , 114 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 45 , 284 , 45 )
	Gdip_DeletePen( Pen )
	Brush := Gdip_BrushCreateSolid( "0xFF333333" )
	Gdip_FillRectangle( G , Brush , 15 , 120 , 270 , 70 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Start:" , "s12  vCenter Bold c" Brush " x19 y111" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Start:" , "s12  vCenter Bold c" Brush " x21 y111" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Start:" , "s12  vCenter Bold c" Brush " x21 y113" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Start:" , "s12  vCenter Bold c" Brush " x19 y113" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Start:" , "s12  vCenter Bold c" Brush " x20 y112" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Stop:" , "s12  vCenter Bold c" Brush " x19 y146" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Stop:" , "s12  vCenter Bold c" Brush " x21 y146" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Stop:" , "s12  vCenter Bold c" Brush " x21 y148" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF7000AC" )
	Gdip_TextToGraphics( G , "Stop:" , "s12  vCenter Bold c" Brush " x19 y148" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Brush := Gdip_BrushCreateSolid( "0xFF999999" )
	Gdip_TextToGraphics( G , "Stop:" , "s12  vCenter Bold c" Brush " x20 y147" , "Arial" , 250 , 50 )
	Gdip_DeleteBrush( Brush )
	Pen := Gdip_CreatePen( "0xFF000000" , 1 )
	Gdip_DrawRectangle( G , Pen , 15 , 120 , 270 , 70 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 120 , 15 , 189 )
	Gdip_DeletePen( Pen )
	Pen := Gdip_CreatePen( "0xFF777777" , 1 )
	Gdip_DrawLine( G , Pen , 15 , 120 , 284 , 120 )
	Gdip_DeletePen( Pen )
	Gdip_DeleteGraphics( G )
	return pBitmap
}
New_Brush(colour:="000000",Alpha:="FF"){
	new_colour := "0x" Alpha colour 
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", new_colour, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff){
    return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}
Fill_Box(pGraphics,pBrush,x,y,w,h)	{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillRectangle", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")
	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
	return DllCall("UpdateLayeredWindow", Ptr, hwnd, Ptr, 0, Ptr, ((x = "") && (y = "")) ? 0 : &pt, "int64*", w|h<<32, Ptr, hdc, "int64*", 0, "uint", 0, "UInt*", Alpha<<16|1<<24, "uint", 2)
}
BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster=""){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdi32\BitBlt", Ptr, dDC, "int", dx, "int", dy, "int", dw, "int", dh, Ptr, sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}
Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	if(sx = "" && sy = "" && sw = "" && sh = ""){
		if(dx = "" && dy = "" && dw = "" && dh = ""){
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}else	{
			sx := sy := 0,sw := Gdip_GetImageWidth(pBitmap),sh := Gdip_GetImageHeight(pBitmap)
		}
	}
	E := DllCall("gdiplus\GdipDrawImageRectRect", Ptr, pGraphics, Ptr, pBitmap, "float", dx, "float", dy, "float", dw, "float", dh, "float", sx, "float", sy, "float", sw, "float", sh, "int", 2, Ptr, ImageAttr, Ptr, 0, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}
Gdip_SetImageAttributesColorMatrix(Matrix){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}
Gdip_GetImageWidth(pBitmap){
   DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
   return Width
}
Gdip_GetImageHeight(pBitmap){
   DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
   return Height
}
Gdip_DeletePen(pPen){
   return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}
Gdip_DeleteBrush(pBrush){
   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}
Gdip_DisposeImage(pBitmap){
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}
Gdip_DeleteGraphics(pGraphics){
   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr){
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}
Gdip_DeleteFont(hFont){
   return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}
Gdip_DeleteStringFormat(hFormat){
   return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}
Gdip_DeleteFontFamily(hFamily){
   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}
CreateCompatibleDC(hdc=0){
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
SelectObject(hdc, hgdiobj){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}
DeleteObject(hObject){
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}
GetDC(hwnd=0){
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}
GetDCEx(hwnd, flags=0, hrgnClip=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
    return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}
DeleteDC(hdc){
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4, "uint"), NumPut(h, bi, 8, "uint"), NumPut(40, bi, 0, "uint"), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16, "uInt"), NumPut(bpp, bi, 14, "ushort")
	hbm := DllCall("CreateDIBSection", Ptr, hdc2, Ptr, &bi, "uint", 0, A_PtrSize ? "UPtr*" : "uint*", ppvBits, Ptr, 0, "uint", 0, Ptr)
	if !hdc
		ReleaseDC(hdc2)
	return hbm
}
Gdip_GraphicsFromImage(pBitmap){
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}
Gdip_GraphicsFromHDC(hdc){
    DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
    return pGraphics
}
Gdip_GetDC(pGraphics){
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}
Gdip_Startup(){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0){
	IWidth := Width, IHeight:= Height
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)
	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1
	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}
	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12
	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}
	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)
	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}
Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	return DllCall("gdiplus\GdipDrawString", Ptr, pGraphics, Ptr, A_IsUnicode ? &sString : &wString, "int", -1, Ptr, hFont, Ptr, &RectF, Ptr, hFormat, Ptr, pBrush)
}
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", Ptr, &PointF1, Ptr, &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1){
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}
Gdip_CloneBrush(pBrush){
	DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
	return pBrushClone
}
Gdip_FontFamilyCreate(Font){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, Ptr, &wFont, "int", nSize)
	}
	DllCall("gdiplus\GdipCreateFontFamilyFromName", Ptr, A_IsUnicode ? &Font : &wFont, "uint", 0, A_PtrSize ? "UPtr*" : "UInt*", hFamily)
	return hFamily
}
Gdip_SetStringFormatAlign(hFormat, Align){
   return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}
Gdip_StringFormatCreate(Format=0, Lang=0){
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
   return hFormat
}
Gdip_FontCreate(hFamily, Size, Style=0){
   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
   return hFont
}
Gdip_CreatePen(ARGB, w){
   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
   return pPen
}
Gdip_CreatePenFromBrush(pBrush, w){
	DllCall("gdiplus\GdipCreatePen2", A_PtrSize ? "UPtr" : "UInt", pBrush, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	return pPen
}
Gdip_BrushCreateSolid(ARGB=0xff000000){
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0){
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}
CreateRectF(ByRef RectF, x, y, w, h){
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint){
	return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
}
Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	DllCall("gdiplus\GdipMeasureString", Ptr, pGraphics, Ptr, A_IsUnicode ? &sString : &wString, "int", -1, Ptr, hFont, Ptr, &RectF, Ptr, hFormat, Ptr, &RC, "uint*", Chars, "uint*", Lines)
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
CreateRect(ByRef Rect, x, y, w, h){
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
CreateSizeF(ByRef SizeF, w, h){
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}
CreatePointF(ByRef PointF, x, y){
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}
Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipDrawArc", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipDrawPie", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipDrawLine", Ptr, pGraphics, Ptr, pPen, "float", x1, "float", y1, "float", x2, "float", y2)
}
Gdip_DrawLines(pGraphics, pPen, Points){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipDrawLines", Ptr, pGraphics, Ptr, pPen, Ptr, &PointF, "int", Points0)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillRectangle", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r){
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}
Gdip_GetClipRegion(pGraphics){
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt*", Region)
	return Region
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0){
   return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_SetClipPath(pGraphics, Path, CombineMode=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipPath", Ptr, pGraphics, Ptr, Path, "int", CombineMode)
}
Gdip_ResetClip(pGraphics){
   return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRegion(pGraphics, pBrush, Region){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillRegion", Ptr, pGraphics, Ptr, pBrush, Ptr, Region)
}
Gdip_FillPath(pGraphics, pBrush, Path){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipFillPath", Ptr, pGraphics, Ptr, pBrush, Ptr, Path)
}
Gdip_CreateRegion(){
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	return Region
}
Gdip_DeleteRegion(Region){
	return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}
Gdip_CreateBitmap(Width, Height, Format=0x26200A){
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
    Return pBitmap
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode){
   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r){
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipDrawEllipse", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff){
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hbm, "int", Background)
	return hbm
}
SetImage(hwnd, hBitmap){
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}
Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0){
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipFillPolygon", Ptr, pGraphics, Ptr, pBrush, Ptr, &PointF, "int", Points0, "int", FillMode)
}