#NoEnv 
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%replaceFileSeparator:
   
#Include Ahk Resources\AhkLibs\json.ahk
#include CommandSelector\CommandSelector.ahk
InitCommandSelector("CommandSelector\commands-max.json")
#include LogNotesAndRememberList\LogNotesAndRememberList.ahk

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


^Del::
SendInput ^a
SendInput {Delete}
return

!Del::
SendInput +{Home}
SendInput {Delete}
return

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

--------------------------------------------------------------

## Log Notes

CTRL+ALT+L
WIN+SPACE => l: agregar texto seleccionado al log

WIN+SPACE => il: abre caja de texto para escribir directamente al log

CTRL+ALT+O
WIN+SPACE => o: abrir log del dia actual

CTRL+ALT+D 
WIN+SPACE => d: abrir log por fecha del calendario

CTRL+WIN+C : agregar captura de pantalla al log de imagenes

CTRL+WIN+O : abrir log de imagenes del dia actual

CTRL+WIN+D : abrir log de imagenes por fecha del calendario

----------------------------------------------------------------

## REMEBER LIST

ESCAPE : oculta la lista

CTRL+WIN+R : agrega texto seleccionado a la lista

ALT+WIN+R : abre listRemember.txt

irm : muestra la lista para escoger el item a usar

-------------------------------------------------------------

## Utilities HotKeys
CTRL+DEL : Delete all in file
ALT+DEL : Delete current line
)
MsgBox, ,Help, %helptext%, 
Return