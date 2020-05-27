Cando_С˵����:
	FileEncoding, % File_GetEncoding(CandySel)
	Result := ""
	Loop, read, % CandySel
	{
		Result :=  Trim(A_LoopReadLine)
		if Result
		break
	}
	FileMove, %CandySel%, %CandySel_ParentPath%\%Result%.txt
	Result := ""
Return

Cando_�ļ�������ĸ��д:
	Loop, Parse, CandySel_FileNameNoExt, %A_Space%_`,|;-��`.  
	{  
		; ����ָ�����λ��.  
		Position += StrLen(A_LoopField) + 1
		; ��ȡ����ѭ�����ҵ��ķָ���.  
		Delimiter := SubStr(CandySel_FileNameNoExt, Position, 1)
		str1 := Format("{:T}", A_LoopField)
		out := out . str1 . Delimiter 
	}  
	FileMove, %CandySel%, %CandySel_ParentPath%\%out%.%CandySel_Ext%
	out := Position := ""
Return

Cando_�ļ�������ת��:
	CandySel_FileNameNoExt := UrlDecode(CandySel_FileNameNoExt)
	FileMove, %CandySel%, %CandySel_ParentPath%\%CandySel_FileNameNoExt%.%CandySel_Ext%
return

Cando_�ϲ��ı��ļ�:
	loop, parse, CandySel, `n,`r
	{
		SplitPath, A_LoopField, , , ext, ,
		If ext in txt,ahk,ini,js,vbs,bat
		{
			FileEncoding, % File_GetEncoding(A_LoopField)
			Fileread, text, %A_loopfield%
			all_text = %all_text%%A_loopfield%`r`n`r`n%text%`r`n`r`n
		}
	}
	FileAppend, %all_text%, %CandySel_ParentPath%\�ϲ�.txt
	all_text := text := ""
Return

Cando_�ļ��б�:
	; dateCut := A_Now
	; EnvAdd, dateCut, -1, days       ; sets a date -24 hours from now
	�б�������ļ�=%A_Temp%\���������ļ��б���ʱ�ļ�_%A_now%.txt

	loop, %CandySel%\*.*, 1, 1   ; change the folder name
	{
		;    if (A_LoopFileTimeModified >= dateCut)
		str .= A_LoopFileFullPath "`n"
	}
	FileAppend, %str%, %�б�������ļ�%
	str := ""
	Run, notepad.exe %�б�������ļ�%
Return

Cando_�����ļ���:
	SwapName(CandySel)
Return

SwapName(Filelist)
{
	; ���ݵ��ַ����еĻ����ǻس�+����
	StringReplace, Filelist, Filelist, `r`n, `n
	StringSplit, File_, Filelist, `n
	SplitPath, File_1, , FileDir, , FileNameNoExt
	;msgbox % fileexist(File_1) " - " fileexist(File_2)
	FileMove, %File_1%, %FileDir%\%FileNameNoExt%.tempExt
	FileMove, %File_2%, %File_1%
	FileMove, %FileDir%\%FileNameNoExt%.tempExt, %File_2%
return
}

cando_���ļ������ļ���:
	clip := ""
	Loop, Parse, CandySel, `n,`r 
	{
		SplitPath, A_LoopField, outfilename
		clip .= (clip = "" ? "" : "`r`n") outfilename
	}
	clipboard := clip
return

cando_���ļ�����·��:
	clip := ""
	Loop, Parse, CandySel, `n,`r 
	{
		SplitPath, A_LoopField, outfilename
		clip .= (clip = "" ? "" : "`r`n") outfilename
	}
	clipboard:=clip
return

Cando_���ɿ�ݷ�ʽ:
	FileCreateShortcut, %CandySel%, %CandySel_ParentPath%\%CandySel_FileNameNoExt%.lnk
Return

Cando_���ɿ�ݷ�ʽ��ָ��Ŀ¼:
	Gui,66:Destroy
	Gui,66:Default
	Gui, Add, Text, x10 y17, Ŀ���ļ�(&T)
	Gui, Add, Edit, x110 y15 w300 readonly vSHLTG_Path, % CandySel
	Gui, Add, Text, x10 y48, ��ݷ�ʽĿ¼(&P)
	Gui, Add, Edit, x110 y46 w300 vSHL_Path,
	Gui, Add, CheckBox, x110 y70 w40 h30 vSHL_Desktop, ����
	Gui, Add, CheckBox, x168 y70 w78 h30 vSHL_QL, ����������
	Gui, Add, CheckBox, x260 y70 w78 h30 vSHL_Fav, �ű��ղؼ�
	Gui, Add, Text, x10 y110, ��ݷ�ʽ����(&N)
	Gui, Add, Edit, x110 y108 w300 vSHL_Name, %CandySel_FileNameNoExt%
	Gui, Add, Button, x220 y140 w80 h25 Default gSHL_OK, ȷ��(&S)
	Gui, Add, Button, x320 y140 w80 h25 g66GuiClose, ȡ��(&X)
	Gui,show, , Ϊ�ļ�[%CandySel_FileNameWithExt%]������ݷ�ʽ
Return

SHL_OK:
	Gui,66:Default
	Gui, Submit, NoHide
	SHL_Name:=Trim(SHL_Name), SHL_Path:=Trim(SHL_Path,"\"), errFlag := 0
	If (SHL_Name="")
		errFlag:=1, tempStr:="δ���ÿ�ݷ�ʽ����"
	If (errFlag=0) And (RegexMatch(SHL_Name, "[\\/:\*\?""<>\|]")>0)
		errFlag:=2, tempStr:="��ݷ�ʽ���Ʋ��ð������������ַ���\ / : * \ ? "" < > |"
	If (errFlag=0) And (SHL_Path !="") And !InStr(FileExist(SHL_Path), "D")
		errFlag:=3, tempStr:= "��ݷ�ʽĿ¼������"
	If (errFlag=0) And (FileExist(SHLTG_Path)="")
		errFlag:=4, tempStr:= "Ŀ���ļ�������"
	If (errFlag=0) And (SHL_Path="") And (SHL_Desktop=0) And (SHL_QL=0) And (SHL_Fav=0)
		errFlag:=5, tempStr:= "��ݷ�ʽĿ¼Ϊ�ղ���δ��ѡ��һĿ¼"
	If (errFlag=0) 
	{
		Gui, Destroy
		if (SHL_Path !="")
			FileCreateShortcut, % SHLTG_Path, %SHL_Path%\%SHL_Name%.lnk
		if SHL_Desktop
			FileCreateShortcut, % SHLTG_Path, %A_desktop%\%SHL_Name%.lnk
		if SHL_QL
			FileCreateShortcut, % SHLTG_Path, %A_AppData%\Microsoft\Internet Explorer\Quick Launch\%SHL_Name%.lnk
		if SHL_Fav
			FileCreateShortcut, % SHLTG_Path, %A_ScriptDir%\favorites\%SHL_Name%.lnk
	}
	Else 
	{
		Gui, +OwnDialogs
		If errFlag In 1,2
			GuiControl, Focus, SHL_Name
		If errFlag In 3,5
			GuiControl, Focus, SHL_Path
		If errFlag In 4
			GuiControl, Focus, SHLTG_Path
		MsgBox, 262192, ������ݷ�ʽ����, %tempStr%��
	}
	errFlag:=tempStr:=SHLTG_Path:=SHL_Name:=SHL_Path:=""
return

cando_����ͬ���ļ���:
  FileCreateDir,%CandySel_ParentPath%\%CandySel_FileNamenoExt%
  FileMove,%CandySel%,%CandySel_ParentPath%\%CandySel_FileNamenoExt%
Return