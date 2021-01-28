﻿; Eject any drive  ------------ Thalon
; http://www.autohotkey.com/forum/topic8923.html
; Eject Removable Hardware -------------- Vspider
; http://www.autohotkey.com/forum/topic54164.html
; Crazy Scripting : Safely Remove USB Flash Drive ------- skan
; http://www.autohotkey.com/forum/topic44873.html
; 2000下弹出U盘无效 XP下弹出后，盘符图标还在，托盘仍有显示
; https://autohotkey.com/boards/viewtopic.php?t=4491
; Eject() : For Removable storage devices
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4491

弹出U盘:
Devs =  `r`n
DevF = 0
Gosub, DeviceList
If (Devs = "`r`n") {
Traytip, 错误, 找不到可移动硬件, 10
return
}

DriveGet, RDRV, List, REMOVABLE
 StringReplace, RDRV, RDRV, A
 StringReplace, RDRV, RDRV, B
if (StrLen(RDRV)=1)  ; 只有一个U盘时直接弹出
	Driveletter := RDRV ":"
if (StrLen(RDRV)>1)  ; 两个U盘以上按下盘符字母弹出
{
Traytip, 直接按下可移动磁盘盘符的字母键以弹出磁盘, %Devs%, 10
SetCapsLockState, On
Input, Driveletter, L1
SetCapsLockState, Off
Traytip

 Loop, Parse, RDRV
  { If (Driveletter = A_LoopField)
  DevF = 1
  }
If (DevF = 0){
Traytip, Error, 找不到所输入的盘符的可移动硬件, 10
return
}
}

if ejecttype=1
{
Driveletter = %Driveletter%:
DrivePath = \\.\%Driveletter%
DriveGet, Label, Label, %Driveletter%

hVolume := DllCall("CreateFile"
      , str, DrivePath
      , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
      , UInt, 0x0      ;Tries to get exclusiv rights to the drive +++(see below)
      , UInt, Null
      , UInt, 0x3         ;OPEN_EXISTING
      , UInt, 0x0
      , UInt, NULL)

if A_LastError = 32         ;Another application has read or write-access to the drive (In this case no handle was retreived to release)
{
   hVolume := DllCall("CreateFile"         ;Get handle even if another application reads the drive
      , str, DrivePath
      , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
      , UInt, 0x1       ;FILE_SHARE_READ
      , UInt, Null
      , UInt, 0x3         ;OPEN_EXISTING
      , UInt, 0x0
      , UInt, NULL)

   if hVolume != -1
   {
      msgbox, 4164, 警告, 另一个应用程序正在读取此设备.`n确认继续弹出?
      IfMsgbox, No
      {
         DllCall("CloseHandle", UInt, hVolume)   ;Release handle here
         return
      }
   }

   if A_LastError = 32      ;No read access was possible also
   {
      msgbox, 4164, 警告!, 另一个应用程序正在写入此设备!`n确认继续弹出?
      IfMsgbox, No
         return
      else
      {
         hVolume := DllCall("CreateFile"         ;Get handle even if another application reads or writes to the drive
            , str, DrivePath
            , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
            , UInt, 0x1 | 0x2 ;FILE_SHARE_READ | FILE_SHARE_WRITE
            , UInt, Null
            , UInt, 0x3         ;OPEN_EXISTING
            , UInt, 0x0
            , UInt, NULL)
      }
   }
}

if hVolume != -1      ;Drive is thrown out
{
      DllCall("DeviceIoControl"
      , UInt, hVolume
      , UInt, 0x2D4808   ;IOCTL_STORAGE_EJECT_MEDIA
      , UInt, NULL
      , UInt, 0
      , UInt, NULL
      , UInt, 0
      , UInt, &dwBytesReturned   ;Not used
      , UInt,  NULL)

   DllCall("CloseHandle", UInt, hVolume)
   TrayTip, 安全删除硬件, %Driveletter% %Label% 现在可以安全地从计算机中删除., 2, 1
}
}
else if ejecttype=2
{
Driveletter = %Driveletter%:
USBD_SafelyRemove( Driveletter )
}
else
Eject(Driveletter) 
return

;^Q::
磁盘列表:
Menu, USB, Add, 全部磁盘,nul
Menu, USB, disable,全部磁盘
Menu, USB, Add
DriveGet, RDRV, List
StringReplace, RDRV, RDRV, A
StringReplace, RDRV, RDRV, B
 Loop, Parse, RDRV
  {
   DriveGet, Label, Label, %A_LoopField%:
   DriveGet, Size, Capacity, %A_LoopField%:
   Capacity := DriveSpace( A_LoopField,1 )
   VarSetCapacity( DiskFreeSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity, Str,DiskFreeSz, UInt,16 )

   Capacity2 := DriveSpace( A_LoopField,2 )
   VarSetCapacity( DiskSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity2, Str,DiskSz, UInt,16 )

   If (size != "")
   Menu, USB, Add, &%A_LoopField%: %Label%`t%DiskFreeSz% - %DiskSz%,opRem
  }
 Menu, USB, Show
 Menu, USB, DeleteAll
Return

DeviceList:
 DriveGet, RDRV, List, REMOVABLE
 StringReplace, RDRV, RDRV, A
 StringReplace, RDRV, RDRV, B
 Loop, Parse, RDRV
  {
   DriveGet, Label, Label, %A_LoopField%:
   DriveGet, Size, Capacity, %A_LoopField%:
   Capacity := DriveSpace( A_LoopField,2 ), VarSetCapacity( DiskSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity, Str,DiskSz, UInt,16 )
   If (Label = "") {
   Label = NO LABEL
   }
   Devs = %Devs% %A_LoopField%: %Label%`t`t%DiskSz% `r`n
  }
Return

DriveSpace(Drv="", Free=1)
{ ; www.autohotkey.com/forum/viewtopic.php?p=92483#92483
 Drv := Drv . ":\"
 VarSetCapacity(SPC, 30, 0)   ; Sectors Per Cluster
 VarSetCapacity(BPS, 30, 0)   ; Bytes Per Sector
 VarSetCapacity(FC , 30, 0)   ; Free Clusters
 VarSetCapacity(TC , 30, 0)   ; Total Clusters
 DllCall( "GetDiskFreeSpace", Str,Drv, UIntP,SPC, UIntP,BPS, UIntP,FC, UIntP,TC )
;msgbox % SPC "*" BPS "*" FC "*" SPC*BPS*FC
Return Free=1 ? (SPC*BPS*FC) : (SPC*BPS*TC) ; Ternary Operator requires 1.0.46+
}

WM_DEVICECHANGE(wParam, lParam)
{
   If (wParam=0x8000 || wParam=0x8004) ;DBT_DEVICEARRIVAL, DBT_DEVICEREMOVECOMPLETE
      {
          devicetype:=NumGet(lParam+0, 4) ;DEV_BROADCAST_HDR.dbcv_devicetype
          if (devicetype=2) ;2 = DBT_DEVTYP_VOLUME
              {
                   unitmask:=NumGet(lParam+0, 12) ;DEV_BROADCAST_VOLUME .dbcv_unitmask
                   NewDrive:=
                   NewDriveList:=
                   Loop, 26 ;查找设备的盘符。
                      {
                          NewDrive:=unitmask & 1
                          if NewDrive
                              {
                                  NewDriveName:=Chr(0x40 + A_Index)
                                  If (wParam = 0x8000)
                                      {
                                          Loop,6
                                             {
                                                 Sleep 500
                                                 DriveGet,DriveState,Status,%NewDriveName%:
                                                 If (DriveState = "Ready")
                                                      {
                                                          DriveGet,DriveLabel,Label,%NewDriveName%:
                                                          DriveGet,DriveType,Type,%NewDriveName%:
                                                          DriveGet,DriveCap,Capacity,%NewDriveName%:
                                                          Break
                                                      }
                                             }
                                          ;If (DriveLabel = "SYS" OR DriveCap = "")
                                          ;CanOpen := 0
                                          ;Else
                                          ;CanOpen := 1
                                          If (DriveType="CDROM")
                                          If (DriveCap>1000)
                                          DriveType:="DVD光盘"
                                          Else
                                          DriveType:="CD光盘"
                                          If (DriveType="Removable")
                                          DriveType:="可移动存储器"
                                          If (DriveType="Unknown")
                                          DriveType:="未知"
                                      }
                                  NewDriveList:=NewDriveList . "`n"DriveLabel . " (" . DriveType . " " . NewDriveName . ":)"
                              }
                          unitmask >>= 1
                      }

                   if wParam=0x8000 ;根据驱动器设定执行操作
                      {
                          TrayTip,Notices,下列媒体已插入!%NewDriveList%,,1
                          SetTimer,tipoff,3000
                      }
                  Else
                      {
                          TrayTip,Safe To Remove Hardware,下列媒体已弹出!%NewDriveList%,,1
                          SetTimer,tipoff,3000
                      }
              }
      }
}
Return

tipoff:
TrayTip,
Return

opRem:
StringMid,rempath,A_thismenuitem,2,2
run,%rempath%
Return

USBD_SafelyRemove( Drv ) {
 If ! ( Serial := USBD_GetDeviceSerial( Drv ) )
   Return
 DeviceID := USBD_GetDeviceID( Serial )
 DeviceEject( DeviceID )
 IfExist, %Drv%\, TrayTip, %DeviceID%, Drive %Drv% was not Ejected!, 10, 3
 Else, TrayTip, %DeviceID%, Drive %Drv% was safely Removed, 10, 1
}

USBD_GetDeviceSerial( Drv="" ) {
 DriveGet, DriveType, Type, %Drv%
 IfNotEqual,DriveType,Removable, Return
 RegRead, Hex, HKLM, SYSTEM\MountedDevices, \DosDevices\%Drv%
 VarSetCapacity(U,(Sz:=StrLen(Hex)//2)),  VarSetCapacity(A,Sz+1)
 Loop % Sz
  NumPut( "0x" . SubStr(hex,2*A_Index-1,2), U, A_Index-1, "Char" )
 DllCall( "WideCharToMultiByte", Int,0,Int,0, UInt,&U,UInt,Sz, Str,A,UInt,Sz, Int,0,Int,0)
 StringSplit, Part, A, #
 ParentIdPrefixCheck := SubStr( Part3,1,InStr(Part3,"&",0,0)-1 )
 IfEqual,A_OSVersion,WIN_VISTA, Return,ParentIdPrefixCheck
 Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR,1,0
  { Device := A_LoopRegName
    Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR\%Device%,1,0
     { Serial := A_LoopRegName
       RegRead, PIPrefix, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR\%Device%\%Serial%
              , ParentIdPrefix
       If ( PIPrefix = ParentIdPrefixCheck )
         Return, SubStr( Serial,1,InStr(Serial,"&",0,0)-1 )
     }
}}

USBD_GetDeviceID( Serial ) {
 Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USB\,1,0
  { Device := A_LoopRegName
    Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USB\%Device%,1,0
    If ( A_LoopRegName=Serial )
      Return DllCall( "CharUpperA", Str, "USB\" Device "\" Serial, Str )
}}

DeviceEject( DeviceID ) {
 hMod := DllCall( "LoadLibrary", Str,"SetupAPI.dll" ), VarSetCapacity(VE,255,0)
 If ! DllCall( "SetupAPI\CM_Locate_DevNodeA", UIntP,DI, Str,DeviceID, Int,0 )
 If ! DllCall( "SetupAPI\CM_Get_DevNode_Status", UIntP,STS, UIntP,PR, UInt,DI, Int,0)
 DllCall( "SetupAPI\CM_Request_Device_EjectA", UInt,DI, UIntP,VT, Str,VE, UInt,255, Int,0)
 DllCall( "FreeLibrary", UInt,hMod )
}

Eject(DRV, DontCheck:=0, DontEject:=0) {  ;       By SKAN on CT91/D29R @ goo.gl/pUUGRt  
Local  STORAGE_DEVICE_NUMBER, IOCTL_STORAGE_GET_DEVICE_NUMBER:=0x2D1080    
Local  OPEN_EXISTING:=3, hVol:=0, sPHDRV:="", qStr:="", qEnum:= "", nDID:=0, nVT:=1
Local  AMT := "[Removable Media][External hard disk media]", dObj:={}, VT, VAR 

  hVol := DllCall("CreateFile", "Str","\\.\" . (DRV:=SubStr(DRV,1,1) . ":"), "UInt",0
                    ,"UInt",0, "Ptr",0,"UInt",OPEN_EXISTING, "UInt",0, "Ptr",0, "Ptr")
  If (hVol = -1 )
   {
     ErrorLevel := FileExist(DRV) ? "Mapped/substitute drive" : "Invalid drive letter"
     Return dObj
   }

  VarSetcapacity(STORAGE_DEVICE_NUMBER,12,0)
  DllCall("DeviceIoControl", "Ptr",hVol, "UInt",IOCTL_STORAGE_GET_DEVICE_NUMBER
         ,"Int",0, "Int",0, "Ptr",&STORAGE_DEVICE_NUMBER, "Int",12, "PtrP",0, "Ptr",0)  
  DllCall( "CloseHandle", "Ptr",hVol )
      
  sPHDRV := "\\\\.\\PHYSICALDRIVE" . NumGet(STORAGE_DEVICE_NUMBER,4,"UInt")
  qStr   := "Select * from Win32_DiskDrive where DeviceID='$$$'"
  qEnum  := ComObjGet("winmgmts:").ExecQuery(StrReplace(qStr,"$$$",sPHDRV))._NewEnum()
  qEnum[dObj]

  If ( DontEject )
    {
      ErrorLevel := ""
      Return dObj 
    }

  If ! ( DontCheck || InStr(AMT, "[" . dObj.MediaType . "]", True) )
    {
      ErrorLevel := (dObj.MediaType=="Fixed hard disk media" 
                 ?  "Media is a Fixed hard disk" : "Media type Unknown")
      Return dObj 
    }

  If ! ( DllCall("GetModuleHandle", "Str","SetupAPI.dll", "Ptr") ) 
    {
         DllCall("LoadLibrary", "Str","SetupAPI.dll", "Ptr")
    }

  DllCall("SetupAPI\CM_Locate_DevNode", "PtrP",nDID, "Str",dObj.PNPDeviceID, "Int",0)
  DllCall("SetupAPI\CM_Get_Parent", "PtrP",nDID, "UInt",nDID, "Int",0)

  VarSetCapacity(VAR,520,0)
  DllCall("SetupAPI\CM_Request_Device_Eject"
          ,"UInt",nDID, "PtrP",nVT,"Str",VAR, "Int",260, "Int",0)

  ErrorLevel := ( nVT=0 ? 0 : ["PNP_VetoTypeUnknown`nThe specified operation was reje"
  . "cted for an unknown reason.","PNP_VetoLegacyDevice`nThe device does not support "
  . "the specified PnP operation.","PNP_VetoPendingClose`nThe specified operation can"
  . "not be completed because of a pending close operation.","PNP_VetoWindowsApp`nA M"
  . "icrosoft Win32 application vetoed the specified operation.","PNP_VetoWindowsServ"
  . "ice`nA Win32 service vetoed the specified operation.","PNP_VetoOutstandingOpen`n"
  . "The requested operation was rejected because of outstanding open handles.","PNP_"
  . "VetoDevice`nThe device supports the specified operation, but the device rejected"
  . " the operation.","PNP_VetoDriver`nThe driver supports the specified operation, b"
  . "ut the driver rejected the operation.","PNP_VetoIllegalDeviceRequest`nThe device"
  . " does not support the specified operation.","PNP_VetoInsufficientPower`nThere is"
  . " insufficient power to perform the requested operation.","PNP_VetoNonDisableable"
  . "`nThe device cannot be disabled.","PNP_VetoLegacyDriver`nThe driver does not sup"
  . "port the specified PnP operation.","PNP_VetoInsufficientRights`nThe caller has i"
  . "nsufficient privileges to complete the operation.","PNP_VetoAlreadyRemoved`nThe "
  . "device has been already removed"][nVT] )

Return dObj                    
}