/*!
	����: File_GetEncoding
		���� chardet Py��, ����ļ��Ĵ���ҳ.

	����:
		aFile - Ҫ�������ⲿ�ļ�·��.

	��ע:
			> ע��:
			> ANSI �ĵ�ΪȫӢ��ʱ, Ĭ�Ϸ��� UTF-8.

	����ֵ:
		�ַ���
		0      - ����, �ļ�������
		CPnnn  - ANSI (CPnnn), ������������ַ���, ���ܺ� UTF-8 ��ǩ�� ���ֿ�.
		UTF-16 - text Utf-16 LE File
		CP1201 - text Utf-16 BE File
		UTF-32 - text Utf-32 BE/LE File
		UTF-8  - text Utf-8 File (UTF-8 + BOM). ������ļ�̫С, �����Լ��ʱ, Ĭ�Ϸ��� UTF-8.
		UTF-8-RAW  - UTF-8 ��ǩ��. 
		���� UTF-8-RAW ��˵����
		1.�ļ�С��100k ��ȡ�����ļ�, ������������ַ���(�ļ��д������루�����ַ���ʱ���ܵõ�����Ľ��), ���ܺ� CP936 ���ֿ�.
		2.�ļ�����100k ��ȡ�ļ�ǰ9���ֽڣ�ǰ3���ַ�Ϊ����ʱ���нϴ����ȡ����ȷ�Ľ��, ���ܺ� CP936 ���ֿ���
*/

; isBinFile
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=144&start=20

/*
; ʾ��
Loop, Files, *.txt
msgbox % A_LoopFileName " - " File_GetEncoding(A_LoopFileLongPath)
*/

File_GetEncoding(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0
	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	;force position to 0 (zero)
	_hFile.Position := 0

	; �ļ�С��100k,���ȡ�����ļ�
	_nBytes := (_hFile.length < 102400) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes > 0) ? (_hFile.RawRead(_rawBytes, aNumBytes)) : (_hFile.RawRead(_rawBytes, 9))

	_hFile.Close()

	; Ϊ�� unicode ���, �Ƽ� aMinimum Ϊ 4  (4���ֽ����µ��ļ��޷��ж�����)
	if (_nBytes < aMinimum)
	{
		; ����ı�̫�̣����ر���"UTF-8"
		return "UTF-8"
	}

	;Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ;create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	;determine BOM if possible/existant
	if ((_bytesArr[0]=0xFE) && (_bytesArr[1]=0xFF))
	{
		;text Utf-16 BE File
		return "CP1201"
	}
	if ((_bytesArr[0]=0xFF) && (_bytesArr[1]=0xFE))
	{
		;text Utf-16 LE File
		return "UTF-16"
	}
	if ((_bytesArr[0]=0xEF)	&& (_bytesArr[1]=0xBB) && (_bytesArr[2]=0xBF))
	{
		;text Utf-8 File
		return "UTF-8"
	}
	if ((_bytesArr[0]=0x00)	&& (_bytesArr[1]=0x00) && (_bytesArr[2]=0xFE) && (_bytesArr[3]=0xFF))
	|| ((_bytesArr[0]=0xFF)	&& (_bytesArr[1]=0xFE) && (_bytesArr[2]=0x00) && (_bytesArr[3]=0x00))
	{
		;text Utf-32 BE/LE File
		return "UTF-32"
	}

	while(_i < _nBytes)
	{

		;// ASCII
		if (_bytesArr[_i] == 0x09)
		|| (_bytesArr[_i] == 0x0A)
		|| (_bytesArr[_i] == 0x0D)
		|| ((0x20 <= _bytesArr[_i]) && (_bytesArr[_i] <= 0x7E))
		{
			_i += 1
			continue
		}

		;// non-overlong 2-byte
		if (0xC2 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xDF)
		&& (0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF)
		{
			_i += 2
			continue
		}

		;// excluding overlongs, straight 3-byte, excluding surrogates
		if (((_bytesArr[_i] == 0xE0)
		&& ((0xA0 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((((0xE1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xEC))
		|| (_bytesArr[_i] == 0xEE)
		|| (_bytesArr[_i] == 0xEF))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xED)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x9F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))))
		{
			_i += 3
			continue
		}
		;// planes 1-3, planes 4-15, plane 16
		if (((_bytesArr[_i] == 0xF0)
		&& ((0x90 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
			&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| (((0xF1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xF3))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xF4)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x8F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF))))
		{
			_i += 4
			continue
		}
		_t := 1
		break
	}

	; while ѭ��û��ʧ�ܣ�Ȼ��ȷ��Ϊutf-8
	if (_t = 0)
	{
		return "UTF-8-RAW"
	}

	; ���ͨ�������ж�û�л�ȡ���ļ�����
	; ͨ������ļ��Ƿ��в��ɼ��ַ������ж��Ƿ�Ϊexe���͵Ķ������ļ�
/*
	loop, %_nBytes%
	{
		if ((_bytesArr[(A_Index - 1)] > 0) && (_bytesArr[(A_Index - 1)] < 9))
		|| ((_bytesArr[(A_Index - 1)] > 13) && (_bytesArr[(A_Index - 1)] < 20))
		{
			return 1
		}
	}
*/
	; δ�������������ķ���ϵͳĬ�� ansi ����
	; ��������ϵͳĬ�Ϸ��ص��� CP936
	return "CP" DllCall("GetACP")  
}  