﻿; https://autohotkey.com/boards/viewtopic.php?f=6&t=3702

GetActiveBrowserURL(sClass, WithProtocol:=1) {
	static ModernBrowsers, LegacyBrowsers,OtherBrowsers
ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1,360se6_Frame,QQBrowser_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"
OtherBrowsers := "AuroraMainFrame"
	if !sclass
		WinGetClass, sClass, A
	If sClass In % ModernBrowsers
		Return GetBrowserURL_ACC(sClass, WithProtocol)
	Else If sClass In % LegacyBrowsers
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
	Else If sClass In % OtherBrowsers
		Return GetBrowserURL_hK()
	Else
		Return ""
}

GetBrowserURL_hK()
{
	Send, ^l
	sleep,300
	sURL:=GetSelText()
	if IsURL(sURL)
	Return sURL
}

; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
	Return sWindowInfo2
}

; 由类获取窗口id，在检测隐藏窗口开启时，可能会得不到正确的窗口id
GetBrowserURL_ACC(sClass, WithProtocol:=1) {
	global nWindow, accAddressBar
	BackUp_DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo
		If (nWindows > 1) {
			loop % nWindows {
				Tmp_nWindows := nWindows%A_index%
				if (Tmp_nWindows = nWindow)
					continue
				accAddressBar := GetAddressBar(Acc_ObjectFromWindow(Tmp_nWindows))
				Try sURL := accAddressBar.accValue(0)
				if (sURL !=""){
					;msgbox % "1" sURL "1"
					break
				}
			}
		}
	}

	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
		sURL := WithProtocol ? "http://" sURL : sURL
	If (sURL == "")
		nWindow := -1 ; Don't remember the window if there is no URL
	DetectHiddenWindows, % BackUp_DetectHiddenWindows
	Return sURL
}

GetBrowserURL_ACC_byhwnd(hwnd := 0){
	if !hwnd
		hwnd := WinExist("A")
	accAddressBar := GetAddressBar(Acc_ObjectFromWindow(hwnd))
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "")
	return 0
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
	Return accObj

	Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
		Return accObj

	Try If ((accObj.accRole(0) == 42) and IsURL("file://" accObj.accValue(0))) ; Modern browsers omit "file://"
	Return accObj

	Try If ((accObj.accRole(0) == 42) and InStr( accObj.accValue(0),":/"))
	Return accObj

	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp|file):///?(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}