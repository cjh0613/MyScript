;������������������������������������������������������������ 
;<<<<��������ȡ����>>>>        �ÿ����ķ�����ȡ����
;������������������������������������������������������������
Candy:
	SkSub_Clear_CandyVar()
	MouseGetPos,,, Candy_CurWin_id         ; ��ǰ����µĽ���ID
	WinGet, Candy_CurWin_Fullpath, ProcessPath, Ahk_ID %Candy_CurWin_id%    ; ��ǰ���̵�·��
	WinGetTitle, Candy_Title, Ahk_ID %Candy_CurWin_id%    ; ��ǰ���̵ı���
	CandySel := GetSelText(2, Candy_isFile, CandySel_Rich)
	if !CandySel
	{
		if NoSelectGotoWindy
			gosub Windy
	Return
	}
	Transform, Candy_ProFile_Ini, Deref, %Candy_ProFile_Ini%

	IfNotExist %Candy_ProFile_Ini%         ; ��������ļ������ڣ��򷢳����棬����ֹ
	{
		MsgBox ���ȼ�%A_thishotkey% ����������ļ�������! `n--------`n����%Candy_ProFile_Ini%
	Return
	}
 /*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U  <<<<ѡ�����ݵĺ�׺����>>>>                                                �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/
	If(Fileexist(CandySel) && RegExMatch(CandySel, "^(\\\\|.:\\)")) ; �ļ������ļ���,����֧�����·�����ļ�·��,����������ģʽ��ȫ·����
	{
		Candy_isFile:=1     ; ����ǡ������͡�����Ч·����ǿ���϶�Ϊ�ļ�
		SplitPath, CandySel, CandySel_FileNameWithExt, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt, CandySel_Drive
		SplitPath, CandySel_ParentPath, CandySel_ParentName,,,, ; �������ȡ�������ļ�������
		If InStr(FileExist(CandySel), "D")  ; �����Ƿ��ļ���,Attrib= D ,�����ļ���
		{
			CandySel_FileNameNoExt := CandySel_FileNameWithExt
			CandySel_Ext := RegExMatch(CandySel, "^.:\\$") ? "Driver" : "Folder"            ; ϸ�֣��̷������ļ���
		}
		Else If (CandySel_Ext = "")       ; �������ļ��У����޺�׺������ΪNoExt
		{
			CandySel_Ext := "NoExt"
		}
		if (CandySel_ParentName = "")
			CandySel_ParentName := RTrim(CandySel_Drive, ":")
	}
	Else if(instr(CandySel, "`n") And Candy_isFile = 1)  ; ����������У���ճ��������Ϊ�ļ������ǡ����ļ���
	{
		CandySel_Ext := "MultiFiles" ; ���ļ��ĺ�׺=MultiFiles
		CandySel_FirstFile :=RegExReplace(CandySel, "(.*)\r.*","$1")  ; ȡ��һ��
		SplitPath, CandySel_FirstFile,, CandySel_ParentPath,,  ; �Ե�һ�еĸ�Ŀ¼Ϊ�����ļ��ĸ�Ŀ¼��
		If RegExMatch(CandySel_ParentPath, "\:(|\\)$")  ; �����Ŀ¼�Ǵ��̸�Ŀ¼,���̷�����Ŀ¼����
			CandySel_ParentName := RTrim(CandySel_ParentPath, ":")
		else  ; ������ȡ��Ŀ¼��
			CandySel_ParentName := RegExReplace(CandySel_ParentPath, ".*\\(.*)$", "$1")
	}
	Else     ; �ı�����
	{
		;-----------�������ִ�����-------------------
		IniRead Candy_User_defined_TextType, %Candy_ProFile_Ini%, user_defined_TextType  ; �Ƿ�����û���������ı����ͣ�������˳��ģ�����ǰ�������
		loop, parse, Candy_User_defined_TextType, `n
		{
			If(RegExMatch(CandySel, RegExReplace(A_LoopField, "^.*?=")))     ; ����ini�����û��Զ���Σ������鿴���Ҳ����������
			{
				CandySel_Ext := RegExReplace(A_LoopField, "=.*?$")   ; ����ǡ��ı�ĳ���͡�
				Candy_Cmd:=SkSub_Regex_IniRead(Candy_ProFile_Ini, "TextType", "i)(^|\|)" CandySel_Ext "($|\|)") ; ��ȡ�����͵ġ������趨��
				If(Candy_Cmd != "Error")            ; �������Ӧ��׺��Ķ��壬������ȥ���С�
				{
					Goto Label_Candy_Read_Value
					Break
				}
			}
		}
		IniRead, Candy_ShortText_Length, %Candy_ProFile_Ini%, Candy_Settings, ShortText_Length, 80   ; û�ж��壬�������ѡ�ı��ĳ��̣��趨Ϊ���ı����߶��ı�
		CandySel_Ext := StrLen(CandySel) < Candy_ShortText_Length ? "ShortText" : "LongText" ; ���ֳ����ı�
	}

 /*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U<<<<���Ҷ���>>>>                                                            �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/
Label_Candy_Read_Value:
	if Last_Candy_Cmd && Run_Candylast
	{
		Candy_Cmd := Last_Candy_Cmd
		goto Label_Candy_RunCommand
	}

	Candy_Type := Candy_isFile> 0 ? "FileType" : "TextType"         ; ����Candy_isFile�ж����ͣ�����Ӧ��INI��������Ҷ���
	Candy_Type_Any := Candy_isFile > 0 ? "AnyFile" : "AnyText"         ; ����Candy_isFile�ж����ͣ���Ӧ��Any������
	Candy_Cmd := SkSub_Regex_IniRead(Candy_ProFile_Ini, Candy_Type, "i)(^|\|)" CandySel_Ext "($|\|)")  ;���Һ�׺Ⱥ����
	If(Candy_Cmd = "Error")            ; ���û����Ӧ��׺��Ķ��壻������Щ���µ�д����Ϊ�˸����ݴ�
	{
		IfExist, %Candy_Profile_Dir%\%CandySel_Ext%.ini   ; ���Ƿ��� ��׺.ini �������ļ�����
		{
			Candy_Cmd := "menu|" CandySel_Ext   ; ͬʱ��ת��ΪMenu|������д��
		}
		Else
		{
			IniRead, Candy_Cmd, %Candy_ProFile_Ini%, %Candy_Type%, %Candy_Type_Any%   ; ���û���򿴿� Any��ini�Ķ�����û��
			If(Candy_Cmd = "Error")   ; û�ж�AnyFile����AnyText���Ķ��壬���Ƿ��� AnyFile.ini��AnyText.ini���ô���
			{
				IfExist, %Candy_Profile_Dir%\%Candy_Type%.ini   ; �У����Դ�Ϊ׼
				{
					Candy_Cmd := "menu|" Candy_Type   ; ͬʱ��ת��ΪMenu|������д��
				}
				Else
				{
					Run, %CandySel%,, UseErrorLevel  ; ���ѹض�û��ô����ʧ����˵����ֱ�����а�
				Return
				}
			}
		}
	}
	If !(RegExMatch(Candy_Cmd,"i)^Menu\|"))
	{
		Goto Label_Candy_RunCommand            ; �������menuָ�ֱ����ת������Ӧ�ó���
	}

;������������������������������������������������������������ 
;<<<<�����˵�>>>>  
;������������������������������������������������������������
Label_Candy_DrawMenu:
	Menu, CandyTopLevelMenu, add
	Menu, CandyTopLevelMenu, DeleteAll
	CandyMenu_IconSize := CF_IniRead(Candy_ProFile_Ini, "General_Settings", "MenuIconSize", 16)
	CandyMenu_IconDir := CF_IniRead(Candy_ProFile_Ini, "General_Settings", "MenuIconDir")  ;�˵�ͼ��λ��
	Transform, CandyMenu_IconDir, Deref, %CandyMenu_IconDir%

	; �ӵ�һ�в˵���������ʾѡ�е����ݣ��ò˵����㿽��������
	CandyMenu_FirstItem := Strlen(CdSel_NoSpace := Trim(CandySel)) > 20 ? SubStr0(CdSel_NoSpace, 1, 10) . "..." . SubStr0(CdSel_NoSpace, -10) : CdSel_NoSpace
	Menu CandyTopLevelMenu, Add, %CandyMenu_FirstItem%, Label_Candy_CopyFullpath
	if InStr(CandyMenu_FirstItem, "����ͼ��")
	{
		Candy_Firstline_Icon := CF_IniRead(run_iniFile,uid:=SubStr(CandyMenu_FirstItem,6), "Ti_" uid "_icon")
		if ipos:=InStr(Candy_Firstline_Icon,":")
		{
			icon_idx := SubStr(Candy_Firstline_Icon,ipos+1)+1
			Candy_Firstline_Icon := SubStr(Candy_Firstline_Icon,1,ipos-1)
		}
	}
	else
		Candy_Firstline_Icon := SkSub_Get_Firstline_Icon(CandySel_Ext, CandySel, CandyMenu_IconDir "\Extension")
	Menu CandyTopLevelMenu, icon, %CandyMenu_FirstItem%, %Candy_Firstline_Icon%, %icon_idx%, %CandyMenu_IconSize%
	Menu CandyTopLevelMenu, Add

	arrCandyMenuFrom := StrSplit(Candy_Cmd, "|")
	CandyMenu_ini := arrCandyMenuFrom[2] = "" ? Candy_ProFile_Ini_NameNoext : arrCandyMenuFrom[2]

	CandyMenu_sec:= arrCandyMenuFrom[3] = "" ? "Menu" : arrCandyMenuFrom[3]

	szMenuIdx := {}
	szMenuContent := {}
	szMenuWhichFile := {}
	SkSub_GetMenuItem(Candy_Profile_Dir, CandyMenu_ini, CandyMenu_sec, "CandyTopLevelMenu", "")
	SkSub_DeleteSubMenus("CandyTopLevelMenu")

	For k, v in szMenuIdx
	{
		SkSub_CreateMenu(v, "CandyTopLevelMenu", "Label_Candy_HandleMenu", CandyMenu_IconDir, CandyMenu_IconSize)
	}
	MouseGetPos, CandyMenu_X, CandyMenu_Y
	MouseMove, CandyMenu_X, CandyMenu_Y, 0
	MouseMove, CandyMenu_X, CandyMenu_Y, 0
	;ToolTip, % A_TickCount-CandyStartTick, 200, 0     ; ��Ҫ��������menuʱ�䣬������� ,��������2/3
    Menu, CandyTopLevelMenu, show
	;ToolTip ; ��Ҫ��������menuʱ�䣬������� ,��������3/3
Return

;================�˵�����================================
Label_Candy_HandleMenu:
	If GetKeyState("Ctrl")        ; [��סCtrl���ǽ�������]
	{
		Candy_ctrl_ini_fullpath:=Candy_Profile_Dir . "\" . szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem] . ".ini"
		Candy_Ctrl_Regex:= "=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
		SkSub_EditConfig(Candy_ctrl_ini_fullpath, Candy_Ctrl_Regex)
	}
	else
	{
		Candy_Cmd := szMenuContent[ A_thisMenu "/" A_ThisMenuItem]
		CandyError_From_Menu := 1
		Goto Label_Candy_RunCommand
	}
return

Label_Candy_CopyFullpath:
	If GetKeyState("Ctrl")			    ;[��סCtrl���ǽ���������]
	{
		Candy_Ctrl_Regex := "i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
		SkSub_EditConfig(Candy_Profile_ini, Candy_Ctrl_Regex)
	}
	Else
	{
		Clipboard := CandySel
		Last_Candy_Cmd :=
	}
Return

 /*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U<<<<�����滻>>>>                                                            �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/
Label_Candy_RunCommand:
	if Run_Candylast
		Run_Candylast := 0
	else
		Last_Candy_Cmd := Candy_Cmd
	Candy_Cmd := SkSub_EnvTrans(Candy_Cmd)  ; �滻�Ա����Լ�ϵͳ����,Ini������~%��ʾһ��%,��ȻҪ��~~%����ʾһ��ԭ���~%
	Candy_Cmd = %Candy_Cmd%
	If (instr(Candy_Cmd, "{SetClipBoard:pure}")+instr(Candy_Cmd, "{SetClipBoard:rich}") )       ; �������ָ����޸�ϵͳճ���壬����������б���������á�������Ҫ���������滻����
	{
		Clipboard := InStr(Candy_Cmd, "{SetClipBoard:pure}") ? CandySel : CandySel_Rich
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{SetClipBoard\:.*\}")
	}
	If (instr(Candy_Cmd, "{icon:")) ; iconͼ��
	{
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{icon\:.*\}")
	}
	If Candy_Cmd =   ; ���ֻ�������������������������е�ָ��Ϊ�գ���ֱ���˳�
	Return
	If instr(Candy_Cmd, "{date:")     ; ʱ����������巽��Ϊ:{date:yyyy_MM_dd} ð��:����Ĳ��ֿ������ⶨ��
	{
		Candy_Time_Mode := RegExReplace(Candy_Cmd, "i).*\{date\:(.*?)\}.*","$1")
		FormatTime, Candy_Time_Formated, %A_nOW%, %Candy_Time_Mode%
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{date\:(.*?)\}", Candy_Time_Formated)
	}
	If instr(Candy_Cmd,"{in:")    ; in�����ļ��ĺ�׺����
	{
		Candy_in_M := "i`am)^.*\.(" RegExReplace(Candy_Cmd, "i).*\{in\:(.*?)\}.*", "$1") ")$"
		Grep(CandySel, Candy_in_M, CandySel, 1, 0, "`n")
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{in\:.*\}")
		If (CandySel = "")
		Return
		Else
			StringReplace, CandySel, CandySel, `n, `r`n, all
	}
	If instr(Candy_Cmd, "{ex:")    ; ex�����ļ��ĺ�׺�ų�
	{
		Candy_ex_M := "i`am)^.*\.(" RegExReplace(Candy_Cmd, "i).*\{ex\:(.*?)\}.*", "$1") ")$\R?"    ; ���ã�ֻ�Ƕ���һ������հ����⡰
		CandySel := RegExReplace(CandySel, Candy_ex_M)
		CandySel := RegExReplace(CandySel, "\s*$","")         ; �����հ� CandySel:=trim(CandySel,"`r`n")         ;�����հ�
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{ex\:.*\}")
		Clipboard := CandySel
		If (CandySel="")
		Return
	}
	If instr(Candy_Cmd, "{input:")   ; �ر�Ĳ���:����prompt��ʾ���ֵ�input ����{Input:�������ӳ�ʱ�䣬��msΪ��λ},֧�ֶ��input����
	{    ; ���Ҫ�������룬��д��{input:��ʾ����:hide}
		CdInput_P=1
		Candy_Cmd_tmp := Candy_Cmd
		While CdInput_P := RegExMatch(Candy_Cmd_tmp, "i)\{input\:(.*?)\}", CdInput_M, CdInput_P+strlen(CdInput_M))
		{
			CdInput_Prompt:= RegExReplace(CdInput_M, "i).*\{input\:(.*?)(:hide)?}.*", "$1")
			CdInput_Hide:= RegExMatch(CdInput_M, "i)\{input:.*?:hide}") ? "hide" : ""
			Gui +LastFound +OWnDialogs +AlwaysOnTop
			InputBox, CdInput_txt, Candy InputBox, `n%CdInput_Prompt%, %CdInput_Hide%, 285, 175,,,,,
			If ErrorLevel
			Return
			Else
				StringReplace, Candy_Cmd, Candy_Cmd, %CdInput_M%, %CdInput_txt%
		}
	}
	If instr(Candy_Cmd, "{box:Filebrowser}")
	{
		FileSelectFile, f_File,,, ��ѡ���ļ�
		If ErrorLevel
		return
		StringReplace, Candy_Cmd, Candy_Cmd, {box:Filebrowser}, %f_File%, All
	}
	If instr(Candy_Cmd, "{box:mFilebrowser}")
	{
		FileSelectFile, f_File ,M,, ��ѡ���ļ�
		If ErrorLevel
		return
		CdMfile_suffix := RegExReplace(Candy_Cmd, "i).*\{box:mFilebrowser:.*LastFile(.*?)\}.*", "$1")
		CdMfile_prefix := RegExReplace(Candy_Cmd, "i).*\{box:mFilebrowser:(.*?)FirstFile.*", "$1")
		CdMfile_midfix := RegExReplace(Candy_Cmd, "i).*\{box:mFilebrowser:.*FirstFile(.*?)LastFile.*\}.*", "$1")
		Firstline := RegExReplace(f_File, "\n.*")
		no_Firstline := RegExReplace(f_File, "^.*?\n", "$1")
		StringReplace, CandySel_list, no_Firstline, `n, %CdMfile_midfix%%Firstline%/, all
		CandySel_list = %CdMfile_prefix%%Firstline%\%CandySel_list%%CdMfile_suffix%
		Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{.*FirstFile.*LastFile.*\}", CandySel_list)
	}
	If instr(Candy_Cmd, "{box:folderbrowser}")
	{
		FileSelectFolder, f_Folder,,, ��ѡ���ļ���
		If f_Folder <>
			StringReplace, Candy_Cmd, Candy_Cmd, {box:folderbrowser}, %f_Folder%, All
		Else
		Return
	}
	Candy_Cmd := RegExReplace(Candy_Cmd, "(?<=\s|^)\{File:fullpath\}(?=\s|$|\|)", """{File:fullpath}""")     ; ǿ�ư�ǰ���п��ַ����߶��˵�ȫ·������������
	If instr(Candy_Cmd, "{File:linktarget}")
	{
		FileGetShortcut, %CandySel%, CandySel_LinkTarget
		StringReplace, Candy_Cmd, Candy_Cmd, {File:linktarget}, %CandySel_LinkTarget%, All                      ; lnk��Ŀ��
	}
	CandyCmd_RepStr := Object("{File:ext}"          ,CandySel_Ext
                           ,"{File:name}"         ,CandySel_FileNameNoExt
                           ,"{File:parentpath}"   ,CandySel_ParentPath
                           ,"{File:parentname}"   ,CandySel_ParentName
                           ,"{File:Drive}"        ,CandySel_Drive
                           ,"{File:Fullpath}"     ,CandySel
                           ,"{Text}"              ,CandySel)
	For k, v in CandyCmd_RepStr
		StringReplace, Candy_Cmd, Candy_Cmd, %k%, %v%, All
	If RegExMatch(Candy_Cmd, "i)\{.*FirstFile.*LastFile.*\}")  ; ������ļ��б���Ҫ���������Ҫ��ģʽ
	{   ; ini�����ļ��б��壺   {FirstFile LastFile}   FirstFile��������һ���ļ���LastFile�������һ���ļ���
		CdMfile_prefix := RegExReplace(Candy_Cmd, "i).*\{(.*?)FirstFile.*\}.*", "$1")
		CdMfile_suffix := RegExReplace(Candy_Cmd, "i).*\{.*LastFile(.*?)\}.*", "$1")
		CdMfile_midfix := RegExReplace(Candy_Cmd, "i).*\{.*FirstFile(.*?)LastFile.*\}.*", "$1")

		StringReplace ,CandySel_list, CandySel,`r`n,%CdMfile_midfix%,all
   ;     MsgBox % CandySel_list
		CandySel_list = %CdMfile_prefix%%CandySel_list%%CdMfile_suffix%
   ;     MsgBox % CandySel_list
		Candy_Cmd:=RegExReplace(Candy_Cmd, "i)\{.*FirstFile.*LastFile.*\}", CandySel_list)
	}
	If instr(Candy_Cmd,"{file:name:")
	{
        Candy_FileName_Coded :=
        Candy_FileName_CodeType := RegExReplace(Candy_Cmd, "i).*\{File\:name\:(.*?)\}.*", "$1")
        Candy_FileName_Coded := SkSub_UrlEncode(CandySel_FileNameNoExt, Candy_FileName_CodeType)
        Candy_Cmd := RegExReplace(Candy_Cmd, "i)\{File\:name\:(.*?)\}", Candy_FileName_Coded)
	}
	If instr(Candy_Cmd, "{text:")  ; �������Ҫ��ʽ�����ı������ȸ�ʽ�����滻
	{
		Candy_Text_Coded :=
		Candy_Text_CodeType := RegExReplace(Candy_Cmd, "i).*\{Text\:(.*?)\}.*", "$1")
		Candy_Text_Coded := SkSub_UrlEncode(CandySel, Candy_Text_CodeType)
		Candy_Cmd:=RegExReplace(Candy_Cmd,"i)\{Text\:(.*?)\}", Candy_Text_Coded)
	}
	If instr(Candy_Cmd, "{mfile:")  ;���ļ��У�������ŵ��ļ�
	{
		Loop, parse, CandySel, `n
			StringReplace, Candy_Cmd, Candy_Cmd, {mfile:%A_Index%}, %A_loopfield%,All
	}

/*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U<<<<�ռ�����>>>>                                                            �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/
	Candy_All_Cmd:="web|keys|msgbox|config|SetClipBoard|cando|Canfunc|cango|openwith|ow|run|rund|runp|ExeAhk"
	If Not RegExMatch(Candy_Cmd, "i)^\s*(" Candy_All_Cmd ")\s*\|")
		Candy_Cmd = OpenWith|%Candy_Cmd% ; ���û��,����Ϊ��һ��OpenWith
	Candy_Cmd :=RegExReplace(Candy_Cmd, "~\|", Chr(3))
	arrCandy_Cmd_Str :=StrSplit(Candy_Cmd, "|", " `t")
	Candy_Cmd_Str1 := arrCandy_Cmd_Str[1]
	Candy_Cmd_Str2 := RegExReplace(arrCandy_Cmd_Str[2], Chr(3), "|")
	Candy_Cmd_Str3 := RegExReplace(arrCandy_Cmd_Str[3], Chr(3), "|")
	If (Candy_Cmd_Str1 = "web")
	{
		SkSub_WebSearch(Candy_CurWin_Fullpath, RegExReplace(Candy_Cmd, "i)^web\|(\s+|)|\s+"))
	}
	Else If (Candy_Cmd_Str1 = "Keys")  ; �������keys|��ͷ�����Ƿ��ȼ�
	{
		Send %Candy_Cmd_Str2%
	}
	Else If (Candy_Cmd_Str1 = "MsgBox")  ; �������MsgBox|��ͷ�����Ƿ�һ����ʾ��
	{
		Gui +LastFound +OWnDialogs +AlwaysOnTop
		MsgBox %Candy_Cmd_Str2%
	}
	Else If (Candy_Cmd_Str1 = "Config")
	{
		for k,v in szMenuWhichfile
			Config_files .= v "`n"
		Sort, Config_files, U
		Loop ,parse, Config_files,`n
			SkSub_EditConfig(Candy_Profile_Dir . "\" A_LoopField ".ini", "")
		Candy_Ctrl_Regex:="i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
		SkSub_EditConfig(Candy_Profile_ini, Candy_Ctrl_Regex)
	}
	Else If (Candy_Cmd_Str1 = "SetClipBoard")   ; ֮ǰ�Ŀ��أ�ֻ�ܰ�ѡ�е����ݷŽ�ճ���壬�����ָ�����԰Ѻ����������ݷŽ�ճ���塣�����ḻ��
	{
		Clipboard := Candy_Cmd_Str2
	}
	Else If (Candy_Cmd_Str1 = "Cando")  ; �������Cando|��ͷ����������һЩ�ڲ����򣬷�������������ű����йҽ�
	{
		CandySelected := CandySel    ; ������ǰ��cando����д��
		if (Candy_Cmd_Str2 = "ctimer") && IsLabel(Candy_Cmd_Str3)
		{
			settimer, % Candy_Cmd_Str3, -300
		return
		}
		If IsLabel("Cando_" . Candy_Cmd_Str2)                       ; �������õı���
			Goto % "Cando_" . Candy_Cmd_Str2
		else If IsLabel(Candy_Cmd_Str2)                       ;  ��ǩ
			Goto % Candy_Cmd_Str2
		Else
			Goto Label_Candy_ErrorHandle
	}
	Else If (Candy_Cmd_Str1 = "Canfunc")  ; �������Canfunc|��ͷ���������к�������������������ű����йҽ�
	{
		CandySelected := CandySel    ; ������ǰ��cando����д��
		If IsStingFunc(Candy_Cmd_Str2)
		{
			RunStingFunc(Candy_Cmd_Str2)
		return
		}
		Else
			Goto Label_Candy_ErrorHandle
	}
	Else If (Candy_Cmd_Str1 = "Cango")   ; �������Cango|��ͷ����������һЩ�ⲿahk���򣬷�������������ű����йҽ�
	{
		IfExist, %Candy_Cmd_Str2%
			Run %ahk% "%Candy_Cmd_Str2% %Candy_Cmd_Str3%" ; �ⲿ��ahk����Σ����ahk���Դ�����
		Else
			Goto Label_Candy_ErrorHandle
	}
	Else If (Candy_Cmd_Str1="OpenWith" or Candy_Cmd_Str1="OW")     ; OpenWith|ָ����ĳ�����ѡ�������ݣ���ʱ��Ӧ�ó�����治�ܴ��κ������У����ϸ��˵��Ŀ��������ҽ��ǡ���ѡ���ݡ���ֻ�Ǳ�ʡ���ˣ�
	{
		Run, %Candy_Cmd_Str2% "%CandySel%", %Candy_Cmd_Str3%, %Candy_Cmd_Str4% UseErrorLevel         ; 1:����  2:����Ŀ¼ 3:״̬
		If (ErrorLevel = "Error")               ; ������г���Ļ�
			Goto Label_Candy_ErrorHandle
	}
	Else If (Candy_Cmd_Str1="Run")     ; �����Ҫ�������У���ʹ���������Ǳ�ѡ�е��ļ���Ҳ����ʡ��
	{
		Run, %Candy_Cmd_Str2% , %Candy_Cmd_Str3%, %Candy_Cmd_Str4% UseErrorLevel         ; 1:����  2:����Ŀ¼ 3:״̬
		If (ErrorLevel = "Error")               ; ������г���Ļ�
			Goto Label_Candy_ErrorHandle
	}
	Else If (Candy_Cmd_Str1="RunD")     ; ��ʽΪRunD|Ӧ�ó���|Ӧ�ó���ı���|x|y|�ȴ�ʱ��
	{       ; û�������x��y�����õ��������ʱ����
		Run, %Candy_Cmd_Str2%,, UseErrorLevel
		If (ErrorLevel = "Error")               ; ������г���Ļ�
			Goto Label_Candy_ErrorHandle
		else
		{
			Sleep,% (Candy_Cmd_Str4="") ? 1000 : arrCandy_Cmd_Str[6]
			WinWaitActive, %Candy_Cmd_Str3% ,,5
			WinActivate, %Candy_Cmd_Str3%
			Candy_RunD_x := arrCandy_Cmd_Str[4] ? arrCandy_Cmd_Str[4] : 100
			Candy_RunD_y := arrCandy_Cmd_Str[5] ? arrCandy_Cmd_Str[5] : 100
			PostMessage, 0x233, HDrop(CandySel, Candy_RunD_x, Candy_RunD_y), 0,, %Candy_Cmd_Str3%
		}
	}
	Else If (Candy_Cmd_Str1 = "RunP")     ; ��ʽΪRunP|Ӧ�ó���|Ӧ�ó���ı���|�ȴ�ʱ�䣻��
	{
		Clipboard := CandySel_Rich
		Run, %Candy_Cmd_Str2%,, UseErrorLevel
		If (ErrorLevel = "Error")               ; ������г���Ļ�
			Goto Label_Candy_ErrorHandle
		else
		{
			Sleep, % (Candy_Cmd_Str4 = "") ? 1000 : Candy_Cmd_Str4
			WinWaitActive, %Candy_Cmd_Str3% ,,5
			WinActivate, %Candy_Cmd_Str3%
			Send ^v
		}
	}
	Else If (Candy_Cmd_Str1 = "ExeAhk")
	{      
      ;msgbox % Candy_Cmd_Str2
			RunScript(Candy_Cmd_Str2, Candy_Cmd_Str3)
	}
Return

/*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U<<<<������>>>>                                                            �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/

Label_Candy_ErrorHandle:
	If (CF_IniRead(Candy_ProFile_Ini, "Candy_Settings", "ShowError", 0) = 1)     ; ����������ʾ���ش���û�У����˵Ļ�������ʾ������Ϣ
	{
		Gui +LastFound +OwnDialogs +AlwaysOnTop
		MsgBox, 4116,, ���������ж������ `n---------------------`n%Candy_Cmd%`n---------------------`n��׺��: %CandySel_Ext%`n`n����������Ӧini��
		IfMsgBox Yes
		{
			if (CandyError_From_Menu = 1)
			{
				Candy_This_ini := szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem]
				Candy_ctrl_ini_fullpath := Candy_Profile_Dir . "\" . Candy_This_ini . ".ini"
				Candy_Ctrl_Regex := "=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
				SkSub_EditConfig(Candy_ctrl_ini_fullpath, Candy_Ctrl_Regex)
			}
			else
			{
				Candy_Ctrl_Regex := "i)(^\s*|\|)" CandySel_Ext "(\||\s*)[^=]*="
				SkSub_EditConfig(Candy_Profile_ini, Candy_Ctrl_Regex)
			}
		}
	}
Return
 /*
�X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
�U<<<<Fuctions���õ��ĺ���>>>>                                                �U
�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
*/
SkSub_GetMenuItem(IniDir, IniNameNoExt, Sec, TopRootMenuName, Parent="")   ; ��һ��ini��ĳ���λ�ȡ��Ŀ���������ɲ˵���
{
	Items := CF_IniRead_Section(IniDir "\" IniNameNoExt ".ini",sec)         ; ���β˵��ķ����
	StringReplace, Items, Items, ��, `t, all
	Loop,parse,Items,`n
	{
		Left := RegExReplace(A_LoopField, "(?<=\/)\s+|\s+(?=\/)|^\s+|(|\s+)=[^!]*[^>]*")
		Right := RegExReplace(A_LoopField, "^.*?\=\s*(.*)\s*$", "$1")
		If (RegExMatch(left, "^/|//|/$|^$")) ;������Ҷ���/�������������/�����ߴ���//������һ������Ķ��壬����
			Continue
		If RegExMatch(Left, "i)(^|/)\+$")   ;�����ߵ���ĩ���ǽ���һ��"������" + ��
		{
			m_Parent := InStr(Left, "/") > 0 ? RegExReplace(Left,"/[^/]*$") "/" : ""  ;���+��ǰ���д����ϼ��˵�,�����ϼ��˵�������û��
			Right:=RegExReplace(Right, "~\|", Chr(3))
			arrRight:=StrSplit(Right, "|", " `t")
			rr1:=arrRight[1]
			rr2:=RegExReplace(arrRight[2], Chr(3), "|")
			rr3:=RegExReplace(arrRight[3], Chr(3), "|")
			rr4:=RegExReplace(arrRight[4], Chr(3), "|")
			If (rr1="Menu")   ;��������ǡ����루�ӣ��˵��������� �����п��ܲ˵����滹�С�Ƕ�׵��¼��˵�������
			{
				m_ini:= (rr2="") ? IniNameNoExt :  rr2
				m_sec:= (rr3="") ? "Menu" : rr3
				m_Parent:=Parent "" m_Parent
				this:=SkSub_GetMenuItem(IniDir, m_ini, m_sec, TopRootMenuName, m_Parent)      ; Ƕ�ף�ѭ��ʹ�ô˺������Ա㴦�������ļ���ģ�����Ĳ˵���
			}
 ; ��+�ķ������������������չ�Լ�������Ӳ˵�������ֱ�ӿ���д������ˡ�
		}
		Else
		{
			szMenuIdx.Push(Parent ""  Left )
			szMenuContent[TopRootMenuName "/" Parent "" Left] := Right
			szMenuWhichFile[TopRootMenuName "/" Parent "" Left] :=IniNameNoExt
		}
	}
}

SkSub_DeleteSubMenus(TopRootMenuName)
{
	For i,v in szMenuIdx
	{
		If instr(v,"/")>0
		{
			Item:=RegExReplace(v, "(.*)/.*", "$1")
			Menu, %TopRootMenuName%/%Item%, add
			Menu, %TopRootMenuName%/%Item%, DeleteAll
		}
	}
}

SkSub_CreateMenu(Item, ParentMenuName, label, IconDir, IconSize)    ;��Ŀ���������ĸ��˵������˵������Ŀ���ǩ
{  ;�ͽ�����Item�Ѿ������ˡ�ȥ�ո���������ʹ��
;��ȡ����ͼ��ᱨ���������һ�з�ֹ����
	Menu, tray,UseErrorLevel
	arrS:=StrSplit(Item,"/"," `t")
	_s:=arrS[1]
	if arrS.Maxindex()= 1      ;�������û�� /���������յġ��˵������ӵ������ĸ��˵����ϡ�
	{
		If InStr(_s,"-") = 1       ;�������������������� �ָ���
			Menu, %ParentMenuName%, Add
		Else If InStr(_s,"*") = 1       ;* �Ҳ˵�
		{
			_s:=Ltrim(_s,"*")
			Menu, %ParentMenuName%, Add,       %_s%,%Label%
			Menu, %ParentMenuName%, Disable,  %_s%
		}
		Else
		{
			y := szMenuContent[ ParentMenuName "/" Item]
			z := SkSub_Get_MenuItem_Icon( y ,IconDir)
			Menu, %ParentMenuName%, Add,  %_s%,%Label%
			Menu, %ParentMenuName%, icon,  %_s%,%z%,,%IconSize%
		}
	}
	Else     ;����� /��˵�����������յĲ˵������һ��һ��ֲ�������
	{
		_Sub_ParentName = %ParentMenuName%/%_s%
		StringTrimLeft, _subItem, Item, strlen(_s)+1
		SkSub_CreateMenu(_subItem,_Sub_ParentName, label, IconDir,IconSize)
		Menu, %ParentMenuName%, add, %_s%, :%_Sub_ParentName%
	}
}

SkSub_EnvTrans(v)
{
	v:=RegExReplace(v,"~%",Chr(3))
	Transform, v, Deref, %v% ; ���Sala��ini��֧��%A_desktop%��%windir%��ahk������ϵͳ���������Ľ������⣬@sunwind @С��
	v:=RegExReplace(v, Chr(3), "%")
Return v
}

SkSub_Get_Firstline_Icon(ext,fullpath,iconpath)
{
	; dll�ļ���ȡ����ͼ��ᱨ��
	Menu, tray,UseErrorLevel
	IfExist, %iconpath%\%ext%.ico             ;����̶����ļ���������ڸ����͵�ͼ��
		x := iconpath "\" ext ".ico"
	Else If ext in  bmp,gif,png,jpg,ico,icl,exe,dll
		x := fullpath
	Else
		x := AssocQueryApp(Ext)
Return %x%
}

SkSub_Get_MenuItem_Icon(item,iconpath)   ; item=��Ҫ��ȡͼ�����Ŀ��iconpath=�㶨���ͼ����ļ���
{
	cmd:=RegExReplace(item,"^\s+|(|\s+)\|[^!]*[^>]*")
	If instr(item,"{icon:")     ; ��ͼ��Ӳ����
	{
		Path_Icon:=RegExReplace(item,"i).*\{icon\:(.*?)\}.*","$1")
		If(Fileexist(Path_Icon))         ;����ȫ·����ͼ�����
			return Path_Icon
		If(Fileexist(iconpath "\MyIcon\" Path_Icon))       ;����MyIcon�ļ�������
			return iconpath "\MyIcon\" Path_Icon
	}
	Else if FileExist(iconpath "\Command\" cmd ".ico")      ;������ "������.ico" �ļ�
	{
		Return  iconpath "\Command\" cmd ".ico"
	}
	item:=SkSub_envtrans(item)
	if RegExMatch(item, "i)^(ow|openwith|rot|run|roa|runp|rund|exeahk)\|") ;����������
	{
		cmd_removed:=RegExReplace(item, "^.*?\|")      ;���洿��� Ӧ�ó��� ·��
		x:=RegExReplace(cmd_removed, "i)\.exe[^!]*[^>]*", ".exe")
		if(Fileexist(x))
		Return %x%  ;ԭ�ű�ֻ����һ��
		else if(Fileexist(A_WinDir "\system32\" x))
    Return %x%
/*
      ;ԭ����ȡ����ͼ�꣬�˵������������, �Լ��Ľű�����
      ;Menu, Tray, UseErrorLevel  ;�˵�������ʾ
*/
	}
	Else if instr(item,".exe") ;ʡ����ָ���openwith|
	{
		x:=RegExReplace(item,"i)\.exe[^!]*[^>]*", ".exe")
		if(Fileexist(x))
		Return %x%
		else if(Fileexist(A_WinDir "\system32\" x))
		Return %x%
	}
	Else
	{
		t:=RegExReplace(item, "\s*\|.*?$")       ;ȥ�����в�����ֻ������һ��|��ǰ��Ĳ���
		x:=AssocQueryApp(t)
		Return %x%
	}
}

AssocQueryApp(sExt)
{    ; http://www.autohotkey.com/board/topic/54927-regread-associated-program-for-a-file-extension/
	sExt =.%sExt%  ; ASSOCSTR_EXECUTABLE
	DllCall("shlwapi.dll\AssocQueryString", "uint", 0, "uint", 2, "uint", &sExt, "uint", 0, "uint", 0, "uint*", iLength)
	VarSetCapacity(sApp, 2*iLength, 0)
	DllCall("shlwapi.dll\AssocQueryString", "uint", 0, "uint", 2, "uint", &sExt, "uint", 0, "str", sApp, "uint*", iLength)
Return sApp
}

SkSub_Regex_IniRead(ini, sec, reg)      ; ����ʽ�Ķ�ȡ���Ⱥ���������������
{  ; ��ini��ĳ�����ڣ����ҷ���ĳ���������ַ���������ҵ�����valueֵ���Ҳ������򷵻� Error
	IniRead, keylist, %ini%, %sec%,
	Loop, Parse, keylist, `n
	{
		t := RegExReplace(A_LoopField, "=.*?$")
		If(RegExMatch(t, reg))
		{
			Return % RegExReplace(A_LoopField, "^.*?=")
			Break
		}
	}
	Return "Error"
}

grep(h, n, ByRef v, s = 1, e = 0, d = "")   ; ;by polythene
{
	v =
	StringReplace, h, h, %d%, , All
	Loop
		If s := RegExMatch(h, n, c, s)
			p .= d . s, s += StrLen(c), v .= d . (e ? c%e% : c)
		Else Return, SubStr(p, 2), v := SubStr(v, 2)
}

SkSub_WebSearch(Win_Full_Path,Http)
{
	all_browser := CF_IniRead(Candy_ProFile_Ini, "General_Settings", "InUse_Browser")
	DefaultBrowser := SkSub_EnvTrans(CF_IniRead(Candy_ProFile_Ini, "General_Settings", "Default_Browser"))
	;�ڢٲ�������ǰ��ǰ����� �Ƿ� �����
	If Win_Full_Path Contains %All_Browser%
	{
		Browser:=Win_Full_Path
	}
	;�ڢڲ���������������û������������У����ܱ���ȡ��������ֹ��������ĸ��룬���Լ�������
	Else Loop,Parse,All_Browser,`,   ;�����ж�����������
	{
		Useful_FullPath:=SkSub_process_exist_and_useful(A_LoopField)
		If (Useful_FullPath!= 0 and Useful_FullPath != 1 )
		{
			Browser := Useful_FullPath
			Break
		}
	}
	; �ڢ۲�	����û��ô����iniĬ��������Ƿ��������
	If ( Browser="")  ;��iniĬ���������a�����������Ƿ��У������ܱ���ȡ��������ֹ��������ĸ��룬���Լ������󣩡�b�����߽�������û�С�
	{
		DefaultBrowser_ȥ������ := RegExReplace(DefaultBrowser, "exe[^!]*[^>]*", "exe")
		SplitPath, DefaultBrowser_ȥ������, DefaultBrowser_name
		Useful_FullPath:=SkSub_process_exist_and_useful(DefaultBrowser_name)
		If (  Useful_FullPath!= 0  And FileExist(DefaultBrowser_ȥ������))
		{
			Browser:=DefaultBrowser
		}
	}
	; �ڢܲ�����������
	If Browser ;���ȡ���������
	{
		SplitPath,browser,,,,browser_namenoext
        Browser_Args:=CF_IniRead(Candy_ProFile_Ini, "WebBrowser's_CommandLIne", browser_namenoext)
		If (Browser_Args!="Error")  ;��Щ����������������,����config���ߵ��������Ƶȴ���������ini�����ṩ��һ������ĵط���
		{
			Browser := Browser " " Browser_Args
		}
		Run,% Browser . " """ . Http . """"
		IfInString Browser, firefox.exe
			WinActivate, Mozilla Firefox Ahk_Class MozillaWindowClass
		Else
			WinActivate Ahk_PID %ErrorLevel%
	}
	Else ;û�������ô
	{  ;��ע��� �Ƿ���Ĭ�ϵ������
		RegRead, RegDefaultBrowser, HKEY_CLASSES_ROOT, http\shell\open\command
		StringReplace, RegDefaultBrowser, RegDefaultBrowser, "
		SplitPath, RegDefaultBrowser,, RDB_Dir,, RDB_NameNoExt,
		Run,% RDB_Dir . "\" . RDB_NameNoExt . ".exe" . " """ . Http . """",,UseErrorLevel
		If errorlevel
		{
			Run,% "iexplore.exe " . site . """"	  ;internet explorer
		}
	}
}
;============================================================================================================
SkSub_process_exist_and_useful(Process_name)        ;�ж�ĳ�������Ƿ����������Ч���У��������desktops����δ�������������
{
	Process, exist, %Process_name%
	WinGet, Process_Fullpath, ProcessPath, Ahk_PID %ErrorLevel%
	If (ErrorLevel!=0 And Process_Fullpath!="")
		Return %Process_Fullpath%
	Else if ErrorLevel=0
		Return 1
	Else
		Return 0
}

HDrop(fnames,x=0,y=0)    ;http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/page-2
{
	characterSize := A_IsUnicode ? 2 : 1
	fns := RegExReplace(fnames,"\n$")
	fns := RegExReplace(fns,"^\n")
	hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20+(StrLen(fns)*characterSize)+characterSize*2)
	p:=DllCall("GlobalLock", "UInt", hDrop)
	NumPut(20, p+0)  ;offset
	NumPut(x,  p+4)  ;pt.x
	NumPut(y,  p+8)  ;pt.y
	NumPut(0,  p+12) ;fNC
	NumPut(A_IsUnicode ? 1 : 0,  p+16) ;fWide
	p2:=p+20
	Loop, Parse, fns, `n, `r
	{
		DllCall("RtlMoveMemory", "UInt", p2, "Str", A_LoopField, "UInt", StrLen(A_LoopField)*characterSize)
		p2+=StrLen(A_LoopField)*characterSize + characterSize
	}
	DllCall("GlobalUnlock", "UInt", hDrop)
	Return hDrop
}

SkSub_EditConfig(inifile, regex="") ; �༭�����ļ���
{
	if not fileExist(inifile)      ; ��̬�˵�δ����ini�ļ�����
		return
	if (regex<>"")  ; �������������ʽ����
	{
		Loop
		{
			FileReadLine, L, %inifile%, %A_Index%
			if ErrorLevel
				break
			if regexmatch(L, regex)
			{
				LineNo := a_index
				break
			}
		}
	}
	Default_TextEditor := CF_IniRead(Candy_ProFile_Ini, "General_Settings", "Default_TextEditor")
	Default_TextEditor:=SkSub_EnvTrans(Default_TextEditor)  ; Ĭ���ı��༭��
	TextEditor:=FileExist(Default_TextEditor) ? Default_TextEditor : "notepad.exe"       ; �ı��༭��
	SplitPath, TextEditor,,,, namenoext
	LineJumpArgs :=CF_IniRead(Candy_ProFile_Ini, "TextEditor's_CommandLine", namenoext)
	if  (LineJumpArgs = "Error" or LineNo = "" )
		cmd :=TextEditor " " inifile
	else
	{
		cmd := TextEditor " " LineJumpArgs
		StringReplace, cmd, cmd, $(FILEPATH), %inifile%
		StringReplace, cmd, cmd, $(LINENUM), %LineNo%
	}
	Run, %cmd%,, UseErrorLevel, TextEditor_PID
	WinActivate ahk_pid %TextEditor_PID%
	return
}

SkSub_Clear_CandyVar()
{
	Global
	CandySel:= CandySel_LinkTarget:= CandySel_Ext:=CandySel_FileNamenoExt := CandySel_ParentPath := CandySel_ParentName := CandySel_Drive := Config_files := ""
	CandyError_From_Menu:=0
}