OnTrayIcon(uid, Event)
{
	if event not in R,L
	return

	if (Event = "L")
	{
		if uid=101
		{
			FuncsIcon_ClickRun(101,"L")
		return
		}
		else if uid=102
		{
			FuncsIcon_ClickRun(102,"L")
		return
		}
	}
	if (Event = "R")
	{
		if uid=101
		{
			FuncsIcon_ClickRun(101,"R")
		return
		}
		else if uid=102
		{
			FuncsIcon_ClickRun(102,"R")
		return
		}
	}
}

FuncsIcon_ClickRun(uid,Event)
{
global Candy_Cmd,candysel
ClickRun:=(Event="l")?"leftClick":(Event="r")?"rightClick":""
IniRead, Candy_Cmd, %run_iniFile%, % uid, Ti_%uid%_%ClickRun%

candysel:="����ͼ��*" uid
	If !(RegExMatch(Candy_Cmd,"i)^Menu\|"))
	{
		Gosub Label_Candy_RunCommand            ; �������menuָ�ֱ����ת������Ӧ�ó���
	}
	else
		Gosub Label_Candy_DrawMenu
return
}

removeTi:
TrayIcon_Remove(hGui, uid)
return