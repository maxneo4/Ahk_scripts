#NoEnv
;#HotkeyModifierTimeout 100 maximo tiempo permitido sostener una tecla modificadora
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%

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

global commandsPath = "CommandSelector\commands.json"

#Include Ahk Resources\AhkLibs\json.ahk
#Include Ahk Resources\AhkLibs\SelectedPath.ahk
#include CommandSelector\custom_functions.ahk

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

#Include TutorialMaker\TutorialMaker.ahk
InitTutorialMaker()

;O ommit the end character separator
;* ommit to need end character	
;Bizagi developer hotStrings

#IfWinNotActive ahk_exe strwinclt.exe

::sf::select * from
::tcat::BABIZAGICATALOG
:*:wg::where guidobject in(){Left 1}
::ij::inner join
::lj::left join
:O:btc::fnBA_DB_BlobToClob(){Left 1}
:O:ctb::fnBA_DB_ClobToBlob(){Left 1}
::obj::object
::gobj::guidobject
:O:ddlc::select DBMS_METADATA.GET_DDL('REF_CONSTRAINT', '') from dual{left 12}

:O:reb::\\dev-edwinbtmp\
:O:rorcl::\\dev-oracle122\
:O:rorcll::\\orcl-12-2-w1252\
:O:rbs::\\biz-studio\
:O:btrace::E:\Bizagi\Trace
:O:baorcl::User Id=BizagiAdmon;Password=bizagi;Data Source=dev-oracle122:1521/orcl
:O:baorcll::User Id=BizagiAdmon;Password=bizagi;Data Source=orcl-12-2-w1252:1521/orcl

#if

^F1::
helpText = 
(
V 0.5.8
# CommandSelector

ALT+SPACE : abre selector de comandos
CTRL+ALT+R : recarga comandos del config
CTRL+ALT+E : abre el archivo de comandos para editarlo/verlo
ESCAPE : oculta el selector de comandos

--------------------------------------------------------------

# Window gestures
CTRL + UP : agrega ventana al gestor
CTRL + DOWN : remueve ventana del gestor
CTRL + RIGHT : Navega a la siguiente ventana del gestor de forma ciclica
CTRL + LEFT : navega a la anterior ventana del gestor de forma ciclica
CTRL+ SHIFT + DOWN : remueve todas las ventanas del gestor

--------------------------------------------------------------

# Vim mode
Double ESC to activate
ESC : exit Vim mode
F1 : Vim Help (Only when Vim mode is activated)

--------------------------------------------------------------

# Tutorial Maker
CTRL + ALT + C : Choose Tutorial Folder and enabled
CTRL + ALT + D : Disable Tutorial maker capture

When it is enabled
	WIN + S : capture screen
	WIN + E : capture and edit
	WIN + C : capture from clipboard (edited image)
	WIN + O : open capture folder
	WIN + T : select image in windows explorer to edit (step, title, description) 
	WIN + R : Run and generate tutorial adding captured images with the step, title and description
)
MsgBox, ,Help, %helptext%, 
Return

+F1::
helpText = 
(
V 0.5.8
Master command = (CTRL+ALT+SPACE = ALT GR+SPACE), SHIFT+SPACE
----------------------------------------------------------------

# Log notes #
Master command => LA: [Log add] agregar texto seleccionado al log

Master command => LI: [Log input] abre caja de texto para escribir directamente al log

Master command => LO: [Log open] abrir log del dia actual

Master command => LD: [Log date] abrir log por fecha del calendario

# Images notes #
Master command => CS: [Capture screen] agregar captura de pantalla al log de imagenes

Master command => CE: [Capture edit] envia CTRL+PrintScreen captura region con ShareX
Master command => CC: [Capture clipboard] guarda una imagen del portapapeles al log

Master command => CO: [Capture open] abrir log de imagenes del dia actual

Master command => CD: [Capture date] abrir log de imagenes por fecha del calendario

----------------------------------------------------------------
# Remember list #

Master command => RA: [Remember add] agrega texto seleccionado a la lista
	GA: [Global remember add]
Master command => RO: [Remember open] abre listRemember.txt
	GO: [Global remember open]
ESCAPE : oculta la lista

irm : [Invoke Re-Member] muestra la lista para escoger el item a usar
igr : [invoke global remember] muestra la lista global para escoger el item a usar
)
MsgBox, ,Help, %helptext%, 
Return