;removed caps to toggle build
;%A_MyDocuments%
;state object to track assigned hotkeys
;documented unit and hotkey fields
#IfWinActive Brood War
#InstallKeybdHook
#InstallMouseHook
#SingleInstance

global maxHotkey
global lastAction
global lastBuild
global currentHotkey
global currentBuild
global builds
global now
global units
global hotkeys
global AutoBuild

Gui, GUI_Overlay:New, +AlwaysOnTop +hwndGUI_Overlay_hwnd
Gui, Font, s10 q4, Segoe UI Bold
Gui, Add, Text, w200  vTEXT_Timer cYellow,
Gui, Add, Text, w200  vTEXT_Timer2 cYellow,
Gui, Add, Text, w200  vTEXT_Timer3 cYellow,
Gui, Add, Text, w200  vTEXT_Timer4 cYellow,
Gui, Add, Text, w200  vTEXT_Timer5 cYellow,
Gui, Add, Text, w200  vTEXT_Timer6 cYellow,
Gui, Add, Text, w200  vTEXT_Timer7 cYellow,
Gui, Add, Text, w200  vTEXT_Timer8 cYellow,
Gui, Add, Text, w200  vTEXT_Timer9 cYellow,
Gui, Add, Text, w200  vTEXT_Timer10 cYellow,
Gui, Add, Text, w200  vTEXT_Timer11 cYellow,
Gui, Add, Text, w200  vTEXT_Timer12 cYellow,
Gui, Add, Text, w200  vTEXT_Timer13 cYellow,

Gui, Color, 000000
WinSet, Transparent, 220
Winset, AlwaysOnTop, on
Gui, Show, Hide, Overlay   
Gui, GUI_Overlay:Show, NoActivate, starcraft 

gosub reset

SetTimer, AutoBuild, 5000

AutoBuild:
if(autobuild=true){
    waitTime:=3
    if((a_tickcount - lastAction)/1000> waitTime){
     
        ; train units ============================================================
        global units
        for index, unit in units  {  
            diff:= (a_tickcount - unit[5])/1000
            if(diff > unit[3]){
                if((a_tickcount - lastAction)/1000> waitTime){
                    out("auto build "unit[1] " after time period "unit[3])
                    unit[5]:=a_tickcount
                    unit[6] += 1
                    trainForAllHotkeys(index)                   
                }
            }
        }

        ; ====================================================================
        ; upgrade buildings
         diff:= (a_tickcount - lastUpgrade)/1000
         ; try to upgrade every 45 seconds
         if(diff>45){  
            RunUpgrades()
         }

          UpdateWindow()
    }
}
return

reset:
    global autoBuild:=false
    global maxHotkey:=0
    global lastAction:=a_tickcount
    global lastBuild:=a_tickcount
    global currentHotkey:=0
    global currentBuild:=1
    global builds:=[["Depot",["b","s"]],["Turret",["b","t"]],["Bunker",["b","u"]],["Barracks",["b","b"]],["Acadamy",["b","a"]],["Refinery",["b","r"]],["Factory",["v","f"]],["Engineering Bay",["b","e"]],["Starport",["v","s"]],["Science Facility",["v","b"]],["Armory",["v","a"]],["Command Center",["b","c"]]]
    now:=a_tickcount
    ; type , keytosend , frequency(seconds) , autoTrainEnabled , lastAutoTrainTime , numberAutoTrained , hotkeysToTrain
    global units:=[["scv","s",10,False,now,0,[],"Command Center"],["marine","m",10,False,now,0,[],"Barracks"],["tank","t",45,false,now,0,[],"Factory"],["wraith","w",45,false,now,0,[],"Starport"],["Medic","c",70,false,now,0,[],"Barracks"]]
    ; hotkey Assigned,type,autobuild
    global hotkeys:=[[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false],[false,"",false]]
    global upgrades:=[["Machine Shop",["s","c"]],["Engineering Bay",["w","a"]],["Acadamy",["u","r","d"]],["Control Tower",["c","a"]],["Armory",["w","p","s","h"]],["Science",["e","i","t"]],["Covert Ops",["c","o","l","m"],["physics lab",["y","c"]]]] 
    global lastUpgrade:=a_tickcount
    UpdateWindow()
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
+::
    autoBuild:=true
    ;train(1)
    ;enableAutoTraining(1)
    return
-::
    autoBuild:=false
    ;disableAutoTraining(1)
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

^z::
    gosub reset
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

RunUpgrades(){
    for upgradeIndex, upgrade in upgrades{

        for hotkeyIndex, hotkey in hotkeys{
            actualIndex:=hotkeyIndex-1
            hotkeyName:=hotkey[2]
            unitBuildingName:=upgrade[1]
            If InStr( hotkeyName, unitBuildingName,false)
            {
                    out("upgrading  " upgrade[1] " " actualIndex " "  upgrade[1]  " == " hotkey[2] )                    
                    sendkey(actualIndex) 
                    for keyIndex, key in upgrade[2]{
                        sendkey(key)
                    }
            }
            else{
                   ;out("not auto upgrading " upgrade[1] " " index " "  unit[1]  " != " hotkey[2] )
            }            
        }    
    }
    return


}

trainForAllHotkeys(index){    
        unit:=units[index]
        for hotkeyIndex, hotkey in hotkeys{
            actualIndex:=hotkeyIndex-1
            hotkeyName:=hotkey[2]
            unitBuildingName:=unit[8]
            If InStr( hotkeyName, unitBuildingName,false)
            {
                    out("Auto building " unit[1] " " actualIndex " "  unit[8]  " == " hotkey[2] )                    
                    sendkey(actualIndex) 
                    train(index)
            }
            else{
                   ;out("not auto building " unit[1] " " index " "  unit[8]  " != " hotkey[2] )
            }            
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
    
    RunWait, parse.exe "results.txt", Hide
    sleep 250
    FileRead, result, results.txt
    Out("Identified hotkey " . result )
    hotkeys[currentHotkey+1][1]:= True
    hotkeys[currentHotkey+1][2]:= result
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
    outputdebug sc1 . %message%
}
return




UpdateWindow(){
    building:=builds[currentBuild][1]  
    GuiControl, GUI_Overlay:, TEXT_Timer,CurrentHotkey: %currentHotkey%
    GuiControl, GUI_Overlay:, TEXT_Timer2,SelectedBuilding: %currentBuild% %building%

    auto:=autobuild
    global units
    for index, unit in units  {  
        if(unit[4]=True){ 
             auto .= unit[1] . " "  . unit[6] . " | "
         }
    }
    
    GuiControl, GUI_Overlay:, TEXT_Timer3,AutoTraining: %auto%
    hotkeysAssigned:=""

    hotkey:=hotkeys[1][2]
    GuiControl, GUI_Overlay:, TEXT_Timer4,Hotkeys: 0 - %hotkey%
    hotkey:=hotkeys[2][2]
    GuiControl, GUI_Overlay:, TEXT_Timer5,Hotkeys: 1 - %hotkey%
    hotkey:=hotkeys[3][2]
    GuiControl, GUI_Overlay:, TEXT_Timer6,Hotkeys: 2 - %hotkey%
    hotkey:=hotkeys[4][2]
    GuiControl, GUI_Overlay:, TEXT_Timer7,Hotkeys: 3 - %hotkey%
   hotkey:=hotkeys[5][2]
    GuiControl, GUI_Overlay:, TEXT_Timer8,Hotkeys: 4 - %hotkey%
   hotkey:=hotkeys[6][2]
    GuiControl, GUI_Overlay:, TEXT_Timer9,Hotkeys: 5 - %hotkey%
   hotkey:=hotkeys[7][2]
    GuiControl, GUI_Overlay:, TEXT_Timer10,Hotkeys: 6 - %hotkey%
   hotkey:=hotkeys[8][2]
    GuiControl, GUI_Overlay:, TEXT_Timer11,Hotkeys: 7 - %hotkey%
   hotkey:=hotkeys[9][2]
    GuiControl, GUI_Overlay:, TEXT_Timer12,Hotkeys: 8 - %hotkey%
   hotkey:=hotkeys[10][2]
    GuiControl, GUI_Overlay:, TEXT_Timer13,Hotkeys: 9 - %hotkey%
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