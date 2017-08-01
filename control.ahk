;removed caps to toggle build
;%A_MyDocuments%
;state object to track assigned hotkeys
;documented unit and hotkey fields
#IfWinActive Brood War
#InstallKeybdHook
#InstallMouseHook
#SingleInstance

global maxHotkey:=0
global lastAction:=a_tickcount
global lastBuild:=a_tickcount
global currentHotkey:=0
global currentBuild:=1
global builds:=[["Depot",["b","s"]],["Turret",["b","t"]],["Bunker",["b","u"]],["Barricks",["b","b"]],["Acadamy",["b","a"]],["Refinery",["b","r"]],["Factory",["v","f"]],["Engineering Bay",["b","e"]],["Starport",["v","s"]],["Science Facility",["v","b"]],["Armory",["v","a"]],["Command Center",["b","c"]]]
now:=a_tickcount
; type , keytosend , frequency(seconds) , autoTrainEnabled , lastAutoTrainTime , numberAutoTrained , hotkeysToTrain
global units:=[["scv","s",10,False,now,0,[]],["marine","m",10,False,now,0,[]],["tank","t",45,false,now,0,[]],["wraith","w",30,false,now,0,[]]]
; hotkey Assigned,type,autobuild
global hotkeys:=[[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false]]

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

SetTimer, AutoBuild, 6000

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
    if ((a_tickcount-lastBuild) < 1000){
        NextBuild()
    } 
    building:=builds[currentBuild]     
    out("building " . building[1])
    sendkey( "{Esc}" )
    for index, value in building[2]{        
        sendkey(value)
    }
    lastBuild:=a_tickcount
    return
}

trainForAllHotkeys(index){    
        unit:=units[index]
        for index, hotkey in unit[7]{
            out( "building " . unit[1] " on hotkey " . hotkey)
            sendkey(hotkey)            
            train(index)
        }    
    return
}
train(index){
    out("training " units[index][1])
    unit:=units[index][2] 
    sendkey(unit)
    return
}

enableAutoTraining(index){
    units[index][4]:=True
    units[index][6]:=0
    units[index][7].Push(currentHotkey)
    hotkey[currentHotkey][3]:=true
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
return

tab::
NextHotkey()
return

+tab::
PrevHotkey()
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
    currentHotkey+=1
    if(currentHotkey> maxHotkey){
        maxHotkey:=currentHotkey
    }
    out("SetCurrentHotkey " currentHotkey)
    send ^%currentHotkey%
    send +{PrintScreen}
    hotkey[currentHotkey][1]:=True
    RunWait, parse.exe "results.txt", Min
    FileRead, result, results.txt
    hotkey[currentHotkey][2]:=result
    UpdateWindow()
}
return 

PrevHotkey(){    
    currentHotkey:=currentHotkey-1
    if(currentHotkey<0){
        currentHotkey:=maxHotkey
    }
    sendkey( currentHotkey)
    UpdateWindow()
}
return

NextHotkey(){    
    currentHotkey:=currentHotkey+1
    if(currentHotkey>9 or currentHotkey>maxHotkey){
        currentHotkey:=0
    }
    sendkey( currentHotkey )
    out("NextHotkey " currentHotkey)
    UpdateWindow()
}
return

ViewHotkey(){
    out("ViewHotkey")
    sendkey( %currentHotkey%)
    sendkey( %currentHotkey%)
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
    hotkeysAssigned:=""
    for index, hotkey in hotkeys{
        if(hotkey[1]=True){
            hotkeysAssigned.= index . 
        }
    }
    GuiControl, GUI_Overlay:, TEXT_Timer4,Hotkeys:%hotkeysAssigned%
   return
}

sendkey(key){
    if(IfWinActive "Brood War"){
        out("sending key " . key)
        send %key%
        sleep 100
    }else{
        out("cannot send " . key)
    }
}