; ��һ���ű��Ѿ�����ʱ������ٴδ�����
; �������Ի��򣬲��Զ������У��滻ԭ���򿪵Ľű�����
#SingleInstance force
#NoTrayIcon
; ̽�⡰����"�Ĵ���
DetectHiddenWindows, On
; ���ýű���ִ���ٶ�
SetBatchLines -1
ComObjError(0)
AutoTrim, On
SetWinDelay, 0
; ƥ��ģʽ ���ڱ��������ָ������ʱ����ƥ�� ��
SetTitleMatchMode 2
; ������������ģʽΪ�����������Ļ������ģʽ
CoordMode, Mouse, Screen

global run_iniFile := A_ScriptDir "\settings\setting.ini"
IfNotExist, %run_iniFile%
	FileCopy, %A_ScriptDir%\Backups\setting.ini, %run_iniFile%
global visable

IniRead, content, %run_iniFile%, ���ܿ���
Gosub, GetAllKeys

; �ڽű��ͷ������Reload��ͨʵ������#Include
; �Զ�����AutoIncludeAll.ahk
If Auto_Include
	Gosub, _AutoInclude

; ����ʱ�ű�������ȴ���60s
;Stime := A_TickCount
if (A_TickCount < 60000)
	sleep, % (60000 - A_TickCount)

; ����ԱȨ��
If(!A_IsAdmin)
{
	Loop %0%
		params .= " " (InStr(%A_Index%, " ") ? """" %A_Index% """" : %A_Index%)
	uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_AhkPath, str, """" A_ScriptFullPath """" params, str, A_WorkingDir, int, 1)
	If(uacrep = 42) ; UAC Prompt confirmed, application may Run as admin
		Tooltip, �ɹ����ù���ԱȨ��
	Else
		MsgBox, û�����ù���ԱȨ��
}

; �˳��ű�ʱ��ִ��ExitSub���ر��Զ������Ľű����ָ����ڵȵȲ�����
OnExit, ExitSub

;========�������ÿ�ʼ========
FileReadLine, AppVersion, %A_ScriptDir%\version.txt, 1
AppVersion := Trim(AppVersion)
AppTitle = ��ק�ƶ��ļ���Ŀ���ļ���(�Զ�������)

FloderMenu_iniFile = %A_ScriptDir%\settings\FloderMenu.ini
SaveDeskIcons_inifile = %A_ScriptDir%\settings\SaveDeskIcons.ini
update_txtFile = %A_ScriptDir%\settings\tmp\CurrentVersion.txt
ScriptManager_Path = %A_ScriptDir%\�ű�������

global Candy_ProFile_Ini := A_ScriptDir . "\settings\candy\[candy].ini"
SplitPath, Candy_ProFile_Ini,, Candy_Profile_Dir,, Candy_ProFile_Ini_NameNoext
global Windy_Profile_Ini := A_ScriptDir . "\settings\Windy\Windy.ini"
SplitPath, Windy_Profile_Ini,, Windy_Profile_Dir,, Windy_Profile_Ini_NameNoext
global 7PlusMenu_ProFile_Ini := A_ScriptDir . "\settings\7PlusMenu.ini"

;---------Alt+���ֵ������������ɫ---------
Random, ColorNum, 0, 6
;BarColor := SubStr("6BD536FFFFFFC7882DFFCD00D962FFFF55554FDCFF", ColorNum*6+1, 6)
BarColor := SubStr("FFFF000CFF0C0C750CD962FFFF55554FDCFF1187FF", ColorNum*6+1, 6)
StringLeft, ColorLeft, BarColor, 2
StringRight, ColorRight, BarColor, 2
BarColor := SubStr(BarColor, 3, 2)
BarColor := ColorRight . BarColor . ColorLeft

; -------------------
; START CONFIGURATION
; -------------------
; The percentage by which to raise or lower the volume each time
vol_Step = 8
; How long to display the volume level bar graphs (in milliseconds)
vol_DisplayTime = 1000
; Transparency of window (0-255)
vol_TransValue = 255
; Bar's background colour
vol_CW = EEEEEE
vol_Width = 200  ; width of bar
vol_Thick = 20   ; thickness of bar
; Bar's screen position
vol_PosX := A_ScreenWidth - vol_Width - 90
vol_PosY := A_ScreenHeight - vol_Thick - 72
; --------------------
; END OF CONFIGURATION
; --------------------
vol_BarOptionsMaster = 1:B1 ZH%vol_Thick% ZX8 ZY4 W%vol_Width% X%vol_PosX% Y%vol_PosY% CW%vol_CW%
;---------Alt+���ֵ������������ɫ---------

; ���̲˵��д򿪰����ļ���spyʱ��ָ��·�����ж�����ͼ��ָ��������
; ��Autohotkey.exe������·���ָ����Autohotkey.exe����Ŀ¼��·��Ϊ"Ahk_Dir"
Splitpath,A_AhkPath,Ahk_FileName,Ahk_Dir

; ���ϵͳ�汾
; �汾��>6  Vista7Ϊ��(1)
RegRead, Vista7, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion, CurrentVersion
global Vista7 := Vista7 >= 6.0.7

;---------ˮƽ��ֱ���---------
VarSetCapacity(work_area, 16)
DllCall("SystemParametersInfo"
         , "uint", 0x30                                          ; SPI_GETWORKAREA
         , "uint", 0
         , "uint", &work_area    ;�ṹ��0��8��4��12  NumGet(work_area,8)
         , "uint", 0 )

; ��ȡ���������
work_area_w := NumGet(work_area, 8) - NumGet(work_area, 0)
; ��ȡ���������,�������������߶�
work_area_h := NumGet(work_area, 12) - NumGet(work_area, 4)
;----------------------------------ˮƽ��ֱ���----------------------------

x_x2 := work_area_w - 634
y_y2 := work_area_h - 108

; ����رյ���Դ����������
global CloseWindowList := []
global ClosetextfileList := []
global folder := []
global textfile := [] 
IniRead, content, %run_iniFile%, CloseWindowList
CloseWindowList := StrSplit(content, "`n")
Array_Sort(CloseWindowList)

IniRead, content, %run_iniFile%, ClosetextfileList
ClosetextfileList := StrSplit(content, "`n")
Array_Sort(ClosetextfileList)

; Candy��Windy
global szMenuIdx := {}      ; �˵���1
global szMenuContent := {}      ; �˵���2
global szMenuWhichFile := {}      ; �˵���3
;=========�������ý���=========

;=========��ȡ�����ļ���ʼ=========
IniRead, stableProgram, %run_iniFile%, �̶��ĳ���, stableProgram
IniRead, historyData, %run_iniFile%, �̶��ĳ���, historyData
IniRead, ѯ��, %run_iniFile%, ��ͼ, ѯ��
IniRead, filetp, %run_iniFile%, ��ͼ, filetp
IniRead, screenshot_path, %run_iniFile%, ��ͼ, ��ͼ����Ŀ¼
IniRead, TargetFolder, %run_iniFile%, ·������, TargetFolder

IniRead, content, %run_iniFile%, ��Ϊ������
Gosub, GetAllKeys

IniRead, content, %run_iniFile%, �Զ���ʾ���ش���
Gosub, GetAllKeys

IniRead, content, %run_iniFile%, ����
Gosub, GetAllKeys

IniRead, content, %run_iniFile%, ����ģʽѡ��
Gosub, GetAllKeys

IniRead, content, %run_iniFile%, �Զ�����
Gosub, GetAllKeys

IniRead, content, %run_iniFile%,ʱ��
Gosub, GetAllKeys

; ��ȡ�Զ���ĳ���
IniRead, content, %run_iniFile%, otherProgram
Gosub, GetAllKeys

If TargetFolder
{
	IfnotExist, %TargetFolder%
	{
		TargetFolder =
		IniWrite, %TargetFolder%, %run_iniFile%, ·������, TargetFolder
	}
}
IniRead, LastClosewindow, %run_iniFile%, ·������, LastClosewindow
If LastClosewindow
{
	IfnotExist, %LastClosewindow%
	{
		LastClosewindow=
		IniWrite, %LastClosewindow%, %run_iniFile%, ·������, LastClosewindow
	}
}

;----------��������ͼ----------
If Auto_MiniMizeOn
{
	IniRead, content, %run_iniFile%, ��������ͼ
	Gosub, GetAllKeys

	MiniMizeNum = 50
	ffw := fw-5 ; ����ͼ�������ͼƬ��
	fx2 := A_ScreenWidth - fw
	fy2 := A_ScreenHeight - fh - 35

	If shuipingxia
	fy := fy2      ; ˮƽ����ʱ����Yֵ
	If shuzhiyou
	fx := fx2      ; ��ֱ���ұ�����ʱ����Xֵ
	iconx := fw - 48
	icony := fh - 48
}
;----------��������ͼ----------

IniRead, content, %run_iniFile%, FastFolders
Gosub, GetAllKeys

IniRead content, %run_iniFile%, AudioPlayer
loop, parse, content, `n
{
	Temp_key := RegExReplace(A_LoopField, "=.*?$")
	Temp_Val := RegExReplace(A_LoopField, "^.*?=")
	%Temp_key% = %Temp_Val%
	menu, audioplayer, add, %Temp_key%, DPlayer
}
Temp_key := Temp_Val := content := ""
;=========��ȡ�����ļ�����=========

;=========���̲˵�����=========
;----------����AHK�ű������������̲˵�----------
Menu scripts_unopen, Add, �����ű�, nul
Menu scripts_unopen, ToggleEnable, �����ű�
Menu scripts_unopen, Default, �����ű�
Menu scripts_unopen, Add
Menu scripts_unclose, Add, �رսű�, nul
Menu scripts_unclose, ToggleEnable, �رսű�
Menu scripts_unclose, Default, �رսű�
Menu scripts_unclose, Add
Menu scripts_edit, Add, �༭�ű�, nul
Menu scripts_edit, ToggleEnable, �༭�ű�
Menu scripts_edit, Default, �༭�ű�
Menu scripts_edit, Add
Menu scripts_reload, Add, ���ؽű�,nul
Menu scripts_reload, ToggleEnable, ���ؽű�
Menu scripts_reload, Default, ���ؽű�
Menu scripts_reload, Add

; AHK�ű���������ʼ����ֵ
scriptCount = 0
; ����"�ű�������"Ŀ¼������ahk�ļ�
Loop, %ScriptManager_Path%\*.ahk
{
	StringRePlace menuName, A_LoopFileName, .ahk

	scriptCount += 1
	scripts%scriptCount%0 := A_LoopFileName

	IfWinExist %A_LoopFileName% - AutoHotkey    ; �Ѿ���
	{
		Menu, scripts_unclose, add, %menuName%, tsk_close
		scripts%scriptCount%1 = 1
	}
	Else
	{
		Menu, scripts_unopen, add, %menuName%, tsk_open
		scripts%scriptCount%1 = 0
	}
	Menu, scripts_edit, add, %menuName%, tsk_edit
	Menu, scripts_reload, add, %menuName%, tsk_reload
}

; ��"�ű�������"Ŀ¼�е��ӽű�,��"!"��ͷ�Ľű������Զ���.
GoSub tsk_openAll
; ��������ʱ��
;ElapsedTime := A_TickCount - StartTime
;msgbox % ElapsedTime

;----------���̲˵�----------
; �˵�������ʾ��Ӱ��ű������в˵�������candy��ȡ����ͼ�겻�ᱨ��
Menu, Tray, UseErrorLevel
Menu, Tray, Icon,%A_ScriptDir%\pic\run.ico
Menu, Tray, add, ��(&O), Open1
Menu, Tray, add, ����(&H), Help
Menu, Tray, add, &Windows Spy, Spy
Menu, Tray, Add
Menu, Tray, Add, Ahk �ű�������,nul
Menu, Tray, disable, Ahk �ű�������
Menu, Tray, Add
Menu, Tray, Add, �������нű�(&A)`t, tsk_openAll
Menu, Tray, Add, �����ű�(&Q)`t, :scripts_unopen
Menu, Tray, Add, �ر����нű�(&L)`t, tsk_closeAll
Menu, Tray, Add, �رսű�(&C)`t, :scripts_unclose
Menu, Tray, Add
Menu, Tray, Add, �༭�ű�(&I)`t, :scripts_edit
Menu, Tray, Add, ���ؽű�(&D)`t, :scripts_reload
Menu, Tray, Add
Menu, Tray, Add, ���� - Ahk,nul
Menu, Tray, disable, ���� - Ahk
Menu, Tray, Add
Menu, Tray, Add, �����ű�(&R)`tCtrl+R, �����ű�
Menu, Tray, Add, �༭�ű�(&E), �༭�ű�
Menu, Tray, Add
Menu, Tray, add, ���������ȼ�(&S)`tAlt+Pause, ���������ȼ�
Menu, Tray, add, ��ͣ�ű�(&P)`tPause, ��ͣ�ű�
Menu, Tray, Add, ѡ��(&T)`tCtrl+P, ѡ��
Menu, Tray, Add, �˳�(&X)`t, Menu_Tray_Exit
Menu, Tray, Add
Menu, Tray, Add, ��ʾ/����`tWin+X,show
Menu, Tray, Default, ��ʾ/����`tWin+X
Menu, Tray, Add
Menu, Tray, NoStandard
Menu, Tray, Click, 1
Menu, Tray, Tip, ���� - Ahk(For Win_7)`n�ڶ�ʵ��Ahk�ű��ĺϼ���
;----------���̲˵�----------
;=========���̲˵�����=========

;=========�������"����"=========
ComboBoxShowItems :=stableProgram . historyData

;master_mute:=VA_GetMute()
SoundGet, master_mute,, mute
If(master_mute = "on")
; color = red
	volimage = %A_ScriptDir%\pic\m_vol.ico
Else
; color = green
	volimage = %A_ScriptDir%\pic\vol.ico

menu, audioplayer, Check,%DefaultPlayer%

Process, Exist, %DefaultPlayer%.exe
If ErrorLevel = 0
	Image = %A_ScriptDir%\pic\MusicPlayer\%DefaultPlayer%.bmp
Else
	Image = %A_ScriptDir%\pic\MusicPlayer\h_%DefaultPlayer%.bmp

; ͼ�ν����"����"
; ����  +����С����ť���������ް�ť��
Gui,  +HwndHGUI +ToolWindow
Gui, Add, Text, x1 y10 w90 h20 +Center, Ŀ��/����:
Gui, Add, ComBoBox, x90 y10 w330 h300 +HwndhComBoBox vDir, % ComBoBoxShowItems
ControlGet, ahMyEdit, hWnd,, Edit1, ahk_id %HGUI%
DllCall("Shlwapi.dll\SHAutoComplete", "Ptr", ahMyEdit, "UInt", 0x1|0x10000000)  ; ֻ�Ա༭�ؼ���Ч
global hComBoBox
global objListIDs:= Object() 
global del_ico:=0 ; 0= text "X", 1= icon
global single_ico:=0
fn := Func("List_Func").Bind(hComBoBox)
GuiControl, +g, % hComBoBox, % fn
Gui, Add, Button, x425 y10 gselectfile, &.
Gui, Add, Button, x445 y10 gselectfolder, ѡ��(&S)
Gui, Add, Button, x500 y10 default gopenbutton, ��(&O)
Gui, Add, Button, x555 y10 gabout, ����(&A)
Gui, Add, Button,x445 y35  gaddfavorites, �����ղ�
Gui, Add, Button,x515 y35  gshowfavorites, >
Gui, Add, Button,x555 y35 gliebiao, �б�(&L)
Gui, Add, Picture, x90 y35 w16 h16 gOpenAudioPlayer vpicture, %image%
AddGraphicButton(1,"x108","y32","h21","w40","GB1", A_ScriptDir . "\pic\MusicControl\prev.bmp",A_ScriptDir . "\pic\MusicControl\h_prev.bmp" ,A_ScriptDir . "\pic\MusicControl\d_prev.bmp")
AddGraphicButton(1,"x147","y32","h21","w40","GB2", A_ScriptDir . "\pic\MusicControl\pause.bmp",A_ScriptDir . "\pic\MusicControl\h_pause.bmp" ,A_ScriptDir . "\pic\MusicControl\d_pause.bmp")
AddGraphicButton(1,"x186","y32","h21","w40","GB3", A_ScriptDir . "\pic\MusicControl\next.bmp",A_ScriptDir . "\pic\MusicControl\h_next.bmp" ,A_ScriptDir . "\pic\MusicControl\d_next.bmp")
AddGraphicButton(1,"x225","y32","h21","w40","GB4", A_ScriptDir . "\pic\MusicControl\close.bmp",A_ScriptDir . "\pic\MusicControl\h_close.bmp" ,A_ScriptDir . "\pic\MusicControl\d_close.bmp")
Gui, Add, Picture, x285 y35 w16 h16 gmute vvol, %volimage%
Gui, Add, Slider, x300 y35 w100 h20 vVSlider Range0-100 gVolumeC
Gui, Add, Text, x10 y30 cblue, ����
Gui, Add, Text, x10 y45 cblue, USB
Gui, Add, Text, x40 y30 cgreen vopenCD gdriver, ��
Gui, Add, Text, x40 y45 cgreen g����U��, ����
Gui, Add, Text, x60 y30 cgreen gdriver, ��
Gui, Add, Text, x10 y64 cgreen gchangyong, ����
Gui, Add, Text, x100 y64 cgreen gDesktoplnk, ����
Gui, Add, Text, x200 y64 cgreen vfhc gfoo_httpcontrol_click, Foo_HttpControl
Gui, Add, Text, x340 y64 cgreen gIEfavorites, IE�ղؼ�

;----------����----------
SoundGet,vol_Master
;vol_Master := VA_GetMasterVolume()
;RSound := Round(vol_Master)
Guicontrol,,VSlider,%vol_Master%

Process, Exist, %DefaultPlayer%.exe
If ErrorLevel = 0
	GuiControl, Disable,fhc
Else
{
	If (DefaultPlayer="Foobar2000")
	{
		If WinExist("foo_httpcontrol")
			GuiControl,Enable,fhc
	}
}

Menu,  addf, Add, ��������, runwithsys
Menu,  addf, Add, ���������, smartchooserbrowser
Menu,  addf, Add, �Զ������(��ʱ), _TrayEvent
Menu,  addf, Add, ����ʱ��������ͼ��,AutoSaveDeskIcons
Menu,  addf, Add, ��������ͼ��, SaveDesktopIconsPositions
Menu,  addf, Add, �ָ�����ͼ��, RestoreDesktopIconsPositions

if Auto_DisplayMainWindow
{
	Gui, Show, x%x_x% y%y_y% w624 h78, %AppTitle%
	visable = 1
}
else
{
	�Ƿ���:=0
	Gui, Show, hide x%x_x% y%y_y% w624 h78, %AppTitle%
	visable= 0
}
;=========ͼ�ν����"����"=========

;=========ͼ�ν����"����"2=========
If Auto_runwithsys
{
	Menu, addf, Check, ��������
}
Else
{
	Menu, addf, UnCheck, ��������
}

If Auto_smartchooserbrowser
{
	Menu, addf, Check,���������
	writeahkurl()
}
Else
{
	Menu, addf, UnCheck, ���������
}

If (Auto_SaveDeskIcons=1)
{
	Menu, addf, Check, ����ʱ��������ͼ��
	Timer_SDIP := 1
	SetTimer,SaveDesktopIconsPositions,30000
	Menu, addf, Disable,  �ָ�����ͼ��
}
Else
{
	Menu, addf, UnCheck, ����ʱ��������ͼ��
	IfNotExist,%SaveDeskIcons_inifile%
	Menu, addf, Disable,  �ָ�����ͼ��
}

;������,ͼƬ��ť�����Ч��
OnMessage(0x200, "MouseMove")
OnMessage(0x201, "MouseLdown")
OnMessage(0x202, "MouseLUp")
;OnMessage(0x202, "MouseLeave")
;OnMessage(0x2A3, "MouseLeave")
;��������򴰿��Ҽ���������˵�
OnMessage(0x205, "RBUTTONUP")
;����U�̲���
OnMessage(0x0219, "WM_DEVICECHANGE")
;����ShellExtension.dll���ݵ���Ϣ
if Auto_7plusMenu
	OnMessage(55555, "TriggerFromContextMenu")
DllCall("ChangeWindowMessageFilter", "UInt", 55555, "UInt", 1)

;�������ԭ��������ͼ��ק�ƶ��Ĵ������Ѳ���
;OnMessage(0x201, "WM_LBUTTONDOWN")

;��ק�ļ�����ִ�к���
GuiDropFiles.config(HGUI, "GuiDropFiles_Begin", "GuiDropFiles_End")
;��ק��ComboBox��Edit1�ؼ��ϲ������ļ�
ControlGet,hComboBoxEdit,hWnd,,Edit1,ahk_id %HGUI%
;=========ͼ�ν����"����"2=========

;----------����ʾ����ͼ���������ű�----------
; �ȴ���������100s���ɸ�����Ҫ���ã�ʹ����ͼ�������ʾ����
if Auto_Trayicon
{
	While (100000 - A_TickCount) > 0
		sleep,100
	Menu, Tray, Icon
	Script_pid:=DllCall("GetCurrentProcessId")
	Tray_Icons := {}
	Tray_Icons := TrayIcon_GetInfo(Ahk_FileName)
	for index, Icon in Tray_Icons
	{
		trayicons_pid .= Icon.Pid ","
	}

	If trayicons_pid not contains %Script_pid%
	{
		Menu, Tray, NoIcon
		sleep,300
		Menu, Tray, Icon
		Tray_Icons := {}
		trayicons_pid := ""
		Tray_Icons := TrayIcon_GetInfo(Ahk_FileName)
		for index, Icon in Tray_Icons
		{
			trayicons_pid .= Icon.Pid ","
		}
	}

	If trayicons_pid not contains %Script_pid%
	{
		if Auto_Trayicon_showmsgbox
		{
			msgbox,4,����,δ��⵽�ű�������ͼ�꣬��"��"�����ű�����"��"�������нű���`nĬ��(��ʱ)�Զ������ű���,6
			IfMsgBox Yes
				Auto_reload=1
			else IfMsgBox timeout
				Auto_reload=1
		}
		else
			Auto_reload=1

		������������:=CF_IniRead(run_iniFile,"ʱ��","������������",0)
		if ������������ > 5
		{
			IniWrite,0,% run_iniFile,ʱ��,������������
			IniWrite,0,% run_iniFile,���ܿ���,Auto_Trayicon
			Msgbox �ű�������ж����ܼ�⵽����ͼ�꣬�ű��´����������ټ������ͼ�ꡣ
		}
		else
		{
			������������ += 1
			IniWrite,% ������������,% run_iniFile,ʱ��,������������
		}

		if(Auto_reload=1)
		{
			sleep,2000
			Reload
		Return
		}
	}
}
else  ; ֱ����ʾͼ��, �������ͼ���Ƿ���ʾ����
	Menu, Tray, Icon

if Auto_FuncsIcon
{
	IniRead, content, %run_iniFile%, 101
	Gosub, GetAllKeys
	TrayIcon_Add(hGui, "OnTrayIcon", Ti_101_icon, Ti_101_tooltip)
	IniRead, content, %run_iniFile%, 102
	Gosub, GetAllKeys
	TrayIcon_Add(hGui, "OnTrayIcon", Ti_102_icon, Ti_102_tooltip)
}
;----------����ʾ����ͼ���������ű�----------

;=========���ڷ���=========
;���ν����棬��ʾ���棬�ҵĵ��ԣ���Դ������,���Ϊ���ڼ���"��" "ccc"��,Ӧ���ڶ�λ�ļ�,����·��,������������
GroupAdd, ccc, ahk_class CabinetWClass
GroupAdd, ccc, ahk_class ExploreWClass
GroupAdd, ccc, ahk_class Progman
GroupAdd, ccc, ahk_class WorkerW
GroupAdd, ccc, ahk_class #32770

; ��������ַ���롢runhistory  #ifwinactive  ���ܽӱ���
GroupAdd, AppMainWindow,%AppTitle%

GroupAdd, ExplorerGroup, ahk_class CabinetWClass
GroupAdd, ExplorerGroup, ahk_class ExploreWClass
GroupAdd, DesktopGroup, ahk_class Progman
GroupAdd, DesktopGroup, ahk_class WorkerW
GroupAdd, DesktopTaskbarGroup,ahk_class Progman
GroupAdd, DesktopTaskbarGroup,ahk_class WorkerW
GroupAdd, DesktopTaskbarGroup,ahk_class Shell_TrayWnd
GroupAdd, DesktopTaskbarGroup,ahk_class BaseBar
GroupAdd, DesktopTaskbarGroup,ahk_class DV2ControlHost

GroupAdd, GameWindows,ahk_class Warcraft III
GroupAdd, GameWindows,ahk_class Valve001
;=========���ڷ���=========

;=========���ܼ��ؿ�ʼ=========
;----------Folder Menu----------
f_Icons = %A_ScriptDir%\pic\foldermenu.ico

IfNotExist, %FloderMenu_iniFile%	;If config file doesn't exist
{
	f_ErrorMsg = %f_ErrorMsg% �����ļ���Ҫ����.`nʹ��Ĭ�������ļ�.`n
	FileCopy,%A_ScriptDir%\Backups\FloderMenu.Ini,%FloderMenu_iniFile%
}

f_ReadConfig()
f_SetConfig()

gui_hh = 0
gui_ww = 0
;----------Folder Menu----------

;----------�����ļ�MD5ģʽѡ��----------
If md5type=1
	hModule_Md5 := DllCall("LoadLibrary", "str", A_ScriptDir "\MD5Lib.dll")
;----------�����ļ�MD5ģʽѡ��----------

;----------7plus�Ҽ��˵�----------
if Auto_7plusMenu
{
	FileCreateDir %A_Temp%\7plus
	FileDelete, %A_Temp%\7plus\hwnd.txt
	FileAppend, %hGui%, %A_Temp%\7plus\hwnd.txt
}
;----------7plus�Ҽ��˵�----------

;----------���Ӵ��ڴ����ر���Ϣ��7plus�Ҽ��˵�֮���´򿪹رյĴ��� Windo�˵�----------
IniRead,CloseWindowList_showmenu,%run_iniFile%,1007,showmenu
if CloseWindowList_showmenu
{
	DllCall("RegisterShellHookWindow","uint",hGui)
	OnMessage(DllCall("RegisterWindowMessageW","str","SHELLHOOK"),"ShellWM")
}
;----------���Ӵ��ڴ����ر���Ϣ��7plus�Ҽ��˵�֮���´򿪹رյĴ��� Windo�˵�----------

;----------��ַ����ClassNN:edit1��ӡ�ճ�����򿪡����Ҽ��˵�----------
If Auto_PasteAndOpen
{
	hMenu:=
	hwndNow:=
;constants
	MFS_ENABLED = 0
	MFS_CHECKED = 8
	MFS_DEFAULT = 0x1000
	MFS_DISABLED = 2
	MFS_GRAYED = 1
	MFS_HILITE = 0x80
; ����Ҽ��˵�������ӡ�ճ�����򿪡��˵���Ŀ
; �Ҽ� ճ������
	HookProcAdr := RegisterCallback( "HookProcMenu", "F" )
	hWinEventHook := SetWinEventHook( 0x4, 0x4,0, HookProcAdr, 0, 0, 0 )   ;0x4 EVENT_SYSTEM_MENUSTART
}
;----------��ַ����ClassNN:edit1��ӡ�ճ�����򿪡����Ҽ��˵�----------

;----------���ӹػ��Ի����ѡ��----------
;���عػ�
If Auto_ShutdownMonitor
{
	ShutdownBlock := true
	; HKEY_CURRENT_USER, Control Panel\Desktop, AutoEndTasks, 0
	; AutoEndTasks ֵΪ 1, ��ʾ�ػ�ʱ�Զ��������� 
	; AutoEndTasks ֵΪ 0, Vista+ �ػ�ʱ��ʾ�Ƿ��������
	RegWrite, REG_SZ,HKEY_CURRENT_USER, Control Panel\Desktop, AutoEndTasks, 0
	; ������ֹϵͳ�ػ���API
	Temp_Value:=DllCall("User32.dll\ShutdownBlockReasonCreate", "uint", hGui, "wstr", A_ScriptFullPath " ��������, �Ƿ�ȷ���ػ���")
	if !Temp_Value
		CF_ToolTip("ShutdownBlockReasonCreate ����ʧ�ܣ������룺 " A_LastError,3000)
	; �ػ�ʱ��һ����Ӧ����Ҫʹ�ű���Ϊ���һ��Ҫ��ֹ�Ľ��̣��� "0x4FF" ��Ϊ "0x0FF".
	Temp_Value :=DllCall("kernel32.dll\SetProcessShutdownParameters", UInt, 0x4FF, UInt, 0)
	if !Temp_Value
		CF_ToolTip("SetProcessShutdownParameters ʧ�ܣ�", 3000)
	; ���ӹػ��Ի����ѡ��
	HookProcAdr2 := RegisterCallback( "HookProc", "F" )
	hWinEventHook2 := SetWinEventHook(0x1, 0x17,0, HookProcAdr2, 0, 0, 0)
	if !hWinEventHook2
		CF_ToolTip("ע����ӹػ�ʧ��",3000)
	OnMessage(0x11, "WM_QUERYENDSESSION")
	;OnMessage(0x16, "WM_ENDSESSION")
}
;----------���ӹػ��Ի����ѡ��----------

; ������Ŀ���ɾ��ͼ��
Gosub, Combo_WinEvent

;----------���㱨ʱ����----------
If baoshionoff
{
	If baoshilx
		SetTimer, JA_VoiceCheckTime, 1000
	Else
		SetTimer, JA_JowCheckTime, 1000
}

If renwu
	SetTimer, renwu, 30000

If renwu2
	SetTimer, renwu2, 30000
;----------���㱨ʱ����----------

;----------�����ʾ----------
If Auto_mousetip
	SetTimer,aaa,2000
;----------�����ʾ----------

;ÿ5����foobar2000�Ƿ����У���ʾ��ͬ��ͼ��,���ϵͳ����������������
settimer,���,2000
if !�Ƿ���
	settimer,���,off

;----------��������Զ������----------
If(Auto_Raise=1)
	SetTimer, hovercheck, 100

;��ĳЩ���ڴ���ʱ�������ͣ����ֱ�ӷ���
Loop, parse, DisHover, `,
	GroupAdd, ExistDisableHover, ahk_class %A_LoopField%

;��ĳЩ���ڼ���ʱ�������ͣ����ֱ�ӷ���
Loop, parse, ActDisHover, `,
	GroupAdd, ActiveDisableHover, ahk_class %A_LoopField%
;----------��������Զ������----------

;----------�ڴ��Ż�----------
AppList:="QQ.exe|chrome.exe|foobar2000.exe"
SetTimer,FreeAppMem,300000
;----------�ڴ��Ż�----------

;----------Pin2Desk----------
Gosub,cSigleMenu
;----------Pin2Desk----------
;=========���ܼ��ؽ���=========

;=========�ȼ�����=========
Hotkey, IfWinActive ; �ݴ�
IniRead,  hotkeycontent, %run_iniFile%,��ݼ�
hotkeycontent:="[��ݼ�]" . "`n" . hotkeycontent
myhotkey := IniObj(hotkeycontent,OrderedArray()).��ݼ�
for k,v in myhotkey
{
	IfInString,k,ǰ׺_
		continue
	Else IfInString,k,�ض�����_
		Hotkey, IfWinActive, %v%
	Else IfInString,k,�ų�����_
		Hotkey, IfWinNotActive, %v%
	Else If (v && !InStr(v,"@"))
	{
		if islabel(k)
			hotkey, %v%,%k% ;,UseErrorLevel
	}
}
Hotkey, IfWinActive
Hotkey, IfWinNotActive
If ErrorLevel
	TrayTip, ���ִ���,ִ�п�ݼ�ʱ���������������ÿ�ݼ���ز���, , 3

If !Auto_MiniMizeOn
{
	Hotkey, IfWinNotActive, ahk_group DesktopTaskbarGroup
	Hotkey,% myhotkey.��������ͼ, Off
	Hotkey, IfWinNotActive
}

IniRead,  hotkeycontent, %run_iniFile%,Plugins
hotkeycontent:="[Plugins]" . "`n" . hotkeycontent
Pluginshotkey := IniObj(hotkeycontent,OrderedArray()).Plugins
for k,v in Pluginshotkey
If v
	hotkey, %v%,Plugins_Run ;,UseErrorLevel

FileGetTime,transT,%A_ScriptDir%\settings\translist.ini
translist:=IniObj(A_ScriptDir "\settings\translist.ini").����

;;;;;;;;;; ������  ;;;;;;;;;;;;

;����ʱ  
;����1������2������3������1
;ճ��ʱ
;1��3��2��1
;2��1��3��2
;3��2��1��3
if Auto_Clip
{
	first := f_repeat := clipid := monitor := 0
	writecliphistory := 1
	Array_Cliphistory:=[]
	st:=A_TickCount
	SetTimer, shijianCheck, 50
	if Auto_Cliphistory
	{
		global DB := new SQLiteDB
		if !DB
			Auto_Cliphistory:=0
		else
		{
			global DBPATH:= A_ScriptDir . "\Settings\cliphistory.db"
			global PREV_FILE := A_ScriptDir . "\Settings\tmp\prev.html" 
			STORE:={}

			if (!FileExist(DBPATH))
				isnewdb := 1
			else
				isnewdb := 0

			if (!DB.OpenDB(DBPATH))
				MsgBox, 16, SQLite����, % "��Ϣ:`t" . DB.ErrorMsg . "`n����:`t" . DB.ErrorCode

			sleep,300
			if (isnewdb == 1)
				migrateHistory()
		}
	}
}
else
	hotkey,$^V,off
;;;;;;;;;; ������  ;;;;;;;;;;;;

;��ݼ���C,D,E,F��...�������ݼ���loop 15ѭ��15�Σ�������ĸQ
if islabel("ExploreDrive") && !InStr(myhotkey.ǰ׺_���ٴ򿪴���,"@")
{
	Loop 15
		HotKey % myhotkey.ǰ׺_���ٴ򿪴��� Chr(A_Index+66), ExploreDrive
}

if !InStr(myhotkey.ǰ׺_С�����ƶ�����,"@") || !InStr(myhotkey.ǰ׺_С�����ƶ�ǰһ������,"@")
{
;----------Winpad----------
WindowPadInit:
; Exclusion examples:
	GroupAdd, GatherExclude, ahk_class SideBar_AppBarWindow
; These two come in pairs for the Vista sidebar gadgets:
	GroupAdd, GatherExclude, ahk_class SideBar_HTMLHostWindow   ; gadget content
	GroupAdd, GatherExclude, ahk_class BasicWindow              ; gadget shadow/outline
	GroupAdd, GatherExclude, ahk_class Warcraft III

; Win+Numpad      = Move active window
	Prefix_Active := myhotkey.ǰ׺_С�����ƶ�����
; Alt+Win+Numpad  = Move previously active window
	Prefix_Other  := myhotkey.ǰ׺_С�����ƶ�ǰһ������

; Note: Shift (+) should not be used, as +Numpad is hooked by the OS
;   to do left/right/up/down/etc. (reverse Numlock) -- at least on Vista.
; Numlock ��ʱ Shift+Numpad8 ��ͬ�� Shift+Up
; Numlock �Ʋ���ʱ��С���������ܿ����������ң�����

/*
;�Ƴ�EasyKey
EasyKey = Insert    ; Insert is near Numpad on my keyboard...
;�Ƴ�EasyKey
*/

; Note: Prefix_Other must not be a sub-string of Prefix_Active.
;       (If you want it to be, first edit the line "If (InStr(A_ThisHotkey, Prefix_Other))")

; Width and Height Factors for Win+Numpad5 (center key.)
	CenterWidthFactor   = 1.0
	CenterHeightFactor  = 1.0

	Hotkey, IfWinActive ; in case this is included in another script...

;Win+ numpad 1-9   Alt+Win+Numpad 1-9 �ƶ��ı䴰��λ�ô�С
	Loop, 9
	{   ; Register hotkeys.
		Hotkey, %Prefix_Active%Numpad%A_Index%, DoMoveWindowInDirection
		Hotkey, %Prefix_Other%Numpad%A_Index%, DoMoveWindowInDirection
    ; OPTIONAL
/*
;�Ƴ�EasyKey
		If EasyKey
			Hotkey, %EasyKey% & Numpad%A_Index%, DoMoveWindowInDirection
;�Ƴ�EasyKey
*/
	}

;Win+ numpad 0  ��󻯴���
	Hotkey, %Prefix_Active%Numpad0, DoMaximizeToggle
	Hotkey, %Prefix_Other%Numpad0, DoMaximizeToggle
;NumpadDot "."
	Hotkey, %Prefix_Active%NumpadDot, MoveWindowToNextScreen
	Hotkey, %Prefix_Other%NumpadDot, MoveWindowToNextScreen
;NumpadDiv "/"   NumpadMult "*"
	Hotkey, %Prefix_Active%NumpadDiv, GatherWindowsLeft
	Hotkey, %Prefix_Active%NumpadMult, GatherWindowsRight

/*
;�Ƴ�EasyKey
	If (EasyKey) {
		Hotkey, %EasyKey% & Numpad0, DoMaximizeToggle
		Hotkey, %EasyKey% & NumpadDot, MoveWindowToNextScreen
		Hotkey, %EasyKey% & NumpadDiv, GatherWindowsLeft
		Hotkey, %EasyKey% & NumpadMult, GatherWindowsRight
		Hotkey, *%EasyKey%, SendEasyKey ; let EasyKey's original function work (on release)
	}
;�Ƴ�EasyKey
*/
;----------Winpad----------
}

if !InStr(myhotkey.ǰ׺_�������������л�,"@") || !InStr(myhotkey.ǰ׺_���ܼ����͵���������,"@")
;----------��������----------
Loop, 4
{
	Hotkey, % myhotkey.ǰ׺_�������������л� Chr(A_Index+48), ToggleVirtualDesktop
	Hotkey, % myhotkey.ǰ׺_���ܼ����͵��������� "F" A_Index,SendActiveToDesktop
}
;----------��������----------
;=========�ȼ�����=========

;---------�����ǿ�ո�Ԥ�����ȼ�-----------
if !Auto_mouseclick
	hotkey,~LButton,off
if !Auto_midmouse
	hotkey,$MButton,off
if !Auto_Spacepreview
{
	Hotkey, ifWinActive, ahk_Group ccc
	hotkey, $Space, off
	Hotkey, ifWinActive
}
;---------�����ǿ�ո�Ԥ�����ȼ�-----------

;----------��ҳ���Ƶ���----------
; ���Է��ʵ�ַ       127.0.0.1:8000  http://localhost:2525/
; �ֻ������Է��ʵ�ַ ����IP��2525
if Auto_AhkServer
{
	StoredLogin:=CF_IniRead(run_iniFile, "serverConfig","StoredLogin", "admin")
	StoredPass:=CF_IniRead(run_iniFile, "serverConfig","StoredPass", 1234)
	LoginPass:=CF_IniRead(run_iniFile, "serverConfig","LoginPass", 0)
	buttonSize:=CF_IniRead(run_iniFile, "serverConfig","buttonSize", "30px")
	serverPort:=CF_IniRead(run_iniFile, "serverConfig","serverPort", "8000")  ; �˿ں� ����Ϊ 2525 Ĭ�� 8000
	textFontSize:=CF_IniRead(run_iniFile, "serverConfig","textFontSize", "16px")
	pagePadding:=CF_IniRead(run_iniFile, "serverConfig","pagePadding", "50px")
	mp3file:=CF_IniRead(run_iniFile, "serverConfig","mp3file")
	excelfile:=CF_IniRead(run_iniFile, "serverConfig","excelfile")
	txtfile:=CF_IniRead(run_iniFile, "serverConfig","txtfile")
	loop,5
	{
		stableitem%a_index%:=CF_IniRead(run_iniFile, "serverConfig","stableitem" . a_index)
	}
	mOn:=1
	scheduleDelay:=0	;time before a standby/hibernate command is executed
	SHT:=scheduleDelay//60000	;standby/hibernate timer abstracted in minutes

	gosub indexInit
}
;----------��ҳ���Ƶ���----------

; ���� msgbox �Ĵ�����ڽű����Ӱ���������� 

if (Auto_JCTF or Auto_Update) and ÿ����Сʱ���Ϊ��(6)
{
;----------ũ������----------
	if Auto_JCTF
		Gosub,JCTF
;----------ũ������----------

;---------����������-----------
	If Auto_Update
	{
		URL := "http://www.baidu.com"
		If InternetCheckConnection(URL)
		{
			WinHttp.URLGet("https://raw.githubusercontent.com/wyagd001/MyScript/master/version.txt",,, update_txtFile)
			FileGetSize, sizeq,%update_txtFile%
			If(sizeq<20) and (sizeq!=0)
			{
				FileReadLine, CurVer, %update_txtFile%, 1
				If(Trim(CurVer)!=AppVersion)
				{
					msgbox,4,����֪ͨ,��ǰ�汾Ϊ:%AppVersion%`n���°汾Ϊ:%CurVer%`n�Ƿ�ǰ����ҳ����?
					IfMsgBox Yes
						Run,https://github.com/wyagd001/MyScript
				}
			}
			FileDelete, %update_txtFile%
		}
	}
;---------����������-----------
}

;----------WinMouse----------
;----------��ס Capslock ʹ�����ı䴰�ڵĴ�С��λ�� ----------
;----------loop�������У��ŵ�loop����Ĵ��벻��ִ�е�----------
if Auto_Capslock
{
	SetFormat, FLOAT, 0.0	;Round all floating operations
	ScriptINI = %A_ScriptDir%\settings\WinMouse.ini ;Path to INI file

; Get monitor count and stats
	SysGet, iMonitorCount, 80	;SM_CMONITORS
	Loop %iMonitorCount%	;Loop through each monitor
	SysGet, Mon%A_Index%, MonitorWorkArea, %A_Index%

	; Load settings
	ReadINI()

	; Prep GUI
	Gui,4: +AlwaysOnTop -Caption +ToolWindow +LastFound
	Gui,4: Color, %cShade%	;Set backcolor
	WinSet, Transparent, %iTrans%	;Set transparency

; Establish timer
	SetTimer, ProcessMouse, 500
	SetTimer, ProcessMouse, OFF

	;StimeDiff := A_TickCount - Stime
	;msgbox % "������Ϻ�ʱ" StimeDiff/1000  "��"

	Loop {
	;Check state
		If GetKeyState("Capslock", "P") {
			If Not bTimerOn {
				MouseGetPos, oldX, oldY, mW	;So that we don't draw unless the mouse moves after LWin is pressed
				bCaps := Not GetKeyState("Capslock", "T")
				iCurPoint := -1	;So that next time we turn it on, GUI will draw, even If in the same zone
				bTimerOn := True
				SetTimer, ProcessMouse, ON   	;Turn on timer
			}
			bRestore := GetKeyState("Space", "P") Or bRestore ; Check If we're restoring
			; ��ݼ���Capslock+Space���ָ�����

			;bQuit := GetKeyState("Tab", "P") Or bQuit ;Check If we're quitting
			; ��ݼ���Capslock+Tab���˳�����
		}
		Else If bTimerOn { ; If Capslock is not pressed but the timer is running
			bTimerOn := False
			SetTimer, ProcessMouse, OFF	;Turn off timer
        /*
			If bQuit {
				SetCapsLockState, % bCaps ? "On" : "Off"	;%Restore original status
				Menu, Tray, Icon	;Show icon
				Sleep, 200			;Sleep a little for the icon to be seen
				ExitApp				;Leave script
			}
        */
			If bRestore { ;Check If we're restoring to previous size or moving
				RestoreWinMoved(CheckWinMovedArr(mW)) ;Restore previous pos.
			If Not bShowing	;Check If we have to restore Capslock status ourselves (If GUI isn't showing)
				SetCapsLockState, % bCaps ? "On" : "Off"	;%
			}
			If bShowing {
				SetCapsLockState, % bCaps ? "On" : "Off"	;%Restore original status
				DrawShade()	;hide GUI
				If Not bRestore
					Gosub, MoveWindow
			}
			bRestore := False
		;bQuit := False
		}
		Sleep 50
	}
}
;----------WinMouse----------
;----------�ű������Զ����ؽ���----------
Return

aaa:
	Gosub, GetUnderMouseInfo
	If (_x >= A_ScreenWidth * 0.97 &&  _y>=A_ScreenHeight - 30)
	{
		CoordMode, ToolTip
		tx :=A_ScreenWidth * 0.95
		ty :=A_ScreenHeight - 80
		ToolTip,���ָı����������½�,%tx%,%ty%
	}
	Else If(_x>=A_ScreenWidth * 0.999 and _y>=A_ScreenHeight - 120 and _y<=A_ScreenHeight - 30)
	{
		ToolTip,������������������
	}
	Else If(ActiveWinTitle := MouseIsOverTitlebar())
	{
		If (ActiveWinTitle and (_class = _aClass))
		{
			If (( _x >= _winX +0 ) And ( _x <= _winX + 80 ))
			{
				If(_class= "Progman" or _class= "WorkerW")
				Return
				Else
					ToolTip,���ָı䴰��͸����`n�ָ�Win+Ctrl+Z
			}
			Else If(( _x > _winX + 80) And  (_x < _winX + _winW - 120))
			{
				If(_class= "Progman" Or _class= "WorkerW" or _class="Shell_TrayWnd")
				Return
				Else
					ToolTip,�ù���ʹ������Ϊ������
			}
		}
	}
	Else
		ToolTip
Return

FreeAppMem:
	StringSplit,App,AppList,|
	LoopN:=1
	Loop,%App0%
	{
		CtrApp:=App%LoopN%
		LoopN++
		Process,Exist,%CtrApp%
		If (errorlevel<>0)
			EmptyMem(errorlevel)
		Else
			Continue
	}
	EmptyMem()
Return

onClipboardChange:
	if !Auto_Clip  ;�رռ�������ʱ����
	return
	timeDiff := A_TickCount - lastClipboardTime
	lastClipboardTime := A_TickCount
	if (timeDiff < 200)  ; ���θ��Ƽ��ʱ��̫�̷���
	return
	if A_IsPaused ; �ű���ͣʱ����
	return
	if !monitor  ; ����^Vʱ����
	return
	ClipWait, 1, 1 ; �ȴ�������
	if !clipboard
	return
	if ErrorLevel
	{
		CF_ToolTip("�����帴�Ƴ���.",700)
	return
	}
	If Auto_ClipPlugin ; 
	{
		tempid=0
		If ClipPlugin_git
		{
			If RegExMatch(Clipboard, "^(\\|/)?(zh-cn|v1|v2)?(\\|/)?docs(\\?|/?).+\.htm$")
			{
				if IsLabel("git")
				{
					SelectedPath := Clipboard
					gosub git
					Clipboard := ClipSaved%clipid%
				return
				}
			}
		}
	}
	if GetClipboardFormat(1)=1  ; �������е��������ı�
	{
		tempid=0
		if(ClipSaved%clipid%=Clipboard)
		return
		clipid+=1
		if clipid>3
			clipid=1
		ClipSaved%clipid% := Clipboard
		CF_ToolTip("������" clipid " �������.",700)
		if Auto_Cliphistory
		{
			if (writecliphistory=1) 
			{
				if StrLen(Clipboard)<1000
				{
					for k,v in Array_Cliphistory
						if (v=Clipboard)
							return
					Array_Cliphistory.Push(Clipboard)
					if Array_Cliphistory.Length() > 15
						Array_Cliphistory.RemoveAt(1)
				}
				;if(ClipSaved1 = ClipSaved2) or (ClipSaved2 = ClipSaved3) or (ClipSaved1 = ClipSaved3)
				;return
				addHistoryText(Clipboard, A_Now)
				;CF_ToolTip("������" clipid " ��д�����ݿ�.",700)
			return
			}
			else
			{
				writecliphistory=1
			return
			}
		}
	}
	else ; �������е�������ͼƬ���ļ��ȷ��ı�����
		tempid=1
return

EmptyMem(PID="AHK Rocks"){
	pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
	h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
	DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
	DllCall("CloseHandle", "Int", h)
}

selectfile:
	FileSelectFile,tt,,,ѡ���ļ�
	GuiControl,, Dir, %tt%
	GuiControl,choose,dir,%tt%
	GuiControl, -default,&.
	GuiControl, +default,��(&O)
Return

selectfolder:
	FileSelectFolder,tmpDir,,,ѡ��Ŀ¼
	;����ѡ��Ŀ¼��·��Ϊ�����б��һ����Ŀ
	GuiControl,, Dir, %tmpDir%
	;ѡ�������б��е���Ŀ
	GuiControl,choose,dir,%tmpDir%
	;�¼�û���ύ dirΪ�� ����TargetFolder := Dir��Ч
	If tmpDir
	{
		TargetFolder := tmpDir
		IniWrite,%TargetFolder%, %run_iniFile%,·������, TargetFolder
		TrayTip,�ƶ��ļ�,Ŀ���ļ�������Ϊ %TargetFolder% ��
	}
	GuiControl, -default,ѡ��(&S)
	GuiControl, +default,��(&O)
Return

ѡ��:
	IfWinExist,ahk_class AutoHotkeyGUI,ѡ��
		WinActivate,ahk_class AutoHotkeyGUI,ѡ��
	Else
		Gosub,option
Return

about:
	IfWinExist,ahk_class AutoHotkeyGUI,ѡ��
	{
		WinActivate,ahk_class AutoHotkeyGUI,ѡ��
		guicontrol,99: ChooseString, systabcontrol321, ����
	}
	Else
	{
		Gosub,option
		WinWait,ahk_class AutoHotkeyGUI,ѡ��
		guicontrol,99: ChooseString, systabcontrol321, ����
	}
Return

Gui_Context_Menu:
	winget,Gui_wid,id,a
; Dock to Screen Edge entries
	Menu, Gui_Dock_Windows, Add, Left, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Right, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Top, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Bottom, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add
	Menu, Gui_Dock_Windows, Add, Corner - Top Left, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Corner - Top Right, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Corner - Bottom Left, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add, Corner - Bottom Right, Gui_Dock_Windows
	Menu, Gui_Dock_Windows, Add
	Menu, Gui_Dock_Windows, Add, Un-Dock, Gui_Un_Dock_Window
	IfNotInString, Gui_Dock_Windows_List,%Gui_wid%
		Menu, Gui_Dock_Windows, Disable, Un-Dock
	Else
	{
		Menu, Gui_Dock_Windows, Disable, Left
		Menu, Gui_Dock_Windows, Disable, Right
		Menu, Gui_Dock_Windows, Disable, Top
		Menu, Gui_Dock_Windows, Disable, Bottom
		Menu, Gui_Dock_Windows, Disable, Corner - Top Left
		Menu, Gui_Dock_Windows, Disable, Corner - Top Right
		Menu, Gui_Dock_Windows, Disable, Corner - Bottom Left
		Menu, Gui_Dock_Windows, Disable, Corner - Bottom Right
		If (Edge_Dock_Position_%Gui_wid% !="") ; produces error If doesn't exist
			Menu, Gui_Dock_Windows, Check, % Edge_Dock_Position_%Gui_wid%
	}

	Menu, ConfigMenu1, Add, &Dock to Edge, :Gui_Dock_Windows
	Menu, ConfigMenu1, Add
	Menu, ConfigMenu1, Add, ���ӹ���, :addf
	Menu, ConfigMenu1, Add, ������(&U)`t, Update
	Menu, ConfigMenu1, Add, ѡ��(&O)`t, ѡ��
	Menu, ConfigMenu1, Add
	Menu, ConfigMenu1, Add, �����ű�(&R)`t, �����ű�
	Menu, ConfigMenu1, Add, �˳�(&X)`t, Menu_Tray_Exit
	Menu, ConfigMenu1, Show
	Menu, Gui_Dock_Windows,deleteall
	Menu, ConfigMenu1,deleteall
Return

Open1:
	ListVars
Return

Help:
	Run, %Ahk_Dir%\AutoHotkeyLCN_new.chm
Return

spy:
	Run, %Ahk_Dir%\AU3_Spy.exe
Return

�����ű�:
	reload
Return

�༭�ű�:
	Edit
Return

nul:
Return

;!Pause::
���������ȼ�:
	Suspend, Permit
	If ( !A_IsSuspended )
	{
		Suspend, On
		Menu, Tray, ToggleCheck, ���������ȼ�(&S)`tAlt+Pause
	}
	Else
	{
		Suspend, Off
		Menu, Tray, ToggleCheck, ���������ȼ�(&S)`tAlt+Pause
	}
Return

;Pause::
��ͣ�ű�:
	Menu, Tray, ToggleCheck, ��ͣ�ű�(&P)`tPause
	Pause,Toggle,1
Return

GuiClose:
	settimer,���,off
	Gui,hide
	visable=0
Return

show:
	If !visable
	{
		Gui,Show
		settimer,���,on
		visable=1
	}
	Else
	{
		Gui,hide
		settimer,���,off
	visable=0
	}
Return

;If ( DllCall( "IsWindowVisible", "uint", AppTitle ) )
��ʾ������:
	If !visable
	{
		Gui, Show
		visable=1
	}
	Else
	{
		IfWinNotActive,%AppTitle%
		WinActivate,%AppTitle%
		Else
		{
			Gui,hide
			visable=0
		}
	}
Return

GuiEscape:
	if Gui_Esc=����
	{
		Gui,hide
		visable=0
	}
	else if Gui_Esc=�˳�
		gosub,Menu_Tray_Exit
Return

Menu_Tray_Exit:
	FadeOut(AppTitle,50)
	ExitApp
Return

ExitSub:
	if Auto_7plusMenu
		FileDelete, %A_Temp%\7plus\hwnd.txt

	if Auto_FuncsIcon
	{
		TrayIcon_Remove(hGui, 101)
		TrayIcon_Remove(hGui, 102)
	}

	; ComBoBox ��Ŀͼ��
	UnhookWinEvent(hWinEventHook3, HookProcAdr3)

; �ͷż��ӹػ�����Դ
	if Auto_ShutdownMonitor
	{
		DllCall("ShutdownBlockReasonDestroy", UInt, hGui)
		UnhookWinEvent(hWinEventHook2, HookProcAdr2)
		;msgbox,0
	}

	if CloseWindowList_showmenu
	{
		DllCall("DeregisterShellHookWindow","uint",hGui)
		;msgbox,1
}

	If !Auto_smartchooserbrowser
	{
		delahkurl()
		;msgbox,2
	}

; ��ԭ��Ϊ����ͼ�Ĵ���
	If Auto_MiniMizeOn
	{
		WinGet, id, list,ahk_class AutoHotkeyGUI

		Loop,%id%
		{
			this_id := id%A_Index%
			WinGetTitle, this_title, ahk_id %this_id%
			;FileAppend,%this_title%`n,%A_Desktop%\123.txt
			StringSplit, data, this_title,*
			Title2MiniMize:=data1
			Winshow, ahk_id %Title2MiniMize%
		}
		;msgbox,3
	}

; ��ԭpin2desk��ס�Ĵ���
	If ToggleList
	{
		Loop, parse,ToggleList,`|
		{
			WinShow,ahk_id %A_LoopField%
			DllCall("SetParent", "UInt", A_LoopField, "UInt", 0)
			;WinSet, Style, +0xC00000, ahk_id %A_LoopField%
			WinSet,Region,,ahk_id %A_LoopField%
			ToggleList:=StrAr_DeletElement(ToggleList,A_LoopField,1)
		}
		;msgbox,4
	}

; ��ԭ�����������صĴ���
	DetectHiddenWindows Off
	Loop, %numDesktops%
		ShowHideWindows(A_Index, true)
	;msgbox,5

; �Ƿ�����������ͼ�꣬�ǵĻ���ԭ
	If hidedektopicon
	{
		ControlGet, HWND, Hwnd,, SysListView321, ahk_class Progman
		If HWND =
		{
			DetectHiddenWindows Off
			ControlGet, HWND, Hwnd,, SysListView321, ahk_class WorkerW
			WinShow, ahk_id %HWND%
		}
		;msgbox,6
	}

	DetectHiddenWindows On
;�˳��ӽű�
	Loop, %scriptCount%
	{
		thisScript := scripts%A_index%0
		If scripts%A_index%1 = 1  ; �Ѵ�
		{
			WinClose %thisScript% - AutoHotkey
			scripts%A_index%1 = 0

			StringRePlace menuName, thisScript, .ahk
		}
	}
	;msgbox,7

	If md5type=1
	{
		DllCall("FreeLibrary", "Ptr", hModule_Md5)
		;msgbox,8
	}

; �ͷ�ճ�����򿪵���Դ
	If Auto_PasteAndOpen
	{
		WinShow,ahk_class Shell_TrayWnd
		WinShow,��ʼ ahk_class Button
		WinActivate,ahk_class Shell_TrayWnd
		;msgbox,6
		UnhookWinEvent(hWinEventHook, HookProcAdr)
		;msgbox,9
	}

	if prewpToken
	{
		Gdip_ShutDown(prewpToken)
		;msgbox,10
	}

	if Auto_Cliphistory
	{
		if IsObject(DB)
		{
			DB.CloseDb()
			DB := ""
		}
	}

	SoundPlay ,%A_ScriptDir%\Sound\Windows Error.wav
	sleep,300
	ExitApp
Return

;�˳�����
FadeOut(WinTitle,SleepTime)
{
	ST := SleepTime
	Window := WinTitle
	Alpha = 255
	Loop 52
	{
		WinSet,Transparent,%Alpha%,%Window%
		EnvSub,Alpha,5
		If ST != 0
		{
			Sleep %ST%
		}
	}
}

;�һ����������Ķ���
RBUTTONUP()
{
	global AppTitle
	MouseGetPos,,,,c
	IfEqual,c,Edit1
	{
		Send,{RButton Up}
	Return
	}
	IfEqual,c,Static2
	{
		IfWinActive,%AppTitle%
			menu,audioplayer,show
	Return
	}
	Else
	{
		IfWinActive,%AppTitle%
			gosub Gui_Context_Menu
	}
}

cSigleMenu:
	Menu,AllWinMenu,Add,

	Menu,SigleMenu,Add,�������� 1,ActDesk
	Menu,SigleMenu,Add,�������� 2,ActDesk
	Menu,SigleMenu,Add,�������� 3,ActDesk
	Menu,SigleMenu,Add,�������� 4,ActDesk
;----------------------------------------------------------------------------
	Menu,SigleMenu,Add,

	Menu,DeskAdd,Add,�������� [1],DeskAdd
	Menu,DeskAdd,Add,�������� [2],DeskAdd
	Menu,DeskAdd,Add,�������� [3],DeskAdd
	Menu,DeskAdd,Add,�������� [4],DeskAdd
;----------------------------------------------------------------------------
	Menu,SigleMenu,Add,���뵽,:DeskAdd
	Menu,SigleMenu,Add,���д���,:AllWinMenu
	Menu,SigleMenu,Add,��ԭ������,Disa
	Menu,SigleMenu,Check,�������� 1

#initial:
	ActDeskNum:=1
	numDesktops := 4   ; maximum number of desktops
	curDesktop := 1      ; index number of current desktop

	ToggleList:=""
	DeskGroup_1:=""
	DeskGroup_2:=""
	DeskGroup_3:=""
	DeskGroup_4:=""

	ClassTpye:="CabinetWClass,ExploreWClass,Notepad2,Notepad,IEFrame,ACDViewer,Afx_,ShImgVw_,#32?770,"
	Ctrl_CabinetWClass:="DirectUIHWND3"
	Ctrl_ExploreWClass:="SysListView321"
	Ctrl_Notepad2:="Scintilla1"
	Ctrl_Notepad:="Edit1"
	Ctrl_IEFrame:="Internet Explorer_Server1"
	Ctrl_ACDViewer:="ImageViewWndClass1"
	Ctrl_Afx_:="SysListView321"
	Ctrl_ShImgVw_:="ShImgVw:CZoomWnd1"
	Ctrl_#32770:="SysListView321"
Return

GetAllKeys:
	Loop, Parse, content, `n
	{
		StringSplit, data, A_LoopField, =
		%data1%:=data2
  }
return

_AutoInclude:
	f = %A_ScriptDir%\Script\AutoInclude.ahk
	FileRead, fs, %f%

; ����#Include��Ҫ�������нű���Ŀ¼
	s=
	Auto_IncludePath = %A_ScriptDir%\Script\Cando
	Loop, %Auto_IncludePath%\*.ahk
		s.="#Include *i %A_ScriptDir%\Script\Cando\" A_LoopFileName "`n"
	Auto_IncludePath = %A_ScriptDir%\Script\Windo
	Loop, %Auto_IncludePath%\*.ahk
		s.="#Include *i %A_ScriptDir%\Script\Windo\" A_LoopFileName "`n"
	Auto_IncludePath = %A_ScriptDir%\Script\Hotkey
	Loop, %Auto_IncludePath%\*.ahk
		s.="#Include *i %A_ScriptDir%\Script\Hotkey\" A_LoopFileName "`n"
	Auto_IncludePath = %A_ScriptDir%\Script\7plus�Ҽ��˵�
	Loop, %Auto_IncludePath%\*.ahk
		s.="#Include *i %A_ScriptDir%\Script\7plus�Ҽ��˵�\" A_LoopFileName "`n"
	if RegExReplace(fs,"\s+") != RegExReplace(s,"\s+")
	{
		FileDelete, %f%
		FileAppend, %s%, %f%
		msgbox,,�ű�����,�Զ� Include ���ļ������˱仯�����"ȷ��"�������ű���Ӧ�ø��¡�
		IfMsgBox OK
			Reload
	}
	fs:=s:=Auto_IncludePath:=f:=""
;---------------------------------
Return

Combo_WinEvent:
; EVENT_OBJECT_REORDER:= 0x8004, EVENT_OBJECT_FOCUS:= 0x8005, EVENT_OBJECT_SELECTION:= 0x8006
	CtrlHwnd:=hComBoBox
	VarSetCapacity(CB_info, 40 + (3 * A_PtrSize), 0)
	NumPut(40 + (3 * A_PtrSize), CB_info, 0, "UInt")
	DllCall("User32.dll\GetComboBoxInfo", "Ptr", CtrlHwnd, "Ptr", &CB_info)
	CB_EditID := NumGet(CB_info, 40 + A_PtrSize, "Ptr") ;48/44
	CB_ListID := NumGet(CB_info, 40 + (2 * A_PtrSize), "Ptr") ; 56/48
	
	CB_EditID:=Format("0x{1:x}",CB_EditID) , CB_ListID:=Format("0x{1:x}",CB_ListID) 

	GuiHwnd_:=CB_ListID
	ThreadId := DllCall("GetWindowThreadProcessId", "Int", GuiHwnd_, "UInt*", PID)	; LPDWORD
	HookProcAdr3:=RegisterCallback("WinProcCallback")
	hWinEventHook3:=SetWinEventHook(0x8006, 0x8006, 0, HookProcAdr3, PID, ThreadId, 0)
	objListIDs[CB_ListID]:=hComBoBox
return

Plugins_Run:
	for k,v in Pluginshotkey
	{
		If(v=A_ThisHotkey)
		{
			Run,"%A_AhkPath%" "%A_ScriptDir%\Plugins\%k%.ahk"
			break
		}
	}
return

#include %A_ScriptDir%\Script\�ű�������.ahk
#include %A_ScriptDir%\Script\����.ahk
#include %A_ScriptDir%\Script\FolderMenu.ahk
#include %A_ScriptDir%\Script\������\OpenButton.ahk
#include %A_ScriptDir%\Script\������\runhistory.ahk
#include %A_ScriptDir%\Script\������\������.ahk
#include %A_ScriptDir%\Script\������\��ַ����.ahk
#include %A_ScriptDir%\Script\������\IE�ղؼ�.ahk
#include %A_ScriptDir%\Script\������\�ղؼ�.ahk
#include %A_ScriptDir%\Script\������\�����ݷ�ʽ.ahk
#include %A_ScriptDir%\Script\������\ͼƬ��ť.ahk
#include %A_ScriptDir%\Script\������\����.ahk
#include %A_ScriptDir%\Script\������\�б�.ahk
#include %A_ScriptDir%\Script\������\���ӹ���.ahk
#include %A_ScriptDir%\Script\������\��ק�ƶ��ļ�.ahk
#include %A_ScriptDir%\Script\������\�л��༭�����б�.ahk
#include %A_ScriptDir%\Script\������\����������������.ahk
#include %A_ScriptDir%\Script\������\comboɾ����ť.ahk
#include %A_ScriptDir%\Script\��ҳԶ�̿���.ahk
#Include %A_ScriptDir%\Script\Cmd.ahk
#include %A_ScriptDir%\Script\USB.ahk
#include %A_ScriptDir%\Script\����.ahk
#include %A_ScriptDir%\Script\����м�.ahk
#include %A_ScriptDir%\Script\������.ahk
#include %A_ScriptDir%\Script\WinMouse.ahk
#include %A_ScriptDir%\Script\winpad.ahk
#include %A_ScriptDir%\Script\Explorer_DeskIcons.ahk
#include %A_ScriptDir%\Script\Explorer_7plus�Ҽ��˵�.ahk
#include %A_ScriptDir%\Script\Explorer_���´򿪹رյĴ���.ahk
#include %A_ScriptDir%\Script\����Զ������.ahk
#include %A_ScriptDir%\Script\ʱ��_��ʱ�Ͷ�ʱ����.ahk
#include %A_ScriptDir%\Script\ʱ��_��������.ahk
#include %A_ScriptDir%\Script\Candy.ahk
#include %A_ScriptDir%\Script\Windy.ahk
#include %A_ScriptDir%\Script\Dock To Edge.ahk
#include %A_ScriptDir%\Script\Pin2Desk.ahk
#include %A_ScriptDir%\Script\��ַ��ճ������.ahk
#include %A_ScriptDir%\Script\�ػ��Ի���.ahk
#include %A_ScriptDir%\Script\cliphistory.ahk
#include %A_ScriptDir%\Lib\Clip.ahk
#include %A_ScriptDir%\Lib\DropFiles.ahk
#include %A_ScriptDir%\Lib\File_CpTransform.ahk
#include %A_ScriptDir%\Lib\Variables.ahk
#include %A_ScriptDir%\Lib\Functions.ahk
#include %A_ScriptDir%\Lib\Explorer.ahk
#include %A_ScriptDir%\Lib\Menu.ahk
#include %A_ScriptDir%\Lib\Window.ahk
#include %A_ScriptDir%\Lib\Class_RichEdit.ahk
#include %A_ScriptDir%\Lib\ProcessMemory.ahk
#include %A_ScriptDir%\Lib\WinEventHook.ahk
#include %A_ScriptDir%\Lib\ActiveScript.ahk
#include %A_ScriptDir%\Lib\Class_GuiDropFiles.ahk
#include %A_ScriptDir%\Lib\Class_SQLiteDB.ahk
#include %A_ScriptDir%\Lib\Class_JSON.ahk
#include %A_ScriptDir%\Lib\Class_WinHttp.ahk
#include %A_ScriptDir%\Lib\Class_Interception.ahk
#Include %A_ScriptDir%\Lib\����ת��.ahk
#Include %A_ScriptDir%\Lib\string.ahk
#include %A_ScriptDir%\lib\AHKhttp.ahk
#include %A_ScriptDir%\Script\TrayIcon_FuncsIcon.ahk
#include <AHKsock>
#include *i %A_ScriptDir%\Script\AutoInclude.ahk