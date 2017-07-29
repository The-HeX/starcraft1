global currentHotkey:=0



  Gui, GUI_Overlay:New, +AlwaysOnTop +hwndGUI_Overlay_hwnd
    Gui, Font, s10 q4, Segoe UI Bold
    Gui, Add, Text, w200  vTEXT_Timer cYellow,
    Gui, Add, Text, w200  vTEXT_Timer2 cYellow,
    Gui, Color, 000000
    WinSet, Transparent, 220
    Winset, AlwaysOnTop, on
    Gui, Show, Hide, Overlay   
    Gui, GUI_Overlay:Show, NoActivate, starcraft 1.18.6.1655


UpdateWindow()
`:: 
SetCurrentHotkey()
NextHotkey()
return

tab::
NextHotkey()
return

+tab::
PrevHotkey()
return

SetCurrentHotkey()
{
    out("SetCurrentHotkey " currentHotkey)
    send {cntl} + %currentHotkey%
    UpdateWindow()
}
return 

PrevHotkey(){
    
    currentHotkey:=currentHotkey-1
    if(currentHotkey<0){
        currentHotkey:=9
    }
    out("PrevHotkey " currentHotkey)
    UpdateWindow()
}
return

NextHotkey(){
    
    currentHotkey:=currentHotkey+1
    if(currentHotkey>9){
        currentHotkey:=0
    }
    out("NextHotkey " currentHotkey)
    UpdateWindow()
}
return

ViewHotkey(){
    out("ViewHotkey")
    send %currentHotkey%
    send %currentHotkey%
}
return


Out(message){
    outputdebug sc1 control " " %message%
}
return




UpdateWindow(){    
    GuiControl, GUI_Overlay:, TEXT_Timer,CurrentHotkey: %currentHotkey%
    GuiControl, GUI_Overlay:, TEXT_Timer2,AutoBuilding: 
    return
}