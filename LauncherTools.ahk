#NoEnv 
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%

global commandsPath = "CommandSelector\commands.json"

#Include Ahk Resources\AhkLibs\json.ahk
#Include Ahk Resources\AhkLibs\SelectedPath.ahk
#include CommandSelector\custom_functions.ahk

#include CommandSelector\CommandSelector.ahk
InitCommandSelector(commandsPath)
#include LogNotesAndRememberList\LogNotesAndRememberList.ahk
InitRememberList("LogNotesAndRememberList\rememberList.txt")
#Include samples\sharats.me\time-osd.ahk
TimeOSDInit()

;O ommit the end character separator
;* ommit to need end character	
;Bizagi developer hotStrings
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

~Escape::   
CommandSelectorHide()
RememberListHide()
return 

+F1::
^F1::
helpText = 
(
V 0.5.1
##CommandSelector

ALT+SPACE : abre selector de comandos
CTRL+ALT+R : recarga comandos del config
CTRL+ALT+E : abre el archivo de comandos para editarlo/verlo
ESCAPE : oculta el selector de comandos

--------------------------------------------------------------

# Master command = (CTRL+ALT+SPACE = ALT GR+SPACE), SHIFT+SPACE

## Log Notes
Master command => LA: [Log add] agregar texto seleccionado al log

Master command => LI: [Log input] abre caja de texto para escribir directamente al log

Master command => LO: [Log open] abrir log del dia actual

Master command => LD: [Log date] abrir log por fecha del calendario


## Images Notes
Master command => CS: [Capture screen] agregar captura de pantalla al log de imagenes

Master command => CE: [Capture edit] envia CTRL+PrintScreen captura region con ShareX
Master command => CC: [Capture clipboard] guarda una imagen del portapapeles al log

Master command => CO: [Capture open] abrir log de imagenes del dia actual

Master command => CD: [Capture date] abrir log de imagenes por fecha del calendario

----------------------------------------------------------------
## REMEBER LIST

Master command => RA: [Remember add] agrega texto seleccionado a la lista
Master command => RO: [Remember open] abre listRemember.txt
ESCAPE : oculta la lista

irm : [Invoke Re-Member] muestra la lista para escoger el item a usar
Master command => RI : [Remember invoke] muestra la lista para escoger el item a usar
)
MsgBox, ,Help, %helptext%, 
Return