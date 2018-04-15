;Set variables:
         VK96=0
         VK97=1
         VK98=2
         VK99=3
         VK100=4
         VK101=5
         VK102=6
         VK103=7
         VK104=8
         VK105=9
         VK13=Enter
         VK8=BackSpace
         VK106=`*
         VK107=`+
         VK109=`-
         VK111=`/
         VK110=`.
         VK33=PgUp
         VK34=PgDn
         VK35=End
         VK36=Home
         VK37=Left
         VK38=Up
         VK39=Right
         VK40=Down
         VK45=Insert
         VK46=Delete
         VK144=NumLock
         configuration=
         keycodes:="8 13 96 97 98 99 100 101 102 103 104 105 106 107 109 110 111" ;NumLock On virtual key codes
         ;keycodes.=" 144" ;NumLock, does not work on my PC

Loop{
   InputBox, keypad, Keypad name, Enter the name of keypad #%A_Index%.`nLeave blank to continue.
   If (keypad=""){
      keypad:=A_Index-1
      Break
   }
   keypad%A_Index%:=keypad
   If (ErrorLevel)
      ExitApp
}

InputBox, exe, AutoHotkey executable location, Enter the location of the AutoHotkey executable file,,,,,,,, C:\Program Files (x86)\AutoHotkey\AutoHotkey.exe
If (ErrorLevel)
   ExitApp
   
InputBox, script, AutoHotkey script location, Enter the location of the HIDmacros_send.ahk file,,,,,,,, C:\Program Files (x86)\AutoHotkey\Domotica\HIDmacros_send.ahk
If (ErrorLevel)
   ExitApp

MsgBox, 291, NumLock off state, Should numlock off keys be included?
IfMsgBox Yes
   keycodes.=" 33 34 35 36 37 38 39 40 45 46" ;NumLock Off virtual key codes
Else IfMsgBox Cancel
   ExitApp
   
Loop,%keypad%
{
   keypadname:=keypad%A_Index%
   keypadnumber:=A_Index
   
   Loop, Parse, keycodes, %A_Space%
   {
      keyname:=VK%A_LoopField%
      configuration.="    <Macro>`r`n"
      configuration.="      <Device>" . keypadname . "</Device>`r`n"
      configuration.="      <Name>" . keypadname . ": " . keyname . "</Name>`r`n"
      configuration.="      <KeyCode>" . A_LoopField . "</KeyCode>`r`n"
      configuration.="      <Direction>down</Direction>`r`n"
      configuration.="      <Action>CMD</Action>`r`n"
      configuration.="      <Sequence></Sequence>`r`n"
      configuration.="      <SCEvent></SCEvent>`r`n"
      configuration.="      <XPLCommand></XPLCommand>`r`n"
      configuration.="      <ScriptSource></ScriptSource>`r`n"
      configuration.="      <SCText>0</SCText>`r`n"
      configuration.="      <SCParams></SCParams>`r`n"
      configuration.="      <Command>""" . exe . """ """ . script . """ " . keypadnumber . " " . A_LoopField . "</Command>`r`n"
      configuration.="    </Macro>`r`n"
   }   
}

Clipboard:=configuration
MsgBox, 64, Configuration completed, The HidMacros key configuration has been copied to the clipboard, 5