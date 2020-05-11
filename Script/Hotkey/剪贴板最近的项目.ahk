cliphistoryPI:
!`::
	IfWinExist, �������������Ŀ ahk_class AutoHotkeyGUI
	{
		Gui,66:Destroy
		return
	}
refreshcliphistoryPI:
	Gui,66:Destroy
	Gui,66:Default
	IniRead, CHPIF, %run_iniFile%, ����, CHPIF   ; �������ղؼ�(���5��)
	CHPIFArray := StrSplit(CHPIF, ",")
	Loop, % CHPIFNo := CHPIFArray.Length()
	{
		button_y:=(A_index-1)*40+5
		button_y2:= button_y + 15
temp_V := ""
		tpos:=InStr(temp_Va := getFromTable("history", "data", "id=" CHPIFArray[A_index])[1], "`n")
		temp_V := SubStr(temp_Va, 1, tpos=0?30:tpos<30?tpos-2:30) . (tpos=0?StrLen(temp_Va)<30?"":" ... ":" ... (�����ı�)")

		Gui, Add, Button, x5 y%button_y% w400 h40 vCHPIF_%A_index% gcopycliphistoryPIF, % temp_V
		Gui, Add, Text, Cyellow x410 y%button_y2% w20 h20 vDCHPIF_%A_index% gDCHPIF, ��
		Gui, Add, Text, Cred x440 y%button_y2% w20 h20 vDCHPI1_%A_index% gDCHPI1, ��
	}
	Num := 15 - CHPIFNo
	ReadcliphistoryPI(Num)
	Loop, % Num
	{
		button_y:=(A_index + CHPIFNo - 1)*40 + 5
		button_y2:= button_y + 15

		tpos:=InStr(temp_Va:=cliphistoryPI[A_index], "`n")
		temp_V := SubStr(temp_Va, 1, tpos=0?30:tpos<30?tpos-2:30) . (tpos=0?StrLen(temp_Va)<30?"":" ... ":" ... (�����ı�)")

		Gui, Add, Button, x5 y%button_y% w400 h40 vCHPI_%A_index% gcopycliphistoryPI, % temp_V
		Gui, Add, Text, x410 y%button_y2% w20 h20 vSCHPIF_%A_index% gSCHPIF, ��
		Gui, Add, Text, Cred x440 y%button_y2% w20 h20 vDCHPI2_%A_index% gDCHPI2, ��
	}
	Gui,show,,�������������Ŀ
return

ReadcliphistoryPI(Num)  ; �Ӽ��������ݿ��ж�ȡ���µ�N����Ŀ
{
	local result, Row
	q := "select * from history order by id desc limit " Num
	result := ""
	cliphistoryPI := []
	cliphistoryPI_ID :=[]
	if !DB.GetTable(q, result)
		msgbox error
	loop % result.RowCount
	{
		result.Next(Row)
		cliphistoryPI_ID[A_index]:= Row[1]
		cliphistoryPI[A_index]:= Row[2]
	}
return
}

copycliphistoryPIF:  ; ���Ƽ������������Ŀ�ղؼ��е���Ŀ��������
	WB_id := StrReplace(A_GuiControl , "CHPIF_", "")
	temp_read := getFromTable("history", "data", "id=" CHPIFArray[WB_id])[1]
	monitor=0
	try Clipboard := temp_Read
	sleep,300
	monitor=1
return

copycliphistoryPI:  ; ���Ƽ������������Ŀ�е���Ŀ��������
	WB_id := StrReplace(A_GuiControl , "CHPI_", "")
	temp_read := getFromTable("history", "data", "id=" cliphistoryPI_ID[WB_id])[1]
	monitor=0
	try Clipboard := temp_Read
	sleep,300
	monitor=1
return

DCHPIF:  ; ɾ���������ղؼ��е���Ŀ
	WB_id := StrReplace(A_GuiControl , "DCHPIF_", "")
	CHPIFArray.RemoveAt(WB_id)
	i:=""
	for k,v in CHPIFArray
		i .= v ","
	CHPIF :=  Trim(i, ",")
	IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	Gosub refreshcliphistoryPI
return

SCHPIF:  ; ��ӵ��������ղؼ�
	WB_id := StrReplace(A_GuiControl , "SCHPIF_", "")
	Loop, % CHPIFArray.Length()
	{
		if (CHPIFArray[A_index] = cliphistoryPI_ID[WB_id])
		{
			msgbox ���Ѿ�����˸���Ŀ�������ظ���ӡ�
		return
		}
	}

	CHPIF := cliphistoryPI_ID[WB_id] "," CHPIF
	CHPIF :=  Trim(CHPIF, ",")
	CHPIFArray := StrSplit(CHPIF, ",")
	if (CHPIFArray.Length() > 5)
		CHPIF := CHPIFArray[1] "," CHPIFArray[2] "," CHPIFArray[3] "," CHPIFArray[4] "," CHPIFArray[5] 
	IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	Gosub refreshcliphistoryPI
return

DCHPI1:
	WB_id := StrReplace(A_GuiControl , "DCHPI1_", "")
	deleteHistoryById(CHPIFArray[WB_id])
	CHPIFArray.RemoveAt(WB_id)
	i:=""
	for k,v in CHPIFArray
		i .= v ","
	CHPIF :=  Trim(i, ",")
	IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	Gosub refreshcliphistoryPI
return

DCHPI2:
	cjdata := 0
	WB_id := StrReplace(A_GuiControl , "DCHPI2_", "")
	deleteHistoryById(cliphistoryPI_ID[WB_id])
	Loop, % CHPIFArray.Length()
	{
		if (CHPIFArray[A_index] = cliphistoryPI_ID[WB_id])
		{
			CHPIFArray.delete(A_index)
			cjdata:=1
		}
	}
	if cjdata
	{
		i:=""
		for k,v in CHPIFArray
			i .= v ","
		CHPIF :=  Trim(i, ",")
		IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	}
	Gosub refreshcliphistoryPI
return