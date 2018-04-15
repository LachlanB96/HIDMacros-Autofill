SetNumlockState,AlwaysOn
HIDmacrosexe=%A_ScriptDir%\HID Macros\HIDMacros.exe
Menu,Tray,Icon,%HIDmacrosexe%
Gosub,CheckHIDmacros
SetTimer,CheckHIDmacros,60000
OnExit,ExitShow
OnMessage(0x4530, "InputMsg")

;Begin definition VK codes:
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
;End definition VK codes:


InputMsg(KeyboardID,KeyID) {
	;Critical
	Static Sequence1, Sequence2, Sequence3, TimeOfInput1, TimeOfInput2, TimeOfInput3
	KeyID:=VK%KeyID%
	TimeOfInputDifference:=TimeOfInput%KeyboardID%
	TimeOfInputDifference-=A_Now,Seconds
	TimeOfInputDifference*=-1
	TimeOfInput%KeyboardID%:=A_Now
	
	If (TimeOfInputDifference>20)
		Sequence%KeyboardID%=
		
	If (KeyID="BackSpace")
		Sequence%KeyboardID%=
	Else If (KeyID="Enter"){
		Sequence:=Sequence%KeyboardID%
		ProcessSequence(KeyboardID,Sequence)
		Sequence%KeyboardID%=
	}Else If (KeyID="-"){
		MsgBox,,Action,Lights ON,2
		SetTimer,LightsOff,-30000
	}Else If (KeyID="/"){
		MsgBox,,Action,Bell,2
	}Else
		Sequence%KeyboardID% .= KeyID
}

ProcessSequence(KeyboardID,Sequence){
	static TimeOfInvalid1, TimeOfInvalid2, TimeOfInvalid3
	TimeOfInvalidDifference:=TimeOfInvalid%KeyboardID%
	TimeOfInvalidDifference-=A_Now,Seconds
	TimeOfInvalidDifference*=-1
	StringSplit,Parameter,Sequence,.
	If (TimeOfInvalidDifference<20) AND (TimeOfInvalidDifference<>0){
		MsgBox,,,BLOCKED,2
		Exit
	}
	If ((KeyboardID=2) OR (KeyboardID=3)) AND (Parameter1=123)
		MsgBox,,Action,Alarm ARMED,2
	Else If (Parameter1=456)
		MsgBox,,Action,Alarm DISARMED,2
	Else If (Parameter1=147896)
		MsgBox,,Action,Door Open,2
	Else If (Parameter1="")
		MsgBox,,Action,Empty,2
	Else If (KeyboardID=2){
		TimeOfInvalid%KeyboardID%:=A_Now
		MsgBox,,,INVALID: %Parameter1%,2
	}
}

#IfWinNotExist,HID macros ahk_class THIDMacrosForm ;HID macros not running! Block all keypads keys
NumPad0::
NumPad1::
NumPad2::
NumPad3::
NumPad4::
NumPad5::
NumPad6::
NumPad7::
NumPad8::
NumPad9::
NumpadDot::
NumpadDiv::
NumpadMult::
NumpadAdd::
NumpadSub::
NumpadIns::
NumpadEnd::
NumpadDown::
NumpadPgDn::
NumpadLeft::
NumpadClear::
NumpadRight::
NumpadHome::
NumpadUp::
NumpadPgUp::
NumpadDel::
NumLock::
Return
NumpadEnter::Gosub,CheckHIDmacros

CheckHIDmacros:
	SetTitleMatchMode,2
	DetectHiddenWindows,Off
	if (A_TimeIdlePhysical > 60000) AND WinExist("HID macros ahk_class THIDMacrosForm")
		Gosub,HideHID
	DetectHiddenWindows,On
	If !WinExist("HID macros ahk_class THIDMacrosForm"){
		Gosub,ShowHID
		Gosub,HideHID
	}Else{
		Menu,Tray,Add,Hide HID macros,HideHID
		Menu,Tray,Default,Hide HID macros
	}
Return
ShowHID:
	DetectHiddenWindows,On
	If !WinExist("HID macros ahk_class THIDMacrosForm"){
		Run,%HIDmacrosexe%
		Menu,Tray,Add,Show HID macros,ShowHID
		WinWait,HID macros,,2
	}
	GroupAdd,HIDmacros,HID macros
	WinShow,ahk_group HIDmacros
	WinActivate,ahk_group HIDmacros
	Menu,Tray,Delete,Show HID macros
	Menu,Tray,Add,Hide HID macros,HideHID
	Menu,Tray,Default,Hide HID macros
Return
HideHID:
	GroupAdd,HIDmacros,HID macros
	WinHide,ahk_group HIDmacros
	Menu,Tray,Delete,Hide HID macros
	Menu,Tray,Add,Show HID macros,ShowHID
	Menu,Tray,Default,Show HID macros
Return
ExitShow:
	DetectHiddenWindows,Off
	If !WinExist("HID macros ahk_class THIDMacrosForm")
		Gosub,ShowHID
	ExitApp
Return


LightsOff:
	MsgBox,,Action,Lights OFF,2
Return
#IfWinActive