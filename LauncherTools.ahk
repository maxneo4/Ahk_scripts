#NoEnv
;#HotkeyModifierTimeout 100 maximo tiempo permitido sostener una tecla modificadora
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%

FileRead, settings, settings.ini
if InStr(settings, "runAsAdmin=1") > 0
{
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run *RunAs "%A_ScriptFullPath%" /restart
			else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}

;Changes
;Remove ñ n Vim
;Edit image capture automatically whithout using second command
;Save word automatically 
;Capture in tutorial with less keys or easy position WIN+E.. GC + ce cs WIN+S
;change shift+space to ctrl+space to avoid accidentally activation master command
;splash when CapsLock or NumLock change

;Clipboard change event... to caputure more automatically..
;Remove make tutorial
;Change command to set always on top or not a window
;Window gestures only keep commands relative to always on top

global commandsPath = "CommandSelector\commands.json"

#Include Ahk Resources\AhkLibs\json.ahk

#Include Ahk Resources\AhkLibs\SelectedPath.ahk
#include CustomFunctions\custom_functions.ahk
#include CustomFunctions\explorer_functions.ahk
#include CustomFunctions\form_functions.ahk

#include CommandSelector\CommandSelector.ahk
InitCommandSelector(commandsPath)
#include LogNotesAndRememberList\LogNotesAndRememberList.ahk
InitRememberList()

#include Window Gestures\Window Gestures.ahk
WindowGesturesInit()

#Include samples\sharats.me\time-osd.ahk
TimeOSDInit()

#Include  VimKeyCommands\VimNeo.ahk
InitVimNeo()

#Include FastAccessContent\FastContentWindows.ahk
initFastContentWindow()

;O ommit the end character separator
;* ommit to need end character	
;Bizagi developer hotStrings

hotStringsFile := A_ScriptDir . "\HotStrings.ahk"

if FileExist(hotStringsFile)
	Run, %hotStringsFile%

^#e::
if FileExist(hotStringsFile)
	Run Edit %hotStringsFile%
Else
	MsgBox, , File not found, %hotStringsFile%
return

^#r::
if FileExist(hotStringsFile)
	{
		MsgBox, , , Reloading hotstrings..., 1
		Run, %hotStringsFile%
	}
return

^F1::
helpText = 
(
V 0.70
# CommandSelector

ALT+SPACE : abre selector de comandos
CTRL+ALT+R : recarga comandos del config
CTRL+ALT+E : abre el archivo de comandos para editarlo/verlo
ESCAPE : oculta el selector de comandos

--------------------------------------------------------------

# Window gestures
CTRL + ALT + UP : pone la ventana actual AlwaysOnTop
CTRL + ALT + DOWN : desactiva en la ventana actual AlwaysOnTop

--------------------------------------------------------------
# Fast contents
WIN+O : open fast contents window
WIN+A : copy and add content
WIN+V : add content
WIN+C : copy selected item content
WIN+R : run selected item
CTRL+WIN+R : run selected item as Admin
SUPR: delete selected item content

# Vim mode
SHIFT + ESC to activate
ESC : exit Vim mode
F1 : Vim Help (Only when Vim mode is activated)

# Hot Strings
CTRL+WIN+E : edit hotstrings file
CTRL+WIN+R : reload hotstrings
--------------------------------------------------------------
)
MsgBox, ,Help, %helptext%, 
Return

+F1::
helpText = 
(
V 0.70
Master command = (CTRL+ALT+SPACE = ALT GR+SPACE), CTRL+SHIFT+SPACE(to avoid to close popups)
Master command = MC
----------------------------------------------------------------

# Log notes #
MC => LA: [Log add] agregar texto seleccionado al log
MC => LI: [Log input] abre caja de texto para escribir directamente al log
MC => LO: [Log open] abrir log del dia actual

# Images notes #
MC => CS: [Capture screen] agregar captura de pantalla al log de imagenes
MC => CE: [Capture edit] envia CTRL+PrintScreen captura region con ShareX
MC => CC: [Capture clipboard] guarda una imagen del portapapeles al log
MC => CO: [Capture open] abrir log de imagenes del dia actual

# Workspace #
MC => WS: [Workspace Set] set current folder as Workspace
MC => WO: [Worksace Open] open current workspace
MC => WD: [Workspace Default] set workspace to default value again
MC => WC: [Workspace Copy] copy workspace path to clipboard

----------------------------------------------------------------
# Remember list #

MC => RA: [Remember add] agrega texto seleccionado a la lista
MC => GA: [Global remember add]
MC => RO: [Remember open] abre listRemember.txt
MC => GO: [Global remember open]
MC => GI: Invoke global remember list
ESCAPE : oculta la lista

irm/irl : [Invoke Re-Member-list] muestra la lista para escoger el item a usar
irg: [invoke remember global] muestra la lista global para escoger el item a usar
Enter: invoke selected Text
SHIFT + Enter: run selected Text
)
MsgBox, ,Help, %helptext%, 
Return

#IfWinNotActive ahk_exe strwinclt.exe

~CapsLock::
Sleep, 250
If (GetKeyState("CapsLock", "T"))
    SplashTextOn, 150, 25, CapsLock state, On
Else
	SplashTextOn, 150, 25, CapsLock state, Off
Sleep, 500
SplashTextOff
return

~NumLock::
Sleep, 250
If (GetKeyState("NumLock", "T"))
    SplashTextOn, 150, 25, NumLock state, On
Else
	SplashTextOn, 150, 25, NumLock state, Off
Sleep, 500
SplashTextOff
return
return

#if

#if !A_IsCompiled
F5::
MsgBox, , , Reloading script, 0.5
Send, ^s
Reload
Return

F4::
controls := [{name: "flag", type: "CheckBox", state: "1"}, {name: "input field", value: "22", options: ""}, {name: "options", type: "DropDownList", state:"c", value: "a|b|c|d"},{name: "list", type: "ComboBox", state: "qu", help: "C:\temporal\compras.txt"},{name: "numero", type: "Slider", options: "Range1-10 ToolTip", state: "2"},{name:"server",type: "ComboBox", help:"C:\temporal\servers.txt"}, {name:"serverB",type: "ComboBox", help:"C:\temporal\servers.txt"}]
value := DynamicInputBox({title: "box dinamica", width: 200, vspace: 32, margin: 10, controls: controls, storeFileIni: "formData.ini" })
if value = "Canceled"
	MsgBox, , value, %value%
Else
	{
		jsonValue := JSON.Dump(value,,2)
		MsgBox, , Result Value, %jsonValue%
	}
return
