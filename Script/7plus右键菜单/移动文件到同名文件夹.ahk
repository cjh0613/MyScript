;����lnk�ļ���Ч(����lnk�ļ�����Ч)
1003:
	;MsgBox
	SetTimer,�ƶ��ļ���ͬ���ļ���,-200
Return

;�ļ��ƶ���ͬ���ļ�����
;����lnk�ļ���Ч  �޷����lnk ��׺
;����ݼ�Ϊ���Ϊ G:\Users\lyh\Desktop\QQ  ʵ��ΪQQ.lnk
;#G::
�ƶ��ļ���ͬ���ļ���:
sleep,200
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ��5��,3
	Return
}
Critical,Off

Loop, Parse, files, `n,`r
{
	FileFullPath := A_LoopField
	SplitPath,FileFullPath,FileName,FilePath,FileExtension,FileNameNoExt
	creatfolder = %FilePath%\%FileNameNoExt%
	IfNotExist %creatfolder%
	{
		FileCreateDir,%creatfolder%
		FileMove,%FileFullPath%,%creatfolder%
	}
	else
	{
		TargetFile = %creatfolder%\%FileName%
		ifExist, %TargetFile%
		{
			ind = 1
			Loop, 100
			{
				TargetFile = %creatfolder%\%FileNameNoExt%_(%ind%).%FileExtension%
				ifExist, %TargetFile%
				{
					ind += 1
					continue
				}
				else
				{
					Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
					break
				}
			}
		}
		; ��ͬ���ļ�ʱ�������ļ�
		else
		{
			Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
		}
	}
}
Return

7PlusMenu_�ƶ��ļ���ͬ���ļ���()
{
	section = �ƶ��ļ���ͬ���ļ���
	defaultSet=
	( LTrim
ID = 1003
Name = File(s)2Folder(s)
Description = �ƶ��ļ���ͬ���ļ���(֧�ֶ��ļ�)
SubMenu = 7plus
FileTypes = *
SingleFileOnly = 0
Directory = 0
DirectoryBackground = 0
Desktop = 0
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}