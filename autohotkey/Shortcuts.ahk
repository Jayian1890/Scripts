#Include tf.ahk

!1::
  SendRaw %clipboard%
return

!2::
  SendRaw b2netpass`%123
return
  
!3::
  Random("Clipboard","12")
  Send ^{v}
return

!4::
  SendRaw ADMIN
  Send {Tab}
  SendRaw ADMIN
  Send {Enter}
return

!5::
  Send {Tab 2}
  Send {s 2}
  Send {Tab}
  SendRaw ADMIN
  Send {Tab}
  Send ^{v}
  Send {Tab}
  Send {s}
  Send {Down 3}
  Send {Tab 5}
  Send {Enter}
return

!6::
SendRaw 23.229.61.254
Send {Tab}
SendRaw \ISOs\templates\centos6.6_IPFix_120GB.iso
Send {Tab}
SendRaw servermania
Send {Tab}
SendRaw ruQuma8ras6ewrub
Send {Tab}
Send {Enter}
return

!7::
SendRaw 23.229.61.254
Send {Tab}
SendRaw \ISOs\templates\centos6.7_1TB.iso
Send {Tab}
SendRaw servermania
Send {Tab}
SendRaw ruQuma8ras6ewrub
Send {Tab}
Send {Enter}
return

!8::
 Send root
 Send {Enter}
 Sleep, 1000
 SendRaw sm12345!
 Send {Enter}
 Sleep, 1000

 If InputBox(mainIP, "Main IP Address")
	Return
	
 If InputBox(gateway, "Gateway IP Address")
	Return
	
Send mii-tool eth1 && mii-tool eth0 {Enter}
Sleep, 1000
	
 If InputBox(device, "Network Device Name")
	Return
	
 Send rm -f /etc/sysconfig/network-scripts/ifcfg-%device%.bak {Enter}
 Send mv /etc/sysconfig/network-scripts/ifcfg-%device% /etc/sysconfig/network-scripts/ifcfg-%device%.bak {Enter}
 Sleep, 1000
 
 Send vi /etc/sysconfig/network-scripts/ifcfg-%device% {Enter}
 Sleep, 1000

 TF_Replace("template2.txt","%ipaddr%",mainIP)
 TF_ReplaceInLines("!template2_copy.txt","1","","%device%",device)
 TF_ReplaceInLines("!template2_copy.txt","6","","%gateway%",gateway)
 TF("template2_copy.txt", "Result")
 Result:=TF_ReadLines(Result,0)
 ;MsgBox % Result
 
 Send a
 Send %Result%
 Send {Esc} :wq {Enter}
 Sleep, 1000
 
 Send rm -f /etc/sysconfig/network.bak {Enter}
 Send mv /etc/sysconfig/network /etc/sysconfig/network.bak {Enter}
 Send vi /etc/sysconfig/network {Enter}
 Sleep, 1000
 Send a
 Send NETWORKING="yes" {Enter}
 Send GATEWAY="%gateway%" {Enter}
 Send GATEWAYDEV="%device%" {Enter}
 Send HOSTNAME="buf" {Enter}
 Send FORWARD_IPV4="yes"
 Send {Esc} :wq {Enter}
 Sleep, 1000
 
 Send rm -f /etc/resolv.conf.bak {Enter}
 Send mv /etc/resolv.conf /etc/resolv.conf.bak {Enter}
 Send vi /etc/resolv.conf {Enter}
 Sleep, 1000
 Send a
 Send nameserver 8.8.8.8
 Send {Esc} :wq {Enter}
 Sleep, 1000
 
 Send passwd
 Send {Enter}
 Sleep, 1000
 Random("password","12")
 SendRaw %password%
 Send {Enter}
 Sleep, 1000
 SendRaw %password%
 Send {Enter}
 Sleep, 1000
 
 Clipboard:= password
 Send service network restart && ping -c 5 google.com {Enter}
return
 
 TF_Replace("template.txt","%ipAddress%",mainIP)
 TF_ReplaceInLines("!template_copy.txt","15","","%password%",password)
 TF_ReplaceInLines("!template_copy.txt","11","","%label%",label)
 
 TF("template_copy.txt", "MyVar")
 MyVar:=TF_ReadLines(MyVar,0)
 ;MsgBox % MyVar
 
 Clipboard:= MyVar
return

!9::
Send root{Tab}%password%{Tab}{Tab}{Tab}%mainIP%{Tab}{Tab}{Tab}{Tab}{Enter}}
return

!0::
 If InputBox(mainIP, "Main IP Address")
	Return
	
 If InputBox(gateway, "Gateway IP Address")
	Return
	
 Send mii-tool eth1 && mii-tool eth0 {Enter}
 Sleep, 1000
	
 If InputBox(device, "Network Device Name")
	Return
	
 Send rm -f /etc/network/interfaces.bak {Enter}
 Send mv /etc/network/interfaces /etc/network/interfaces.bak {Enter}
 Sleep, 500
 
 Send vi /etc/network/interfaces {Enter}
 Sleep, 1000
 
 Send a
 Send auto %device% {Enter}
 Send iface %device% inet static {Enter}
 Send address %mainIP% {Enter}
 Send netmask 255.255.255.248 {Enter}
 Send gateway %gateway% {Enter}
 Send dns-nameservers 8.8.8.8 4.2.2.2
 Send {Esc} :wq {Enter}
 
 Send passwd
 Send {Enter}
 Sleep, 1000
 Random("password","12")
 SendRaw %password%
 Send {Enter}
 Sleep, 1000
 SendRaw %password%
 Send {Enter}
 Sleep, 1000
 
 Clipboard:= password

return

Random(VariableSelection, DigitSelection)
   {
   CharacterSelection = ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890%A_Space%
   Loop, %DigitSelection%
      {
      Random, Ran, 1, 63
      Loop, Parse, CharacterSelection
         {
         If A_Index <> %Ran%
            {
            Continue
            } 
         DigitSelection = %A_LoopField%
            {
            Break
            }
         }
      String =%String%,%DigitSelection%
      }
   Sort, String, Random D,
   StringReplace, %VariableSelection%, String, `,,,All
   }
Return

InputBox(ByRef OutputVar="", Title="", Text="", Default="`n", Keystrokes="") ;http://www.autohotkey.com/forum/viewtopic.php?p=467756
{
	Static KeysToSend, PID, HWND, PreviousEntries
	If (A_ThisLabel <> "InputBox") {
		If HWND
			SetTimer, InputBox, Off
		If !PID {
			Process, Exist
			PID := ErrorLevel
		}
		If Keystrokes
			KeysToSend := Keystrokes
		WinGet, List, List, ahk_class #32770 ahk_pid %PID%
		HWND = `n0x0`n
		Loop %List%
			HWND .= List%A_Index% "`n"
		If InStr(Default, "`n") and (UsePrev := True)
			StringReplace, Default, Default, `n, , All
		If (Title = "")
			Title := SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".") - 1) ": Input"
		SetTimer, InputBox, 20
		StringReplace, Text, Text, `n, `n, UseErrorLevel
		InputBox, CapturedOutput, %Title%, %Text%, , , Text = "" ? 100 : 116 + ErrorLevel * 18 , , , , , % UsePrev and (t := InStr(PreviousEntries, "`r" (w := (u := InStr(Title, " - ")) ? SubStr(Title, 1, u - 1) : Title) "`n")) ? v := SubStr(PreviousEntries, t += (u ? u - 1 : StrLen(Title)) + 2, InStr(PreviousEntries "`r", "`r", 0, t) - t) : Default
		If !(Result := ErrorLevel) {
			OutputVar := CapturedOutput
			If t
				StringReplace, PreviousEntries, PreviousEntries, `r%w%`n%v%, `r%w%`n%OutputVar%
			Else
				PreviousEntries .= "`r" w "`n" OutputVar
		}
		Return Result
	} Else If InStr(HWND, "`n") {
		If !InStr(HWND, "`n" (TempHWND := WinExist("ahk_class #32770 ahk_pid " PID)) "`n") {
			WinDelay := A_WinDelay
			SetWinDelay, -1
			WinSet, AlwaysOnTop, On, % "ahk_id " (HWND := TempHWND)
			WinActivate, ahk_id %HWND%
			If KeysToSend {
				WinWaitActive, ahk_id %HWND%, , 1
				If !ErrorLevel
					SendInput, %KeysToSend%
				KeysToSend =
			}
			SetTimer, InputBox, -400
			SetWinDelay, %WinDelay%
		}
	} Else If WinExist("ahk_id " HWND) {
		WinSet, AlwaysOnTop, On, ahk_id %HWND%
		SetTimer, InputBox, -400
	} Else
		HWND =
	Return
	InputBox:
	Return InputBox()
}