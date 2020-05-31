#NoEnv 
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%

global commandsPath = "CommandSelector\commands.json"

#Include Ahk Resources\AhkLibs\json.ahk
#Include Ahk Resources\AhkLibs\SelectedPath.ahk
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
:O:btc::fnBA_DB_ClobToBlob(){Left 1}
:O:ctb::fnBA_DB_BlobToClob(){Left 1}
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
##CommandSelector
ALT+SPACE : open command selector
ESCAPE : oculta la lista de comandos 
Default commands: [add selected item as new command(Select file/folder first in explorer)]

--------------------------------------------------------------
## Log Notes
CTRL+ALT+L
CTRL+SPACE => L: [Log] agregar texto seleccionado al log

CTRL+SPACE => IL: [Input log] abre caja de texto para escribir directamente al log

CTRL+ALT+O
CTRL+SPACE => O: [Open] abrir log del dia actual

CTRL+ALT+D 
CTRL+SPACE => D: [Date] abrir log por fecha del calendario

CTRL+SHIFT+C 
CTRL+SPACE => CS: [Capture screen] agregar captura de pantalla al log de imagenes

CTRL+SHIFT+O : 
CTRL+SPACE => CO: [Capture open] abrir log de imagenes del dia actual

CTRL+SHIFT+D 
CTRL+SPACE => CD: [Capture date] abrir log de imagenes por fecha del calendario

----------------------------------------------------------------
## REMEBER LIST
ESCAPE : oculta la lista

CTRL+WIN+R 
CTRL+SPACE => RA: [Remember add] agrega texto seleccionado a la lista

CTRL+WIN+O
CTRL+SPACE => RO: [Remember open] abre listRemember.txt

irm : [Invoke Re-Member] muestra la lista para escoger el item a usar
//DISABLED CTRL+SPACE => RI : [Remember invoke] muestra la lista para escoger el item a usar

)
MsgBox, ,Help, %helptext%, 
Return