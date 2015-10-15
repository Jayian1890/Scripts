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
 Send sh /tmp/ipfix.sh
 Send {Enter}
 Sleep, 1000
 Send Y
 Send {Enter}
 Sleep, 1000
 Send eth1
 Send {Enter}
 Sleep, 1000
 Send 138.128.21.226
 Send {Enter}
 Sleep, 1000
 Send 138.128.21.225
 Send {Enter}
 Sleep, 1000
 Send 255.255.255.248
 Send {Enter}
 Sleep, 1000
 Send buf
 Send {Enter}
 Sleep, 1000
 Send service network restart;ping 8.8.8.8
 Send {Enter}
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