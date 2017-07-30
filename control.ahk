#IfWinActive Brood War
#InstallKeybdHook
#InstallMouseHook
#SingleInstance

global lastAction:=a_tickcount
global currentHotkey:=0
global currentBuild:=1
global builds:=[["Depot",["b","s"]],["Turret",["b","t"]],["Bunker",["b","u"]],["Barricks",["b","b"]],["Acadamy",["b","a"]],["Refinery",["b","r"]],["Factory",["v","f"]],["Engineering Bay",["b","e"]],["Starport",["v","s"]],["Science Facility",["v","b"]],["Armory",["v","a"]],["Command Center",["b","c"]]]
now:=a_tickcount
global units:=[["scv","s",9,False,now,0],["marine","m",10,False,now,0],["tank","t",45,false,now,0],["wraith","w",30,false,now,0]]


Gui, GUI_Overlay:New, +AlwaysOnTop +hwndGUI_Overlay_hwnd
Gui, Font, s10 q4, Segoe UI Bold
Gui, Add, Text, w200  vTEXT_Timer cYellow,
Gui, Add, Text, w200  vTEXT_Timer2 cYellow,
Gui, Add, Text, w200  vTEXT_Timer3 cYellow,
Gui, Color, 000000
WinSet, Transparent, 220
Winset, AlwaysOnTop, on
Gui, Show, Hide, Overlay   
Gui, GUI_Overlay:Show, NoActivate, starcraft 


UpdateWindow()

SetTimer, AutoBuild, 5000

AutoBuild:
    waitTime:=3
    if((a_tickcount - lastAction)/1000> waitTime){
        global units
        for index, unit in units  {  
            if(unit[4]=True){
                diff:= (a_tickcount - unit[5])/1000
                if(diff > unit[3]){
                    if((a_tickcount - lastAction)/1000> waitTime){
                        out("auto build "unit[1] "after time period "unit[3])
                        unit[5]:=a_tickcount
                        unit[6] += 1
                        trainForAllHotkeys(index)
                        UpdateWindow()
                    }
                }
            }
        }
    }
return

*::
    lastAction:=a_tickcount
return

~lbutton::
    lastAction:=a_tickcount
return

~rbutton::
    lastAction:=a_tickcount
return

a::
    train(1)
    return
+a::
    train(1)
    enableAutoTraining(1)
    return
!a::
    disableAutoTraining(1)
    return 

s::
    train(2)
    return
+s::
    train(2)
    enableAutoTraining(2)
    return
!s::
    disableAutoTraining(2)
    return 
q::
    callbuild()
return 

callBuild()
{
    building:=builds[currentBuild]     
    out("building " . building[1])
    send {Esc}
    for index, value in building[2]{
        out("sending " . value)
        sleep 50
        send %value%    
    }
    return
}

trainForAllHotkeys(index){
    Loop 10{
        hotkey:=10-a_index
        out( "hotkey " . hotkey)
        send %hotkey%  
        sleep 50      
        train(index)
    }
    return
}
train(index){
    out("training " units[index][1])
    unit:=units[index][2] 
    send %unit% 
    sleep 100
    return
}

enableAutoTraining(index){
    units[index][4]:=True
    units[index][6]:=0
    UpdateWindow()
    return
}

disableAutoTraining(index){
    units[index][4]:=False
    UpdateWindow()
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
    send ^%currentHotkey%
    UpdateWindow()
}
return 

PrevHotkey(){    
    currentHotkey:=currentHotkey-1
    if(currentHotkey<0){
        currentHotkey:=9
    }
    send %currentHotkey%
    out("PrevHotkey " currentHotkey)
    UpdateWindow()
}
return

NextHotkey(){    
    currentHotkey:=currentHotkey+1
    if(currentHotkey>9){
        currentHotkey:=0
    }
    send %currentHotkey%
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

    auto:=""
    global units
    for index, unit in units  {  
        if(unit[4]=True){
             auto .= unit[1] . " "  . unit[6] . " | "
         }
    }
    
    GuiControl, GUI_Overlay:, TEXT_Timer3,AutoTraining:%auto%
   return
}