FormatTime, now, YYYYMMDDHH24MISS
global currentHotkey:=0
global currentBuild:=0
global builds:=[["Depot",["b","s"]] ,["Barricks",["b","b"]],["Factory"],["Starport"],["Turret"],["Bunker"],["Refinery"],["Acadamy"],["Engineering Bay"],["Armory"],["Science Facility"],["Command Center"]  ]
global units:=[["scv","s",30,False,now],["marine","m",30,False,now],["tank","t",45,false,now],["wraith","w",30,false,now]]

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

SetTimer, AutoBuild, 5000


AutoBuild:
    global units
    FormatTime now
    out("checking auto build " units.MaxIndex())
    Loop units.MaxIndex(){
        index:=%A_Index%
        out("checking " units[index][1])
        if(units[index][4]=True){
            out( "Autobuilding " units[index][1])
            diff:=now - units[index][5]
            out( "difference" diff)
            if(diff > unit[index][3]){
                out("auto build after time period")
            }
        }
    }
return


a::
    train(1,false)
    return

+a::
    train(1,True)
    return

train(index,auto){
    out("training " units[index][1])
    unit:=units[index][2] 
    send %unit% 
    if(auto=True){
        units[index][4]:=True
    }
    return
}


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

CapsLock::
NextBuild()
return

+CapsLock::
PrevBuild()
return

NextBuild(){
    currentBuild:=currentBuild+1
    if(currentBuild> builds.MaxIndex()){
        currentBuild:=1
    }
    out("NextBuild " currentBuild)
    UpdateWindow()
    return
}


PrevBuild(){
    currentBuild:=currentBuild-1
    if(currentBuild < 1){
        currentBuild:=builds.MaxIndex()
    }
    out("currentBuild " currentBuild)
    UpdateWindow()
}

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
    outputdebug sc1 " " %message%
}
return




UpdateWindow(){
    building:=builds[currentBuild][1]    
    GuiControl, GUI_Overlay:, TEXT_Timer,CurrentHotkey: %currentHotkey%
    GuiControl, GUI_Overlay:, TEXT_Timer2,SelectedBuilding:%currentBuild% %building%
    return
}