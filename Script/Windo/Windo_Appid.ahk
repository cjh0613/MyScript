; appid.exe ֻ��ȡ����´��ڵ�Appid
Windo_getappid:
MouseMove, Windy_X, Windy_Y
happid:=Trim(JEE_RunGetStdOut(A_ScriptDir "\bin\appid.exe"), " `r`n")
msgbox % happid
return

Windo_SetWinAppId:
SetTimer, hovering, off
hovering_off:=1
; appid.exe ֻ��ȡ����´��ڵ� Appid�����Ե����˵�����껹��ԭ���ڲ��ܻ�ԭappid
MouseMove, Windy_X, Windy_Y
happid:=Trim(JEE_RunGetStdOut(A_ScriptDir "\bin\appid.exe"), " `r`n")
if !IsObject(appidobj)
	appidobj:={}
if happid
	appidobj[Windy_CurWin_id]:=happid
Appid:="My_Custom_Group"
setwinappid(Windy_CurWin_id, Appid)
hovering_off:=0
return

Windo_RestoreAppId:
if appidobj[Windy_CurWin_id]
{
	setwinappid(Windy_CurWin_id, appidobj[Windy_CurWin_id])
	appidobj[Windy_CurWin_id]:=""
}
return

Windo_AddAppIdToList2(iList, iListValue)
{
happid:=Trim(JEE_RunGetStdOut(A_ScriptDir "\bin\appid.exe"), " `r`n")
id:=TTLib.AddAppIdToList(iList, happid, iListValue)
;Tooltip % iList " - " happid " - " iListValue " - " id
return
}

Windo_AddAppIdToList(iList, iListValue)
{
happid:=TTLib.GetActiveButtonGroupAppid()
id:=TTLib.AddAppIdToList(iList, happid, iListValue)
;Tooltip % iList " - " happid " - " iListValue " - " id
return
}