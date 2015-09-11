!1::
  SendRaw %clipboard%
return
  
!2::
  Send #{r}
  Sleep 100
  SendRaw ping
  Send {Space}
  Send ^{v}
  Sleep 100
  Send {Enter}
return

!3::
  SendRaw b2netpass`%123
return

!4::
  SendRaw ADMIN
return