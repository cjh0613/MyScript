;menu, % FolderMenu(A_desktop, "lnk","�ղؼ�",1,2,1,1), show
;menu, % FolderMenu("D:\Program Files\����\win 7\Favorites", "lnk","�ղؼ�",1,2,1,0), show

; FolderMenu ��������
; FolderPath             �ļ���·�������ͣ��ַ���������Ĳ������� "C:\"
; SpecifyExt             ָ��Ҫ��ʾ���ļ�����չ�������ͣ��ַ�������ѡ ���� "lnk"��"exe"��Ĭ��ֵ"*"
; MenuName               �Ƿ�ָ���˵����ƣ����ͣ��ַ�����Ĭ��ֵΪ��
; ShowIcon               �˵��Ƿ��ͼ�꣬���ͣ�����ֵ 0 �� 1��Ĭ��ֵ 1
; ShowOpenFolderMenu     �Ƿ���ʾ���ļ��еġ��򿪡��˵������ͣ�����ֵ 0 �� 1��Ĭ��ֵ 1
;                        ����ֵ 2, Ч����ͬ�� 0����ͬ�������ڵײ���ʾ��Ŀ¼�Ĵ򿪲˵�
; Showhide               �Ƿ���ʾ�����ļ������ͣ�����ֵ 0 �� 1��Ĭ��ֵ 0
; FolderFirst            ���ļ�����ǰ�����ͣ�����ֵ 0 �� 1��Ĭ��ֵ 1
;                        ֵΪ 1 ʱ���ļ��˵����ļ�������(��������׼)��ֵΪ 0 ʱ��������(��loop�ļ���˳��)
; FolderMenu ��������ֵ  �˵����� MenuName
;                        ���ļ����������� 50���ļ��������� 500�����ؿ�ֵ


FolderMenu(FolderPath, SpecifyExt:="*", MenuName:="",ShowIcon:=1, ShowOpenFolderMenu:=1, Showhide:=0, FolderFirst:=1)
{
	MenuName := MenuName ? MenuName : FolderPath
	
	if (ShowOpenFolderMenu = 1)
	{
		BoundRun := Func("Run").Bind(FolderPath)
		Menu, %MenuName%, add, �� %FolderPath%, %BoundRun%
		if ShowIcon
			FolderMenu_AddIcon(MenuName, "�� " . FolderPath)
		Menu, %MenuName%, add
	}

	if !FolderFirst
	{
		ExistSubMenuName:={}
		Loop, %FolderPath%\*.%SpecifyExt%, 0, 1  ; �ļ�
		{
			if (A_Index > 500)
			{
				msgbox, ,Ŀ¼�˵�����ʧ��, ѡ���ļ������ļ����࣬�޷������˵���`n��������`n�ļ��У�50���ļ���500��
			return
			}
			if !Showhide
			{
				if A_LoopFileAttrib contains H,R,S  ; �������� H(����), R(ֻ��) �� S(ϵͳ) ���Ե��κ��ļ�. ע��: �� "H,R,S" �в����ո�.
				continue  ; ��������ļ���ǰ������һ��.
			}
			StringGetPos, pos, A_LoopFileLongPath, \, R
			StringLeft, ParentFolderDirectory, A_LoopFileLongPath, %pos%
			ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
			if (ShowOpenFolderMenu=1) & (ParentFolderDirectory != MenuName) & !ExistSubMenuName[ParentFolderDirectory]
			{
				ExistSubMenuName[ParentFolderDirectory]:=1
				BoundRun := Func("Run").Bind(ParentFolderDirectory)
				StringGetPos, pos, ParentFolderDirectory, \, R
				StringTrimLeft, SubMenuName, ParentFolderDirectory, % pos+1
				Menu, %ParentFolderDirectory%, add, �� %SubMenuName%, %BoundRun%
				if ShowIcon
					FolderMenu_AddIcon(ParentFolderDirectory, "�� " . SubMenuName)
				Menu, %ParentFolderDirectory%, add
			}
			;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
			FileMenuName := (A_LoopFileExt!="lnk")?A_LoopFileName:StrReplace(A_LoopFileName, ".lnk")
			BoundRun := Func("Run").Bind(A_LoopFileLongPath)
			Menu, %ParentFolderDirectory%, add, %FileMenuName%, %BoundRun%
			if ShowIcon
				FolderMenu_AddIcon(ParentFolderDirectory, FileMenuName)
		}
	}

	Loop, %FolderPath%\*.*, 2, 1   ; �ļ���
	{
		if (A_Index > 50)
		{
			msgbox, ,Ŀ¼�˵�����ʧ��, ѡ���ļ������ļ����࣬�޷������˵���`n��������`n�ļ��У�50���ļ���500��
		return
		}
		if !Showhide
		{
			if A_LoopFileAttrib contains H,R,S  ; �������� H(����), R(ֻ��) �� S(ϵͳ) ���Ե��κ��ļ�. ע��: �� "H,R,S" �в����ո�.
			continue  ; ��������ļ���ǰ������һ��.
		}
		StringGetPos, pos, A_LoopFileLongPath, \, R
			StringLeft, ParentFolderDirectory, A_LoopFileLongPath, %pos%
		;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
		ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
		if FolderFirst || !ExistSubMenuName[A_LoopFileLongPath]
		{
			BoundRun := Func("Run").Bind(A_LoopFileLongPath)
			Menu, %A_LoopFileLongPath%, add, �� %A_LoopFileName%, %BoundRun%
			if (ShowOpenFolderMenu=1)
			{
				if ShowIcon
					FolderMenu_AddIcon(A_LoopFileLongPath, "�� " . A_LoopFileName)
				filecount := 0
				Loop, %A_LoopFileLongPath%\*.%SpecifyExt%, 1, 0
				{
					filecount++
					break
				}
				Loop, %A_LoopFileLongPath%\*.*, 2, 0
				{
					filecount++
					break
				}
				if filecount
					Menu, %A_LoopFileLongPath%, add
			}
		}
		Menu, %ParentFolderDirectory%, add, %A_LoopFileName%, :%A_LoopFileLongPath%
		if ShowIcon
			FolderMenu_AddIcon(ParentFolderDirectory, A_LoopFileName)
		if (ShowOpenFolderMenu!=1)
		{
			Menu, %A_LoopFileLongPath%, Delete, �� %A_LoopFileName%
			filecount := 0
			Loop, %A_LoopFileLongPath%\*.%SpecifyExt%, 0, 1
			{
				filecount++
				break
			}
			if !filecount
				Menu, %A_LoopFileLongPath%, Delete
		}
	}
	
	if FolderFirst
	{
		Loop, %FolderPath%\*.%SpecifyExt%, 0, 1  ; �ļ�
		{
			if (A_Index > 500)
			{
				msgbox, ,Ŀ¼�˵�����ʧ��, ѡ���ļ������ļ����࣬�޷������˵���`n��������`n�ļ��У�50���ļ���500��
			return
			}
			FileList .= A_LoopFileLongPath "`n"
		}
		Sort, FileList, \
		Loop, parse, FileList, `n
		{
			if A_LoopField =
			continue
			if !Showhide
			{
				FileGetAttrib, FileAttrib, A_LoopField
				if FileAttrib contains H,R,S  ; �������� H(����), R(ֻ��) �� S(ϵͳ) ���Ե��κ��ļ�. ע��: �� "H,R,S" �в����ո�.
				continue  ; ��������ļ���ǰ������һ��.
			}
			SplitPath, A_LoopField, FileName, ParentFolderDirectory, fileExt, FileNameNoExt
			ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
			;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
			BoundRun := Func("Run").Bind(A_LoopField)
			FileMenuName := (FileExt!="lnk")?FileName:FileNameNoExt
			Menu, %ParentFolderDirectory%, add, %FileMenuName%, %BoundRun%
			if ShowIcon
				FolderMenu_AddIcon(ParentFolderDirectory, FileMenuName)
		}
	}

	if (ShowOpenFolderMenu = 2)
	{
		Menu, %MenuName%, add
		BoundRun := Func("Run").Bind(FolderPath)
		Menu, %MenuName%, add, �� %FolderPath%, %BoundRun%
		if ShowIcon
		 FolderMenu_AddIcon(MenuName, "�� " . FolderPath)
	}
	return MenuName
}

Run(a) {
	run, %a%
}

FolderMenu_AddIcon(menuitem,submenu)
{
	; Allocate memory for a SHFILEINFOW struct.
	VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
	
	; Get the file's icon.
	if DllCall("shell32\SHGetFileInfoW", "wstr", A_LoopFileLongPath?A_LoopFileLongPath:A_LoopField
		, "uint", 0, "ptr", &fileinfo, "uint", fisize, "uint", 0x100 | 0x000000001)
	{
		hicon := NumGet(fileinfo, 0, "ptr")
		; Set the menu item's icon.
		Menu %menuitem%, Icon, %submenu%, HICON:%hicon%
		; Because we used ":" and not ":*", the icon will be automatically
		; freed when the program exits or if the menu or item is deleted.
	}
}