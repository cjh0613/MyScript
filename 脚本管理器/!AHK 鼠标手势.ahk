/*
ԭ�ű��ѱ��޸�
���ߣ� �η�
��ַ�� http://ahk.5d6d.com/thread-1236-1-1.html
*/

#SingleInstance force
SetWorkingDir %A_ScriptDir%
IfNotExist MGConfig.ini
Newini=`n`nע��:`n�µ�Ĭ�������ļ�`nMGConfig.ini ������!`n`nʹ������ �� �� �� `n���Բ鿴˵��
FileInstall MGConfigDefault.ini,MGConfig.ini
#WinActivateForce
TrayTip AHK�������,��ӭʹ��AHK�������!!%Newini%,,1
SetTitleMatchMode 2
GroupAdd,ddd,- Microsoft Internet Explorer
GroupAdd,ddd,Mozilla Firefox
GroupAdd,ddd,ahk_class Afx:400000:3:10011:1900010:0
#IfWinNotActive, ahk_group ddd
loop
{
	IniRead ActName%A_Index%,MGConfig.ini,ActNames,%A_Index%
	IniRead act%A_Index%,MGConfig.ini,MouseGestures,%A_index%
	If (act%A_Index%="ERROR")
	{
		n:=A_Index-1
		Break
	}
}
Loop %n%
{
	LoopName:=ActName%A_Index%
	LoopAct:=act%A_Index%

	StringReplace LoopAct,LoopAct,R,��,A
	StringReplace LoopAct,LoopAct,L,��,A
	StringReplace LoopAct,LoopAct,U,��,A
	StringReplace LoopAct,LoopAct,D,��,A

	instructions=%instructions%%A_Index%.%A_Tab%%LoopAct%%A_Tab%%LoopName%`n`n
}
instructions=`n%instructions%`n`nע��:`n`n���е�1,2����ԵĴ���`n(�����ؼ�)�������������ʼ���µĴ���,`n������ ��ǰ����Ĵ���,������������Ҳ`n���ἤ��Ŀ�괰��!`n`n`n�η�`nzhangz.music@qq.com

Menu, Tray, Icon,shell32.dll,15
;Menu,tray,NoStandard
Menu,tray,add,�鿴˵��,instructions
Menu,tray,add,�������ļ� (��������),runini
Menu,tray,add,������������!,Reset
Menu,tray,add
Menu,tray,add,�˳�,GuiClose
Return

RButton::
MouseGetPos TX,TY,UMWID,UMC

Loop
{
	MouseGetPos TXX,TYY
	TR:=GetKeyState("RButton","P")
	XX:=TXX-TX
	YY:=TYY-TY
	DS:=Sqrt(XX*XX+YY*YY)
	If ((TR=0) And (DS<=20))
	{
		SendPlay {RButton}
		Break
	}
	If ((DS>20) And (TR=1))
	{
		Gosub Do
		Break
	}
}
If (GestureList=act1)
WinClose ahk_id%UMWID%
If (GestureList=act2)
WinMinimize ahk_id%UMWID%
If (GestureList=act3)
{
	SendEvent {LWin}
	WinWaitActive ����ʼ���˵�,,0.5
	;ControlClick Button1,����ʼ���˵�
}
If (GestureList=act4)
SendEvent {F5}
If (GestureList=act5)
TrayTip �������˵��,%instructions%,100
If (GestureList=act6)
{
WinGetClass, ActiveClass, A
If ActiveClass in ExploreWClass,IEFrame,CabinetWClass
{
    WinGetTitle, Title, A
    Send, {Backspace}
}
}
If (GestureList=act7)
sendinput, {Browser_Back}
If (GestureList=act8)
sendinput, {Browser_Forward}
GestureList=
;~ GroupAdd a
Return

instructions:
MsgBox,,�������˵��,%instructions%
Return

RunIni:
Run MGConfig.ini
Return

Reset:
MsgBox 262180,AHK �������,ȷ��Ҫ��������������?
IfMsgBox Yes
{
	FileDelete MGConfig.ini
	If (Errorlevel = 0)
	{
		MsgBox 64,AHK �������,ִ�гɹ�`n`n���򼴽���������!,10
		Reload
	}
	Else
	MsgBox 16,AHK �������,ִ��ʧ��`,�������ļ��Ѳ�����`n`n����������������!
}
Return

GuiClose:
ExitApp
Return

Do:
Loop %Count%
Gesture%A_Index%=
GestureList=

Count:=1
lx:=TX
ly:=TY
Loop
{
	Count2:=Count-1
	lastGesture:=Gesture%lastcount%
	TR:=GetKeyState("RButton","P")
	If TR=0
	Break
	Sleep 20
	MouseGetPos nx,ny
	xx:=nx-lx
	yy:=ny-ly
	DS:=Sqrt(XX*XX+YY*YY)
	If (ds<15)
	Continue
	identify()
	lx:=nx
	ly:=ny
	lastcount:=count-1
	If (Gesture%count%=Gesture%lastcount%)
	{
		Gesture%count%=
		Continue
	}
	If Gesture%count%=
	Continue
	index:=Gesture%Count%
	GestureList=%GestureList%%index%
	StringReplace rsuser,GestureList,R,��%A_Space%,A
	StringReplace rsuser,rsuser,L,��%A_Space%,A
	StringReplace rsuser,rsuser,U,��%A_Space%,A
	StringReplace rsuser,rsuser,D,��%A_Space%,A
	Loop %n%
	{
		If (GestureList=Act%A_Index%)
		{
			act:=ActName%A_Index%
			Break
		}
	}
	If (count > 3)
	noact=������ȡ��
	TrayTip ,AHK �������%A_Tab%%noact%,%rsuser%%A_Tab%%act%
	act=
	noact=
	count++
}
TrayTip

Return

identify()
{
	global
	If ((XX>0) And (XX>Abs(YY)*2))
	Gesture%Count%:="R"
	If ((XX<0) And (Abs(XX)>Abs(YY)*2))
	Gesture%Count%:="L"
	If ((YY>0) And (YY>Abs(XX)*2))
	Gesture%Count%:="D"
	If ((YY<0) And (Abs(YY)>Abs(XX)*2))
	Gesture%Count%:="U"
}