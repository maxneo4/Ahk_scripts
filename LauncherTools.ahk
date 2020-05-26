#NoEnv 
;#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%replaceFileSeparator:
   
#Include Ahk Resources\AhkLibs\json.ahk
#include CommandSelector\CommandSelector.ahk
#include LogNotesAndRememberList\LogNotesAndRememberList.ahk

;O ommit the end character
;* ommit to need end character	
;Bizagi developer hotStrings
::saf::select * from
::tcat::BABIZAGICATALOG
:*:wgi::where guidobject in(){Left 1}
::ij::inner join
::lj::left join
:O:btc::fnBA_DB_ClobToBlob(){Left 1}
:O:ctb::fnBA_DB_BlobToClob(){Left 1}
::obj::object
::gobj::guidobject

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

^F1::
helpText = 
(
##CommandSelector

ALT+SPACE : open command selector

--------------------------------------------------------------

## Log Notes

SHIFT+F1 : abre esta archivo para recordar los comandos

LOG DE NOTAS

CTRL+ALT+SPACE : agregar texto seleccionado al log

WIN+ALT+SPACE : abre caja de texto para escribir directamente al log

CTRL+ALT+O : abrir log del dia actual

CTRL+ALT+D : abrir log por fecha del calendario

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

## Custom Functions
CTRL+DEL : Delete all in file
ALT+DEL : Delete current line
)
MsgBox, ,Help, %helptext%, 
Return