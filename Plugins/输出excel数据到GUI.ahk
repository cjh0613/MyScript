;��Դ��ַ: https://www.autoahk.com/archives/18627
SplitPath A_AhkPath,, AhkDir
If (A_PtrSize = 8 || !A_IsUnicode) {
    U32 := AhkDir . "AutoHotkeyU32.exe"
    If (FileExist(U32)) {
        Run % U32 . " """ . A_LineFile . ""
        ExitApp
    } Else {
        MsgBox 0x40010, AutoGUI, AutoHotkey 32-bit Unicode not found.
        ExitApp
    }
}

file := A_Args[1]

;Thinkai@2015-11-05
Gui, Add, Tab, x0 y0 w800 h500 vtab
Gui, Show, , % File " - �ļ�Ԥ��"
;FileSelectFile, file, , , ѡ��һ�����, Excel�ļ�(*.xls;*.xlsx)
IfNotExist % file
    ExitApp
conn := ComObjCreate("ADODB.connection") ;��ʼ��COM
;�����ֺ�׺��������03��07��ʽ
/*
try
	conn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties='Excel 8.0;HDR=Yes';Data Source=" file) ;������ 2003��ʽ
catch e03
{
	try
		conn.Open("Provider=Microsoft.Ace.OLEDB.12.0;Extended Properties=Excel 12.0;Data Source=" file) ;������
	catch e07
		MsgBox, 4112, ����, % "������office 2003��ʽ�򿪳���`n" e03.Message "`n������office 2007��ʽ�򿪳���`n" e07.Message "`n���飡"
}
*/
if RegExMatch(file,".xlsx$")
{
	try
		conn.Open("Provider=Microsoft.Ace.OLEDB.12.0;Extended Properties=Excel 12.0;Data Source=" file) ;������
	catch e07
		MsgBox, 4112, ����, % "������office 2007��ʽ�򿪳���`n" e07.Message "`n���飡"
}
else
{
	try
		conn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties='Excel 8.0;HDR=Yes';Data Source=" file) ;������ 2003��ʽ
	catch e03
		MsgBox, 4112, ����, % "������office 2003��ʽ�򿪳���`n" e03.Message "`n���飡"
}
 
;ͨ��OpenSchema������ȡ����Ϣ
rs := conn.OpenSchema(20) ;SchemaEnum �ο� http://www.w3school.com.cn/ado/app_schemaenum.asp
table_info := []
table_name := []
rs.MoveFirst()
while !rs.EOF ;��ЧSheet
{
;fileappend, % rs.("TABLE_NAME").value "`n",%A_desktop%\123.txt
	t_name := RegExReplace(rs.("TABLE_NAME").value,"^'*(.*)\$'*$","$1")
;fileappend, % t_name "`n",%A_desktop%\123.txt
	t_name := Trim(t_name, "$")
;fileappend, % t_name "`n`n",%A_desktop%\123.txt

	if InStr(t_name, "_")   ; �����д���"_"�ַ���������
{
	rs.MoveNext()
		continue
}
	table_name[t_name] := rs.("TABLE_NAME").value
	q := conn.Execute("select top 1 * from [" t_name "$]")
 
	if (q.Fields(0).Name="F1" && q.Fields.Count=1) ;�ų��ձ��!!!!!!!!!
	{
		rs.MoveNext()
		continue
	}
	
 
	table_info[t_name] := []
	for field in q.Fields  ;��ȡ��˳�����е��ֶ�
		table_info[t_name].insert(field.Name)
	q.close()
	rs.MoveNext()
}
;����Listview
for t,c in table_info
{
	;����tab��listview
	GuiControl, , tab, % t
	Gui, Tab, % A_index
	cols =
	for k,v in c
		cols .= cols ? "|" v : v
	Gui, Add, ListView, % "x10 y50 w780 h460 vlv" A_Index, % cols
	Gui, ListView, % "lv" A_Index
 
	;��ȡ�������
	data := GetTable("select * from [" table_name[t] "]")
	for k,v in data
		LV_Add("",v*)
 
	LV_ModifyCol() ;�Զ������п�
}
rs.close()
conn.close()
return

$Space::
GuiClose:
ExitApp
 
GetTable(sql){ ;Adodbͨ�õĻ�ȡ��������ĺ���
    global conn
    t := []
	try
	{
		query := conn.Execute(sql)
		fetchedArray := query.GetRows() ;ȡ�����ݣ���ά���飩
	}
	catch e
	{
		MsgBox, 4112, ����, % e03.Message "`n���飡"
		return []
	}
    colSize := fetchedArray.MaxIndex(1) + 1 ;�����ֵ tips����0��ʼ ����Ҫ+1
    rowSize := fetchedArray.MaxIndex(2) + 1 ;�����ֵ tips����0��ʼ ����Ҫ+1
    loop, % rowSize
    {
        i := (y := A_index) - 1
        t[y] := []
        loop, % colSize
        {
            j := (x := A_index) - 1
            t[y][x] := fetchedArray[j,i] ;ȡ����ά������ֵ
        }
    }
	query.close()
    return t
}
