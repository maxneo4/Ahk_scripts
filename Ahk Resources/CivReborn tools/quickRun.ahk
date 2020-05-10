#SingleInstance,Force
SetWorkingDir,%A_ScriptDir%
Coordmode,Mouse,Screen
;Color settings list
Global Color_Setting_List:= ["Red","Green","Aqua","Teal","Yellow","Blue","Silver"]

Global Changing_Settings_Active:=0

;Themes
Global Dock_Text_Theme:={}
Dock_Text_Theme[1]:={1:"Teal",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Text_Theme[2]:={1:"Yellow",2:"Yellow",3:"Yellow",4:"Yellow",5:"Yellow",6:"Yellow",7:"Yellow"}
Dock_Text_Theme[3]:={1:"Blue",2:"Blue",3:"Blue",4:"Blue",5:"Blue",6:"Blue",7:"Blue"}
Dock_Text_Theme[4]:={1:"Red",2:"Red",3:"Red",4:"Red",5:"Red",6:"Red",7:"Red"}
Dock_Text_Theme[5]:={1:"Maroon",2:"Maroon",3:"Maroon",4:"Maroon",5:"Maroon",6:"Maroon",7:"Maroon"}
Dock_Text_Theme[6]:={1:"Green",2:"Green",3:"Green",4:"Green",5:"Green",6:"Green",7:"Green"}
Dock_Text_Theme[7]:={1:"Purple",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Text_Theme[8]:={1:"Silver",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Text_Theme[9]:={1:"White",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Text_Theme[10]:={1:"White",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Global Dock_Trim_Theme:={}
Dock_Trim_Theme[1]:={1:"Teal",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[2]:={1:"Yellow",2:"Yellow",3:"Yellow",4:"Yellow",5:"Yellow",6:"Yellow",7:"Yellow"}
Dock_Trim_Theme[3]:={1:"Blue",2:"Blue",3:"Blue",4:"Blue",5:"Blue",6:"Blue",7:"Blue"}
Dock_Trim_Theme[4]:={1:"Red",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[5]:={1:"Maroon",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[6]:={1:"Green",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[7]:={1:"Purple",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[8]:={1:"Silver",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[9]:={1:"White",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Dock_Trim_Theme[10]:={1:"White",2:"Teal",3:"Teal",4:"Teal",5:"Teal",6:"Teal",7:"Teal"}
Global Dock_Theme:={}
Dock_Theme[1]:={Master_Text:"Silver",Master_Trim:"Teal",1:"Yellow",2:"Purple",3:"Teal",4:"Blue",5:"Red",6:"Aqua",7:"Green",8:"Purple",9:"Aqua",10:"Purple",11:"Silver",12:"Gray"}
IfNotExist,Dock It v0.0.1.ini
	{
		Gui,Loading_Progress:Destroy
		Gui,Loading_Progress:+AlwaysOnTop -Caption +Owner +Border
		Gui,Loading_Progress:Color,Black
		Gui,Loading_Progress:Add,Text,cWhite x5 y3 w70 ,Building Profile
		Gui,Loading_Progress:Add,Progress,x+5 y5 w50 h10 BackgroundBlack cMaroon Range0-9 vLoading_Value Border,1
		Gui,Loading_Progress:Show, w140 h20
		
		;Docks
		dck:=1
		Loop 9
			{
				Loop 60
					{
						blank :=""
						IniWrite,%blank%,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Name ;UnNamed Button %A_Index%
						IniWrite,Empty,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Program
						IniWrite,Empty,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Notes
					}
				dck++
				GuiControl,Loading_Progress:,Loading_Value,% dck
			}
		dck:=1	
		Loop 9
			{
				colll:=1
				loop 7
					{
						IniWrite,Teal,Dock It v0.0.1.ini,Dock %dck% Trim Theme Info,Col %colll%
						IniWrite,Silver,Dock It v0.0.1.ini,Dock %dck% Text Theme Info,Col %colll%
						colll++
					}
				Loop 6
					{
						;~ tttpt:="Column" %A_Index% "`n Dock" %dck%
						IniWrite,Column %A_Index%,Dock It v0.0.1.ini,Dock %dck% Column Name Info,Col %A_Index%
					}
				dck++	
			}
		;master
		IniWrite,Teal,Dock It v0.0.1.ini,Master Info,Text Theme
		IniWrite,Teal,Dock It v0.0.1.ini,Master Info,Trim Theme
		Loop 9
			{
				IniWrite,UnNamed Dock %A_Index%,Dock It v0.0.1.ini,Master Info,Dock %A_Index% Name
			}
		Gui,Loading_Progress:Destroy
	}
	
;Loading Profile
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
Global Dock_Names:=[]
Loop 9
	{
		IniRead,temp,Dock It v0.0.1.ini,Master Info,Dock %A_Index% Name
		Dock_Names[A_Index]:=temp
	}
Gui,Loading_Progress:Destroy
Gui,Loading_Progress:+AlwaysOnTop -Caption +Owner +Border
Gui,Loading_Progress:Color,Black
Gui,Loading_Progress:Add,Text,cWhite x5 y3 w70 ,Loading Profile
Gui,Loading_Progress:Add,Progress,x+5 y5 w50 h10 BackgroundBlack cMaroon Range0-540 vLoading_Value Border,0
Gui,Loading_Progress:Show, w140 h20 	
global Dock_1_Button_Name:={},Dock_2_Button_Name:={},Dock_3_Button_Name:={},Dock_4_Button_Name:={},Dock_5_Button_Name:={}
global Dock_6_Button_Name:={},Dock_7_Button_Name:={},Dock_8_Button_Name:={},Dock_9_Button_Name:={}
global Dock_1_Button_Program:={},Dock_2_Button_Program:={},Dock_3_Button_Program:={},Dock_4_Button_Program:={},Dock_5_Button_Program:={}
global Dock_6_Button_Program:={},Dock_7_Button_Program:={},Dock_8_Button_Program:={},Dock_9_Button_Program:={}
global Dock_1_Button_Notes:={},Dock_2_Button_Notes:={},Dock_3_Button_Notes:={},Dock_4_Button_Notes:={},Dock_5_Button_Notes:={}
global Dock_6_Button_Notes:={},Dock_7_Button_Notes:={},Dock_8_Button_Notes:={},Dock_9_Button_Notes:={}
global Column_Name_1:={},Column_Name_2:={},Column_Name_3:={},Column_Name_4:={},Column_Name_5:={}
global Column_Name_6:={},Column_Name_7:={},Column_Name_8:={},Column_Name_9:={}
dck:=1
o:=1
Loop 9
	{
		colll:=1
		loop 7
			{
				IniRead,tem1,Dock It v0.0.1.ini,Dock %dck% Trim Theme Info,Col %colll%
				IniRead,tem2,Dock It v0.0.1.ini,Dock %dck% Text Theme Info,Col %colll%
				Dock_Text_Theme[dck][colll]:=tem2
				Dock_Trim_Theme[dck][colll]:=tem1
				colll++
			}
		Loop 6
			{
				IniRead,tem4,Dock It v0.0.1.ini,Dock %dck% Column Name Info,Col %A_Index%
				Column_Name_%dck%[A_Index]:=tem4
				;~ msgbox, % Column_Name_%dck%[A_Index]
			}	
		Loop,60
			{
				IniRead,tem1,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Name
				IniRead,tem2,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Program
				IniRead,tem3,Dock It v0.0.1.ini,Dock %dck% Info,Button %A_Index% Notes
				Dock_%dck%_Button_Name[A_Index]:=tem1
				Dock_%dck%_Button_Program[A_Index]:=tem2
				Dock_%dck%_Button_Notes[A_Index]:=tem3
				o++
				GuiControl,Loading_Progress:,Loading_Value,% o
			}
			
		dck++	
	}
Gui,Loading_Progress:Destroy


;~ msgbox, % Column_Name_1[5]

;other variables
Global Expanded_Window:=0,Lock_It:=0,Dock_Open:=0,Instant_Slide:=0,Dock_Close:=0,Lock_It:=0,Current_Dock:=0

;Theme Colors
Global THBC:="Teal",TTTC:="Silver"






;Gui 3 & 4 variables
Global Dock_Launcher_X:=-137,Dock_Launcher_W:=150,Dock_Launcher_H:=600,Dock_Launcher_Y:=((A_ScreenHeight//2)-(Dock_Launcher_H//2))
,DBC:=11,i:=1



;Gui 1 & 2 Variables
Global Dock_X:=-990 ,Dock_Y:=Dock_Launcher_Y+20 ,Dock_W:=990 ,Dock_H:=Dock_Launcher_H-40



Build_Gui_1_2()

Build_Gui_3_4()

SetTimer,Watch_Docks,10

return
GuiClose:
	ExitApp
3GuiContextMenu:
4GuiContextMenu:
	Lock_It:=!Lock_It
	if(Lock_It)
		GuiControl,3:+BackgroundMaroon,Slide_Lock
	else
		GuiControl,3:+Background008844,Slide_Lock
	return	
Adjust_Dock_Settings:
	if(Changing_Settings_Active!=1){
		Sample_Trim:="Teal"
		Sample_Text:="Teal"
		Object_To_Change:=1
		Setting_Custom_Color1:="00ff00"
		Box_1:=1
		Text_Color_Var:="Teal",Trim_Color_Var:="Teal"
		Gui,Dock_Settings1:Destroy
		Gui,Dock_Settings2:Destroy
		Gui,Dock_Settings1:+AlwaysOnTop -Caption +Border +Owner
		Gui,Dock_Settings2:+AlwaysOnTop -Caption +Border +OwnerDock_Settings1 +LastFound
		Winset,Transparent,1
		Settings_Color_List:=["Maroon","Red","Fuchsia","Purple","Yellow","Lime","Green","Olive","Teal","Aqua","Blue","Navy","Gray","Silver","White","00ff00"]
		Gui,Dock_Settings2:Color,Yellow
		Gui,Dock_Settings1:Color,Black,Black

		Gui,Dock_Settings1:Add,Progress,x0 y0 w400 h300 BackgroundTeal c111111,100

		Gui,Dock_Settings1:Add,Progress,x100 y5 w200 h40 Background%Sample_Trim% c111111 vSamp_Trim,100

		Gui,Dock_Settings1:Add,Progress,x120 y10 w160 h30 BackGroundBlack
		Gui,Dock_Settings1:Add,Progress,x120 y10 w159 h29 BackGround%Sample_Trim% vSamp_Trim2
		Gui,Dock_Settings1:Add,Progress,x121 y11 w158 h28 BackGround222222 vSamp_Background
		Gui,Dock_Settings1:Font,c%Sample_Text% s8 Bold Q5,Khmer UI
		Gui,Dock_Settings1:Add,Text,x121 y17 w158 r1 Center BackgroundTrans vSamp_Text,Sample Text


		Gui,Dock_Settings1:Add,Progress,x10 y50 w380 h90 BackgroundTeal c111111,100

		Gui,Dock_Settings1:Add,Progress,% "x15 y60 w20 h20 BackgroundBlack c"Settings_Color_List[1],100
		Loop 14
			{
				Gui,Dock_Settings1:Add,Progress,% "x+5 y60 w20 h20 BackgroundBlack c"Settings_Color_List[A_Index+1],100
			}
		Gui,Dock_Settings1:Add,Progress,x30 yp+30 w340 h40 BackgroundTeal c111111,100
		Gui,Dock_Settings1:Add,Progress, x80 yp+10 w20 h20 BackgroundBlack c00ff00 vCustom_Color_Preview1,100
		Gui,Dock_Settings1:Add,Text,x+20 yp+4 BackgroundTrans ,Custom Color:
		Gui,Dock_Settings1:Add,Edit,x+10 yp-3 w100 r1 vSetting_Custom_Color1 gChange_Custom_Color1,00ff00

		Gui,Dock_Settings1:Add,Progress,x10 y150 w120 h60 BackgroundTeal c111111 ,100 
		Gui,Dock_Settings1:Add,Progress,x25 y160 w15 h15 BackgroundBlack cTeal vText_Radio1 ,100
		Gui,Dock_Settings1:Add,Text,x+10 w100 BackgroundTrans,Text Color
		Gui,Dock_Settings1:Add,Progress,x25 y185 w15 h15 BackgroundBlack cSilver vTrim_Radio1 ,100
		Gui,Dock_Settings1:Add,Text,x+10 w100 BackgroundTrans,Trim Color

		Gui,Dock_Settings1:Add,Progress,x140 y150 w250 h140 BackgroundTeal c111111,100

		Gui,Dock_Settings1:Add,Progress,x150 y170 w15 h15 BackgroundBlack cTeal vGroup_Radio_1,100
		Gui,Dock_Settings1:Add,Text,x180 y170 w80 BackgroundTrans ,Select All
		Gui,Dock_Settings1:Add,Progress,x280 y170 w15 h15 BackgroundBlack cSilver vGroup_Radio_2,100
		Gui,Dock_Settings1:Add,Text,x310 y170 w80 BackgroundTrans ,Master

		Gui,Dock_Settings1:Add,Progress,x150 y200 w15 h15 BackgroundBlack cSilver vGroup_Radio_3,100
		Gui,Dock_Settings1:Add,Text,x180 y200 w80 BackgroundTrans ,Column 1
		Gui,Dock_Settings1:Add,Progress,x280 y200 w15 h15 BackgroundBlack cSilver vGroup_Radio_4,100
		Gui,Dock_Settings1:Add,Text,x310 y200 w80 BackgroundTrans ,Column 2

		Gui,Dock_Settings1:Add,Progress,x150 y230 w15 h15 BackgroundBlack cSilver vGroup_Radio_5,100
		Gui,Dock_Settings1:Add,Text,x180 y230 w80 BackgroundTrans ,Column 3
		Gui,Dock_Settings1:Add,Progress,x280 y230 w15 h15 BackgroundBlack cSilver vGroup_Radio_6,100
		Gui,Dock_Settings1:Add,Text,x310 y230 w80 BackgroundTrans ,Column 4

		Gui,Dock_Settings1:Add,Progress,x150 y260 w15 h15 BackgroundBlack cSilver vGroup_Radio_7,100
		Gui,Dock_Settings1:Add,Text,x180 y260 w80 BackgroundTrans ,Column 5
		Gui,Dock_Settings1:Add,Progress,x280 y260 w15 h15 BackgroundBlack cSilver vGroup_Radio_8,100
		Gui,Dock_Settings1:Add,Text,x310 y260 w80 BackgroundTrans ,Column 6
		
		Gui,Dock_Settings1:Add,Progress,x10 y220 w120 h30 BackgroundBlack
		Gui,Dock_Settings1:Add,Progress,x10 y220 w119 h29 BackgroundTeal
		Gui,Dock_Settings1:Add,Progress,x11 y221 w118 h28 Background222222
		Gui,Dock_Settings1:Add,Text,x11 y227 w118 r1 BackgroundTrans Center,Update

		Gui,Dock_Settings1:Add,Progress,x10 y260 w120 h30 BackgroundBlack
		Gui,Dock_Settings1:Add,Progress,x10 y260 w119 h29 BackgroundTeal
		Gui,Dock_Settings1:Add,Progress,x11 y261 w118 h28 Background222222
		Gui,Dock_Settings1:Add,Text,x11 y267 w118 r1 BackgroundTrans Center,Exit
		
		Gui,Dock_Settings2:Add,text,x20 y0 w360 h40 Border gMove_Settings_Window
		Gui,Dock_Settings2:Add,Text,x15 y60 w20 h20 Border vColor_Select_Var_1 gSet_New_Color
		cs:=2
		Loop 14
			{
				Gui,Dock_Settings2:Add,Text,x+5 y60 w20 h20 Border vColor_Select_Var_%cs% gSet_New_Color
				cs++
			}
		Gui,Dock_Settings2:Add,Text,x80 y100 w20 h20 Border vColor_Select_Var_16 gSet_New_Color
		Gui,Dock_Settings2:Add,Text,x205 y100 w100 h22 Border gFocus_Setting_Custom_Color1
		
		
		
		
		Gui,Dock_Settings2:Add,Text,x25 y160 w100 h15 Border vText_Radio2 gColor_Options_Radios
		Gui,Dock_Settings2:Add,Text,x25 y185 w100 h15 Border vTrim_Radio2 gColor_Options_Radios
		
		
		Gui,Dock_Settings2:Add,Text,x150 y170 w100 Border vBox_1 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x280 y170 w100 Border vBox_2 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x150 y200 w100 Border vBox_3 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x280 y200 w100 Border vBox_4 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x150 y230 w100 Border vBox_5 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x280 y230 w100 Border vBox_6 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x150 y260 w100 Border vBox_7 gSelect_Col_Groups
		Gui,Dock_Settings2:Add,Text,x280 y260 w100 Border vBox_8 gSelect_Col_Groups
		
		Gui,Dock_Settings2:Add,Text,x10 y220 w120 h30 Border gDock_SettingsUpdate
		Gui,Dock_Settings2:Add,Text,x10 y260 w120 h30 Border gDock_SettingsGuiClose

		Gui,Dock_Settings1:Show,w400 h300
		Gui,Dock_Settings2:Show,w400 h300,Settings_Overlay
		Changing_Settings_Active:=1
	}
	return
Dock_SettingsUpdate:
	lc:=2
	if(Box_1=1)
		{
			Loop,7
				{
					Change_Dock_Theme_Colors(A_Index,Text_Color_Var,Trim_Color_Var)
				}
		}
	(Box_2=1)?(Change_Dock_Theme_Colors(7,Text_Color_Var,Trim_Color_Var))
	:(Box_3=1)?(Change_Dock_Theme_Colors(1,Text_Color_Var,Trim_Color_Var))
	:(Box_4=1)?(Change_Dock_Theme_Colors(2,Text_Color_Var,Trim_Color_Var))
	:(Box_5=1)?(Change_Dock_Theme_Colors(3,Text_Color_Var,Trim_Color_Var))
	:(Box_6=1)?(Change_Dock_Theme_Colors(4,Text_Color_Var,Trim_Color_Var))
	:(Box_7=1)?(Change_Dock_Theme_Colors(5,Text_Color_Var,Trim_Color_Var))
	:(Box_8=1)?(Change_Dock_Theme_Colors(6,Text_Color_Var,Trim_Color_Var))
	return
Select_Col_Groups:
	StringRight,bsn,A_GuiControl,1
	Loop 8
		{
			if(A_Index=bsn){
				GuiControl,Dock_Settings1:+cTeal,Group_Radio_%A_Index%
				Box_%A_Index%:=1
			}
			else	{
				GuiControl,Dock_Settings1:+cSilver,Group_Radio_%A_Index%
				Box_%A_Index%:=0
			}
		}
		
	return
Color_Options_Radios:
	if(A_GuiControl="Text_Radio2")
		{
			Object_To_Change:=1
			GuiControl,Dock_Settings1:+cTeal,Text_Radio1
			GuiControl,Dock_Settings1:+cSilver,Trim_Radio1
		}
	else if(A_GuiControl="Trim_Radio2")
		{
			Object_To_Change:=2
			GuiControl,Dock_Settings1:+cSilver,Text_Radio1
			GuiControl,Dock_Settings1:+cTeal,Trim_Radio1
		}
	gosub,Set_New_Color	
	return
Change_Custom_Color1:
	Gui,Dock_Settings1:Submit,NoHide
	GuiControl,Dock_Settings1:+c%Setting_Custom_Color1%,Custom_Color_Preview1
	return
Focus_Setting_Custom_Color1:
	GuiControl,Dock_Settings1:,Setting_Custom_Color1,
	GuiControl,Dock_Settings1:Focus,Setting_Custom_Color1
	return
Move_Settings_Window:
	PostMessage,0xA1,2
	While(GetKeyState("LButton"))
		sleep,10
	WinGetPos,sx,sy,,,Settings_Overlay
	Gui,Dock_Settings1:Show,x%sx% y%sy%
	return
Set_New_Color:
	Loop,Parse,A_GuiControl,_
		{
			if(A_Index=4)
				cns:=A_LoopField
		}
	;~ tooltip,% A_Guicontrol "`n" cns "`n" Settings_Color_List[cns]
	Settings_Color_List[16]:=Setting_Custom_Color1
	if(Object_To_Change=1)
		{
			Gui,Dock_Settings1:Font,
			Gui,Dock_Settings1:Font,% "c" Settings_Color_List[cns] " s8 Bold Q5",Khmer UI
			GuiControl,Dock_Settings1:Font,Samp_Text
			GuiControl,Dock_Settings1:+Redraw,Samp_Background
			GuiControl,Dock_Settings1:+Redraw,Samp_Text
			Text_Color_Var:=Settings_Color_List[cns]
		}
	else if(Object_To_Change=2)
		{
			GuiControl,% "Dock_Settings1:+Background" Settings_Color_List[cns],Samp_Trim
			GuiControl,% "Dock_Settings1:+Background" Settings_Color_List[cns],Samp_Trim2
			GuiControl,Dock_Settings1:+Redraw,Samp_Background
			GuiControl,Dock_Settings1:+Redraw,Samp_Text
			Trim_Color_Var:=Settings_Color_List[cns]
		}	
	return
	
Update_New_Dock_Settings:
	Loop 7
		{
			(Col_selected_%A_Index% =1)?(Change_Dock_Theme_Colors(A_Index,Text_Color_Var,Trim_Color_Var))
		}
	return
Update_New_Dock_Settings_And_Exit:
	gosub,Dock_SettingsGuiClose	
	Loop 7
		{
			(Col_selected_%A_Index% =1)?(Change_Dock_Theme_Colors(A_Index,Text_Color_Var,Trim_Color_Var))
		}
	return	
Change_Dock_Theme_Colors(col_to_Change,txtc,trmc)
	{
		global
		;~ tooltip,here
		Dock_Text_Theme[Current_Dock][col_to_Change]:= txtc 
		Dock_Trim_Theme[Current_Dock][col_to_Change]:=trmc 
		tem1:=Dock_Trim_Theme[Current_Dock][col_to_Change]
		IniWrite,%tem1%,Dock It v0.0.1.ini,Dock %Current_Dock% Trim Theme Info,Col %col_to_Change%
		tem1:=Dock_Text_Theme[Current_Dock][col_to_Change]
		IniWrite,%tem1%,Dock It v0.0.1.ini,Dock %Current_Dock% Text Theme Info,Col %col_to_Change%
		Load_Dock_Buttons()
		Gui,1:Hide
		Gui,1:Show
	}
Submit_All_Settings:
	Gui,Dock_Settings:Submit,NoHide
	return
Dock_SettingsGuiClose:
	Gui,Dock_Settings1:Destroy
	Gui,Dock_Settings2:Destroy
	Changing_Settings_Active:=0
	return
Move_Program:
	if(Changing_Settings_Active=0)
		{
			Changing_Settings_Active:=1
			GuiControl,1:+Background553333,MB_5
			GuiControl,1:+Redraw,MB_6
			Move_Mode:=1
			MovePhase:=1
		}
	else if(Move_Mode=1){
		Move_Mode:=0
		GuiControl,1:+Background222222,MB_5
		GuiControl,1:+Redraw,MB_6
		Changing_Settings_Active:=0
	}
	return
Edit_Program:
	if(Changing_Settings_Active=0)
		{
			Changing_Settings_Active:=1
			GuiControl,1:+Background553333,MB_8
			GuiControl,1:+Redraw,MB_9
			Edit_Mode:=1
		}
	else if(Edit_Mode=1){
		Edit_Mode:=0
		GuiControl,1:+Background222222,MB_8
		GuiControl,1:+Redraw,MB_9
		Changing_Settings_Active:=0
	}
	return
Change_Header:
	if(GetKeyState("Shift")){
		tooltip,here
	}
	return
Open_Dock:
	if(Dock_Open=0)
		{	
			StringTrimLeft,Current_Dock,A_GuiControl,12
			;~ tooltip,% A_GuiControl "`n" Current_Dock
			Load_Dock_Buttons()
			GuiControl,3:+Background553333 ,Button_%Current_Dock%_3
			GuiControl,3:+Redraw ,Button_%Current_Dock%_4
			Dock_Open:=1,Dock_Expanded:=0
		}
	else if(Dock_Open=1)
		{	
			GuiControl,3:+Background222222 ,Button_%Current_Dock%_3
			GuiControl,3:+Redraw ,Button_%Current_Dock%_4
			Dock_Close:=1
		}	
	return
Run_Program_Or_Edit:
	StringTrimLeft,Current_Button,A_GuiControl,7
	if(Move_Mode=1){
		if(MovePhase=1){
			temp_old:=Current_Button
			MovePhase:=2
		}
		else if(MovePhase=2){
			temp_new:=Current_Button
			temp_BN:=Dock_%Current_Dock%_Button_Name[Current_Button]
			temp_p:=Dock_%Current_Dock%_Button_Program[Current_Button]
			temp_N:=Dock_%Current_Dock%_Button_Notes[Current_Button]
			IniWrite,% Dock_%Current_Dock%_Button_Name[temp_old],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Name 
			IniWrite,% Dock_%Current_Dock%_Button_Program[temp_old],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Program
			IniWrite,% Dock_%Current_Dock%_Button_Notes[temp_old],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Notes
			IniWrite,% temp_bn,Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %temp_old% Name 
			IniWrite,% temp_p,Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %temp_old% Program
			IniWrite,% temp_N,Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %temp_old% Notes
			Dock_%Current_Dock%_Button_Name[Current_Button]:=Dock_%Current_Dock%_Button_Name[temp_old]
			Dock_%Current_Dock%_Button_Program[Current_Button]:=Dock_%Current_Dock%_Button_Program[temp_old]
			Dock_%Current_Dock%_Button_Notes[Current_Button]:=Dock_%Current_Dock%_Button_Notes[temp_old]
			Dock_%Current_Dock%_Button_Name[temp_old]:=temp_BN
			Dock_%Current_Dock%_Button_Program[temp_old]:=temp_p
			Dock_%Current_Dock%_Button_Notes[temp_old]:=temp_N
			MovePhase:=0
			Move_Mode:=0
			Changing_Settings_Active:=0
			GuiControl,1:+Background222222,MB_5
			GuiControl,1:+Redraw,MB_6
			GuiControl,1:,DBT_%ccol%_%btnn%,% Dock_%Current_Dock%_Button_Name[btnn]
			cb:=current_Button
			if(cb=1||cb=7||cb=13||cb=19||cb=25||cb=31||cb=37||cb=43||cb=49||cb=55)
				GuiControl,1:,DBT_1_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			else if(cb=2||cb=8||cb=14||cb=20||cb=26||cb=32||cb=38||cb=44||cb=50||cb=56)
				GuiControl,1:,DBT_2_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			else if(cb=3||cb=9||cb=15||cb=21||cb=27||cb=33||cb=39||cb=45||cb=51||cb=57)
				GuiControl,1:,DBT_3_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			else if(cb=4||cb=10||cb=16||cb=22||cb=28||cb=34||cb=40||cb=46||cb=52||cb=58)
				GuiControl,1:,DBT_4_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			else if(cb=5||cb=11||cb=17||cb=23||cb=29||cb=35||cb=41||cb=47||cb=53||cb=59)
				GuiControl,1:,DBT_5_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			else if(cb=6||cb=12||cb=18||cb=24||cb=30||cb=36||cb=42||cb=48||cb=54||cb=60)
				GuiControl,1:,DBT_6_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
			cb:=temp_old
			if(cb=1||cb=7||cb=13||cb=19||cb=25||cb=31||cb=37||cb=43||cb=49||cb=55)
				GuiControl,1:,DBT_1_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
			else if(cb=2||cb=8||cb=14||cb=20||cb=26||cb=32||cb=38||cb=44||cb=50||cb=56)
				GuiControl,1:,DBT_2_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
			else if(cb=3||cb=9||cb=15||cb=21||cb=27||cb=33||cb=39||cb=45||cb=51||cb=57)
				GuiControl,1:,DBT_3_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
			else if(cb=4||cb=10||cb=16||cb=22||cb=28||cb=34||cb=40||cb=46||cb=52||cb=58)
				GuiControl,1:,DBT_4_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
			else if(cb=5||cb=11||cb=17||cb=23||cb=29||cb=35||cb=41||cb=47||cb=53||cb=59)
				GuiControl,1:,DBT_5_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
			else if(cb=6||cb=12||cb=18||cb=24||cb=30||cb=36||cb=42||cb=48||cb=54||cb=60)
				GuiControl,1:,DBT_6_%temp_old%,% Dock_%Current_Dock%_Button_Name[temp_old]
		}
	}
	else	{
		try	
			{
				if(Edit_Mode=1)
					Add_New_Program(Current_Dock,Current_Button)
				else 
					Run, % Dock_%Current_Dock%_Button_Program[Current_Button]
			}
		catch
			{
				Add_New_Program(Current_Dock,Current_Button)
			}
	}		
	return
Watch_Docks:
	WingetPos,twx,twy,tww,twh,Dock It Launcher 1
	MouseGetPos,tmx,tmy,www,cw
	if(Expanded_Window=0&&tmx<=twx+tww+20&&Lock_It=0)
		{
			if(Instant_Slide=0)
				{
					while Dock_Launcher_X<=-8
						{
							Dock_Launcher_X+=10 
							Gui,3:Show,x%Dock_Launcher_X% ,Dock It Launcher 1
							Gui,4:Show,x%Dock_Launcher_X% ,Dock It Launcher 2
						}
				}
			Dock_Launcher_X:=-3
			Gui,3:Show,x%Dock_Launcher_X% ,Dock It Launcher 1
			Gui,4:Show,x%Dock_Launcher_X% ,Dock It Launcher 2
			Expanded_Window:=1
		}
	else if(Expanded_Window=1&&tmx>=twx+tww&&Dock_Open=0)
		{
			if(Instant_Slide=0)
				{
					while Dock_Launcher_X>=-131
						{
							Dock_Launcher_X-=10  
							Gui,3:Show,x%Dock_Launcher_X% ,Dock It Launcher 1
							Gui,4:Show,x%Dock_Launcher_X% ,Dock It Launcher 2
						}
				}	
			Dock_Launcher_X:=-136  
			Gui,3:Show,x%Dock_Launcher_X% ,Dock It Launcher 1
			Gui,4:Show,x%Dock_Launcher_X% ,Dock It Launcher 2
			Expanded_Window:=0
		}
;Opening Dock		
	if(Dock_Open=1&&Dock_Expanded=0)
		{
			if(Instant_Slide=0)
				{
					while Dock_X <=-10 
						{
							Dock_X+=30  
							Gui,1:Show,x%Dock_X% ,Dock It
							Gui,2:Show,x%Dock_X% ,Dock It Mask
						}
				}		
			Dock_X:=0,Dock_Expanded:=1
			Gui,1:Show,x%Dock_X% ,Dock It
			Gui,2:Show,x%Dock_X% ,Dock It Mask
		}
	else if(((Dock_Expanded=1&&tmx>990)||Dock_Close=1)&&Changing_Settings_Active=0)	
		{
			if(Instant_Slide=0)
				{
					while Dock_X >=-995
						{
							Dock_X-=30 
							Gui,1:Show,x%Dock_X% ,Dock It
							Gui,2:Show,x%Dock_X% ,Dock It Mask
						}
				}		
			Dock_X:=-995,Dock_Expanded:=0,Dock_Open:=0,Dock_Close:=0	
			Gui,1:Show,x%Dock_X% ,Dock It
			Gui,2:Show,x%Dock_X% ,Dock It Mask
			GuiControl,3:+Background222222 ,Button_%Current_Dock%_3
			GuiControl,3:+Redraw ,Button_%Current_Dock%_4
		}		
	return


Build_Gui_1_2()
	{
		global
		Gui,1: -Caption +Owner 
		Gui,2: -Caption +Owner1 +LastFound  
		WinSet,Transparent,10
		Gui,1:Color,111111
		Gui,2:Color,Yellow
		btrx:=205,Btrx2:=209
		Gui,1:Add,Progress,x190 y0 w3 h560 vDM_1 
		Gui,1:Add,Progress,x190 y0 w800 h3 vDM_2 
		Gui,1:Add,Progress,x190 y557 w800 h3 vDM_3 
		Gui,1:Add,Progress,x987 y0 w3 h560 vDM_4 
		colv:=5
		Gui,1:Font,c%TTTC% s8 Bold Q5,Khmer UI
		Loop 6
			{
				Gui,1:Add,Progress,x%btrx% y34 w120 h516 vDM_%colv% Background%THBC% c111111,100
				colv++
				Gui,1:Add,Progress,x%btrx2% y14 w112 h40 vDM_%colv% Background%THBC% c111111,100
				Gui,1:Add,Text,x%btrx2% y19 w112 h35 BackgroundTrans Center vCOL_H_%A_Index% 
				Gui,2:Add,Text,x%btrx2% y14 w112 h40 Border vCOL_Header_%A_Index% gChange_Header
				btrx+=130 ,btrx2+=130,colv++
			}
		sy:=65,sy2:=66,sy3:=73
		Gui,1:Font,c%TTTC% s8 Bold Q5,Khmer UI
		coll:=1
		coll2:=1
		Loop 10
				{
					sx:=210,sx2:=211
					Loop 6
						{
							Gui,1:Add,Progress,x%sx% y%sy% w110 h30 BackgroundBlack 
							Gui,1:Add,Progress,x%sx% y%sy% w109 h29 vBT_%coll%_%i% ;Background%THBC% 
							coll++
							if(coll=7)
								coll:=1
							Gui,1:Add,Progress,x%sx2% y%sy2% w108 h28 Background222222 
							Gui,1:Add,Text,cred x%sx2% y%sy3% w108 r1 BackgroundTrans Center vDBT_%coll2%_%i%,
							coll2++
							if(coll2=7)
								coll2:=1
							Gui,2:Add,Text,x%sx% y%sy% w110 h30 Border vButton_%i% gRun_Program_Or_Edit
							sx+=130,sx2+=130,i++
						}
					sy+=50,sy2+=50,sy3+=50	
				}
				
		Gui,1:Add,Progress,x138 y70 w40 h130 BackgroundBlack 	
		Gui,1:Add,Progress,x138 y70 w38 h128 Background%THBC% vMB_1	
		Gui,1:Add,Progress,x140 y72 w36 h126 Background222222 vMB_2
		Gui,1:Add,Text,cTeal x138 y80 w40 h110 BackgroundTrans Center vMB_3,S`ne`nt`nt`ni`nn`ng`ns 
		Gui,2:Add,Text,x138 y70 w40 h130 Border vDock_Settings_Button gAdjust_Dock_Settings
		
		Gui,1:Add,Progress,x138 y320 w40 h90 BackgroundBlack 
		Gui,1:Add,Progress,x138 y320 w38 h88 Background%THBC% vMB_4
		Gui,1:Add,Progress,x140 y322 w36 h86 Background222222 vMB_5
		Gui,1:Add,Text,cTeal x138 y340 w40 h70 BackgroundTrans Center vMB_6,M`no`nv`ne
		Gui,2:Add,Text, x138 y320 w40 h90 Border vMove_Button gMove_Program


		Gui,1:Add,Progress,x138 y450 w40 h90 BackgroundBlack		
		Gui,1:Add,Progress,x138 y450 w38 h88 Background%THBC% vMB_7	
		Gui,1:Add,Progress,x140 y452 w36 h86 Background222222 vMB_8
		Gui,1:Add,Text,cTeal x138 y470 w40 h70 BackgroundTrans Center vMB_9,E`nd`ni`nt
		Gui,2:Add,Text,x138 y450 w40 h90 Border vDock_Edit_Button gEdit_Program


		Gui,1:Show,x%Dock_X% y%Dock_Y% w%Dock_W% h%Dock_H% ,Dock It
		Gui,2:Show,x%Dock_X% y%Dock_Y% w%Dock_W% h%Dock_H% ,Dock It Mask
	}

Build_Gui_3_4()
	{
		global
		Gui,3:Destroy
		Gui,4:Destroy
		Gui,3:+AlwaysOnTop -Caption  +Owner1 +LastFound
		WinSet,TransColor,100000
		Gui,4:+AlwaysOnTop -Caption  +Owner3 +LastFound
		Winset,Transparent,10
		Gui,3:Color,100000
		Gui,4:Color,yellow
		Gui,3:Add,Progress,x0 y0 w130 h%Dock_Launcher_H% BackGround%THBC% c111111,100
		Gui,3:Add,Progress,x134 y285 w13 h30 Background008844  vSlide_Lock
		
		Gui,3:Add,Progress,x10 y7 w110 h25 Background%THBC% c111111 ,100
		Gui,3:Add,Progress,x20 y7 w90 h20 Background%THBC% c222222 ,100
		Gui,3:Font,c%TTTC% s14 Q5,Segoe UI black
		Gui,3:Add,Text,x20 y4 w90 Center BackgroundTrans,Dock-It
		Gui,3:Font,c%TTTC% s8 Bold Q5,Khmer UI 
		
		BN:=1,BY1:=50,BY2:=51,BY3:=58
		Loop % DBC
			{
				Gui,3:Add,Progress,x10 y%BY1% w110 h30 BackgroundBlack vButton_%BN%_1
				Gui,3:Add,Progress,x10 y%BY1% w109 h29 Background%THBC% vButton_%BN%_2
				Gui,3:Add,Progress,x11 y%BY2% w108 h28 Background222222 vButton_%BN%_3
				if(BN=10)
					Gui,3:Add,Text,x11 y%BY3% w108 BackgroundTrans Center vButton_%BN%_4,Settings
				else if(BN=11)
					Gui,3:Add,Text,x11 y%BY3% w108 BackgroundTrans Center vButton_%BN%_4,EXIT
				else
					Gui,3:Add,Text,x11 y%BY3% w108 BackgroundTrans Center vButton_%BN%_4,% Dock_Names[BN]
				BN++,BY1+=50,BY2+=50,BY3+=50
			}
		BN:=1,BY:=50
		Loop % DBC
			{
				if(BN=11)
					Gui,4:Add,Text,x10 y%BY% w110 h30 Border vDock_Button_%BN%  gGuiClose 
				else if(BN=10)
					Gui,4:Add,Text,x10 y500 w110 h30 Border vDock_Button_%BN% 
				else	
					Gui,4:Add,Text,x10 y%BY% w110 h30 Border vDock_Button_%BN%   gOpen_Dock
				BN++,BY+=50
			}
		
		Gui,3:Show,x%Dock_Launcher_X% y%Dock_Launcher_Y% w%Dock_Launcher_W% h%Dock_Launcher_H%,Dock It Launcher 1
		Gui,4:Show,x%Dock_Launcher_X% y%Dock_Launcher_Y% w130 h%Dock_Launcher_H% ,Dock It Launcher 2
	}
Load_Dock_Buttons()
	{
		global
		ccol:=1,btnn:=1
		loop 10
			{
				ccol:=1
				loop 6
					{
						GuiControl,1:,DBT_%ccol%_%btnn%,% Dock_%Current_Dock%_Button_Name[btnn]
						ccol++,btnn++
					}
					
			}	
		;Change Master Trim	
		
		Loop 4
			{
				GuiControl,% "1:+Background"Dock_Trim_Theme[Current_Dock][7] ,DM_%A_Index%
			}
		cco1:=1,cco2:=3,cco3:=3	
		Loop 3
			{
				GuiControl,% "1:+Background"Dock_Trim_Theme[Current_Dock][7],MB_%cco1%
				GuiControl,% "1:+c"Dock_Text_Theme[Current_Dock][7],MB_%cco2%
				cco1+=3,cco2+=3
			}
		Loop 6
			{
				GuiControl,1:,COL_H_%A_Index%  ,% Column_Name_%Current_Dock%[A_Index]
				;~ GuiControl,% "1:+c"Dock_Text_Theme[Current_Dock][7],COL_H_%A_Index%  
				GuiControl,% "1:+c"Dock_Text_Theme[Current_Dock][A_Index],COL_H_%A_Index%  
				;~ msgbox, % Column_Name_%Current_Dock%[A_Index]
			}
			
			;COL_H_%A_Index% 
			
		coll:=1,BT:=1,nem:=5,nem1:=6
		Loop 6
			{
				GuiControl,% "1:+Background"Dock_Trim_Theme[Current_Dock][coll],DM_%nem%
				GuiControl,% "1:+Background"Dock_Trim_Theme[Current_Dock][coll],DM_%nem1%
				Loop 10
					{
						GuiControl,% "1:+Background"Dock_Trim_Theme[Current_Dock][coll],BT_%coll%_%BT%
						GuiControl,% "1: +c"Dock_Text_Theme[Current_Dock][coll],DBT_%coll%_%BT%
						BT+=6
					}
				coll++,BT:=coll,nem+=2,nem1+=2
				
				
			}
	}

	
Dock_Settings_Gui()
	{
		global
		Gui,5:Destroy
		Gui,5:+AlwaysOnTop -Caption +Border +Owner
		
		Gui,5:Add,Progress,x0 y0 w400 h300 BackgroundTeal c111111
		
		Gui,5:Show,
	}
	
;Add New Programs
;################################################################################################
;################################################################################################

Add_New_Program(Current_Dock,Current_Button){
	global
	if(Changing_Settings_Active!=1||Edit_Mode=1){
		Changing_Settings_Active:=1
		Edit_Mode:=0
		GuiControl,1:+Background222222,MB_8
		GuiControl,1:+Redraw,MB_9
		Gui,1:Hide
		Gui,2:Hide
		Gui,3:Hide
		Gui,4:Hide				
		
		Gui,New_Program_Gui1:+AlwaysOnTop -Caption Border Owner
		Gui,New_Program_Gui2:+AlwaysOnTop -Caption Border OwnerNew_Program_Gui1 LastFound
		WinSet,Transparent,1
		Gui,New_Program_Gui1:Color,,Black
		Gui,New_Program_Gui2:Color,yellow
		Gui,New_Program_Gui3:+AlwaysOnTop -Caption Border OwnerNew_Program_Gui2 +LastFound
		Gui,New_Program_Gui3:Color,yellow,Black
		Winset,TransColor,Yellow



		
		;Gui,1
		;################################################

		Gui,New_Program_Gui1:Font,cTeal s16 Bold Q5,Khmer UI

		Gui,New_Program_Gui1:Add,Progress,x0 y0 w500 h480 BackgroundTeal c111111,100


		Gui,New_Program_Gui1:Add,Progress,x10 y10 w480 h50 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Add,Progress,x15 y15 w40 h40 BackgroundTeal cBlack,100
		Gui,New_Program_Gui1:Add,Text,x15 y20 w40 BackgroundTrans Center ,% Current_Button
		Gui,New_Program_Gui1:Add,Text,x80 y20 w340 BackgroundTrans Center ,Add / Edit Program

		Gui,New_Program_Gui1:Font,cTeal s8 Bold Q5,Khmer UI
		Gui,New_Program_Gui1:Add,Progress,x10 y70 w480 h50 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Add,Progress,x20 y80 w110 h30 BackgroundBlack
		Gui,New_Program_Gui1:Add,Progress,x20 y80 w109 h29 BackgroundTeal
		Gui,New_Program_Gui1:Add,Progress,x21 y81 w108 h28 Background222222
		Gui,New_Program_Gui1:Add,Text,x21 y88 w108 BackgroundTrans Center vB_Name,% Dock_%Current_Dock%_Button_Name[Current_Button]
		Gui,New_Program_Gui1:Add,Edit,cWhite x179 y84 w250 r1 Limit20 vAdd_Name_Edit gSubmit_Temp_Name,% Dock_%Current_Dock%_Button_Name[Current_Button]

		Gui,New_Program_Gui1:Add,Progress,x10 y130 w480 h80 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Add,Progress,x150 y135 w200 h25 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Font,cTeal s12 Bold Q5,Khmer UI
		Gui,New_Program_Gui1:Add,Text,x150 y137 w200 BackgroundTrans Center ,PATH
		Gui,New_Program_Gui1:Font,cTeal s8 Bold Q5,Khmer UI
		Gui,New_Program_Gui1:Add,Edit,cWhite x20 y175 w330 r1 vAdd_Path_Edit gSubmit_Path,% Dock_%Current_Dock%_Button_Program[Current_Button]
		Gui,New_Program_Gui1:Add,Progress,x370 y170 w110 h30 BackgroundBlack
		Gui,New_Program_Gui1:Add,Progress,x370 y170 w109 h29 BackgroundTeal
		Gui,New_Program_Gui1:Add,Progress,x371 y171 w108 h28 Background222222
		Gui,New_Program_Gui1:Add,Text,x371 y178 w108 BackgroundTrans Center ,Get PATH

		Gui,New_Program_Gui1:Add,Progress,x10 y220 w480 h200 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Add,Progress,x150 y225 w200 h25 BackgroundTeal c111111,100
		Gui,New_Program_Gui1:Font,cTeal s12 Bold Q5,Khmer UI
		Gui,New_Program_Gui1:Add,Text,x150 y227 w200 BackgroundTrans Center ,Notes
		Gui,New_Program_Gui1:Font,cTeal s12 Bold Q5,Khmer UI

		Gui,New_Program_Gui1:Add,Progress,x30 y430 w210 h40 BackgroundBlack
		Gui,New_Program_Gui1:Add,Progress,x30 y430 w209 h39 BackgroundTeal
		Gui,New_Program_Gui1:Add,Progress,x31 y431 w208 h38 Background222222
		Gui,New_Program_Gui1:Add,Text,x31 y438 w208 BackgroundTrans Center ,Update

		Gui,New_Program_Gui1:Add,Progress,x260 y430 w210 h40 BackgroundBlack
		Gui,New_Program_Gui1:Add,Progress,x260 y430 w209 h39 BackgroundTeal
		Gui,New_Program_Gui1:Add,Progress,x261 y431 w208 h38 Background222222
		Gui,New_Program_Gui1:Add,Text,x261 y438 w208 BackgroundTrans Center ,Cancel

		;Gui 2
		;################################################
		Gui,New_Program_Gui2:Add,Text,x0 y0 w500 h60 Border gMove_Add

		Gui,New_Program_Gui2:Add,Text,x179 y84 w250 h22 Border gFocus_Add_Name
		Gui,New_Program_Gui2:Add,Text,x20 y175 w330 h22 Border gFocus_Add_Path
		Gui,New_Program_Gui2:Add,Text,x370 y170 w110 h30 Border gGet_File_Path
		Gui,New_Program_Gui2:Add,Text,x30 y430 w210 h40 Border gUpdate_New_Program
		Gui,New_Program_Gui2:Add,Text,x260 y430 w210 h40 Border gCancel_New_Program

		;Gui 3
		;################################################
		Gui,New_Program_Gui3:Font,cWhite s8 Bold Q5,Khmer UI
		Gui,New_Program_Gui3:Add,Edit,x20 y260 w460 r10 +HScroll vNotes_Edit gSubmit_Notes,% Dock_%Current_Dock%_Button_Notes[Current_Button]


		Gui,New_Program_Gui1:Show, w500 h480 ,Add Program Window 1
		Gui,New_Program_Gui2:Show, w500 h480 ,Add Program Window 2
		Gui,New_Program_Gui3:Show, w500 h480 ,Add Program Window 3
		
	}	
}




Move_Add:
	PostMessage,0xA1,2
	While(GetKeyState("LButton"))
		sleep,10
	WingetPos,wx,wy,,,Add Program Window 2
	Gui,New_Program_Gui1:Show,x%wx% y%wy%
	Gui,New_Program_Gui3:Show,x%wx% y%wy%
	return
	
Focus_Add_Name:
	GuiControl,New_Program_Gui1:Focus,Add_Name_Edit
	return

Focus_Add_Path:
	GuiControl,New_Program_Gui1:Focus,Add_Path_Edit
	return

Submit_Temp_Name:
	Gui,New_Program_Gui1:Submit,NoHide
	GuiControl,New_Program_Gui1:,B_Name,% Add_Name_Edit
	return
Submit_Notes:
	Gui,New_Program_Gui3:Submit,NoHide
	return
Submit_Path:
	Gui,New_Program_Gui1:Submit,NoHide
	return
Get_File_Path:
	Gui,New_Program_Gui1:Hide
	Gui,New_Program_Gui2:Hide
	Gui,New_Program_Gui3:Hide
	While(!GetKeyState("ctrl")&&!GetKeyState("esc")){
		ToolTip,Select a file / program and then press ctrl to get its path`nPress ESC to cancel
	}
	if(Getkeystate("ctrl")){
		Clipboard:=""
		Sleep,50
		Send,^c
		sleep,50
		tooltip,
		Gui,New_Program_Gui1:Show
		Gui,New_Program_Gui2:Show
		Gui,New_Program_Gui3:Show
		temp_File_Path:=Clipboard
		GuiControl,New_Program_Gui1:,Add_Path_Edit,% temp_File_Path
	}
	else if(Getkeystate("ESC")){
		tooltip,
		Gui,New_Program_Gui1:Show
		Gui,New_Program_Gui2:Show
		Gui,New_Program_Gui3:Show
	}
	return
Cancel_New_Program:
	Gui,New_Program_Gui1:Destroy
	Gui,New_Program_Gui2:Destroy
	Gui,New_Program_Gui3:Destroy
	Changing_Settings_Active:=0
	Gui,1:Show
	Gui,2:Show
	Gui,3:Show
	Gui,4:Show	
	return

Update_New_Program:
	Gui,New_Program_Gui1:Destroy
	Gui,New_Program_Gui2:Destroy
	Gui,New_Program_Gui3:Destroy
	Changing_Settings_Active:=0
	Gui,1:Show
	Gui,2:Show
	Gui,3:Show
	Gui,4:Show	
	Dock_%Current_Dock%_Button_Name[Current_Button]:=Add_Name_Edit
	Dock_%Current_Dock%_Button_Program[Current_Button]:=Add_Path_Edit
	Dock_%Current_Dock%_Button_Notes[Current_Button]:=Notes_Edit
	cb:=Current_Button
	if(cb=1||cb=7||cb=13||cb=19||cb=25||cb=31||cb=37||cb=43||cb=49||cb=55)
		GuiControl,1:,DBT_1_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	else if(cb=2||cb=8||cb=14||cb=20||cb=26||cb=32||cb=38||cb=44||cb=50||cb=56)
		GuiControl,1:,DBT_2_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	else if(cb=3||cb=9||cb=15||cb=21||cb=27||cb=33||cb=39||cb=45||cb=51||cb=57)
		GuiControl,1:,DBT_3_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	else if(cb=4||cb=10||cb=16||cb=22||cb=28||cb=34||cb=40||cb=46||cb=52||cb=58)
		GuiControl,1:,DBT_4_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	else if(cb=5||cb=11||cb=17||cb=23||cb=29||cb=35||cb=41||cb=47||cb=53||cb=59)
		GuiControl,1:,DBT_5_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	else if(cb=6||cb=12||cb=18||cb=24||cb=30||cb=36||cb=42||cb=48||cb=54||cb=60)
		GuiControl,1:,DBT_6_%Current_Button%,% Dock_%Current_Dock%_Button_Name[Current_Button]
	IniWrite,% Dock_%Current_Dock%_Button_Name[Current_Button],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Name 
	IniWrite,% Dock_%Current_Dock%_Button_Program[Current_Button],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Program
	IniWrite,% Dock_%Current_Dock%_Button_Notes[Current_Button],Dock It v0.0.1.ini,Dock %Current_Dock% Info,Button %Current_Button% Notes
	return

	
*^+ESC::ExitApp