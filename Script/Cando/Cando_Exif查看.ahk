Cando_Exif�鿴:
	Gui 66: Destroy
	RunWait,regsvr32.exe `/s %SImageUtil%
	Image := ComObjCreate("SImageUtil.Image")
	Image.OpenImageFile(Candysel)


	Main := Object()
	Main.Desc := "����"
	Main.Make := "���������"
	Main.Model := "����ͺ�"
	Main.Ori := "����"
	Main.XRes := "ˮƽ�ֱ���"
	Main.YRes := "��ֱ�ֱ���"
	Main.ResUnit :=     "�ֱ��ʵ�λ"
	Main.Software := "�̼��汾"
	Main.ModTime := "�޸�ʱ��"
	Main.WPoint := "�׵�ɫ��"
	Main.PrimChr := "��Ҫɫ��"
	Main.YCbCrCoef := "��ɫ�ռ�ת������ϵ��"
	Main.YCbCrPos := "ɫ�ඨλ"
	Main.RefBW := "�ڰײ���ֵ"
	Main.Copy := "��Ȩ"
	Main.ExifOffset := "��IFDƫ����"
	; XP tags
	Main.Title := "����"
	Main.Comments := "��ע"
	Main.Author := "����"
	Main.Keywords := "���"
	Main.Subject := "����"

	Sub := Object()
	Sub.s :=  "�ع�ʱ��"
	Sub.f := "��Ȧ����(Fֵ)"
	Sub.prog :=   "�ع����"
	Sub.iso := "�й��(ISO �ٶ�)"
	Sub.ExifVer := "Exif �汾"
	Sub.OrigTime := "����ʱ��"
	Sub.DigTime := "���ֻ�ʱ��"
	Sub.CompConfig := "ͼ����"
	Sub.bpp := "ƽ��ѹ����"
	Sub.sa := "�����ٶ�"
	Sub.aa := "��ͷ��Ȧ"
	Sub.ba := "����"
	Sub.eba := "�عⲹ��"
	Sub.maa := "����Ȧ"
	Sub.dist := "���(Ŀ�����)"
	Sub.meter := "���ģʽ"
	Sub.ls := "��Դ"
	Sub.flash := "�����"
	Sub.focal :=   "����"
	Sub.Maker := "������������Ϣ"
	Sub.User := "�û����"
	Sub.sTime := "����ʱ��"
	Sub.sOrigTime := "ԭʼ����ʱ��"
	Sub.sDigTime := "ԭʼ����ʱ�����ֻ�"
	Sub.flashpix := "Flash Pix �汾"
	Sub.ColorSpace :=  "ɫ��ģʽ"
	Sub.Width := "ͼƬ���"
	Sub.Height := "ͼƬ�߶�"
	Sub.SndFile := "�����ļ�"
	Sub.ExitIntOff := "Exif ����ƫ����"
	Sub.FPXRes := "��ƽ��ˮƽ��ֱ���"
	Sub.FPYRes := "��ƽ�洹ֱ��ֱ���"
	Sub.FPResUnit := "��ƽ�浥λ"
	Sub.ExpIndex := "�ع�ָ��"
	Sub.SenseMethod := "��������"
	Sub.FileSource :=  "Դ�ļ�"
	Sub.SceneType := "��������"
	Sub.CFAPat := "CFA ģ��"


	Gui 66: Margin,0 0
	Gui 66: Add, ListView, x0 y0  w600 r40  vMyLV, ����|ֵ
	GuiControl 66: -Redraw, MyLV
    Gui,66:Default   ;�ڶ�gui����lv������£�Ϊ����lv��ʾ�����gui�ϣ���������
	Gui, ListView, MyLV

	For k,v in Main
	 if (value := Image.GetExif("Main." . k))
	  LV_Add("",v,value)

	For k,v in Sub
	 if (value := Image.GetExif("Sub." . k))
	  LV_Add("",v,value)

	GuiControl 66: +Redraw, MyLV
	LV_ModifyCol(1,180)
	LV_ModifyCol(2,400)
	Gui 66: Show, , Exif ��Ϣ
	Image.Close()
	;RunWait,regsvr32.exe `/s `/u %SImageUtil%
	Return