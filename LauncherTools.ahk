#NoEnv 
;#Warn
#SingleInstance Force

SendMode Input

SetWorkingDir %A_ScriptDir%

#Include Ahk Resources\AhkLibs\json.ahk
#include CommandSelector\CommandSelector.ahk


SetWorkingDir %A_ScriptDir%

FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\LauncherToolsShortCut.lnk, %A_ScriptDir%

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

+F1::
helpText = 
(
Custom Functions
CTRL+DEL : Delete all in file
ALT+DEL : Delete current line
)
MsgBox, ,, %helptext%, 
Return