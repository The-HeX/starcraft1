#IfWinActive Brood War
#InstallKeybdHook
#InstallMouseHook
#SingleInstance, force

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
Gui, Add, Text, x140 y20 w100 h30   vTEXT_Timer2 cGray,
Gui, Add, Text, x140 y60 w100 h30   vTEXT_Timer3 cGray,
Gui, Add, Text, x140 y100 w100 h30   vTEXT_Timer cGray,
Gui, Add, Text, x140 y140 w100 h30   vTEXT_Timer4 cGray,
Gui, Add, Text, x140 y180 w100 h30   vTEXT_Timer5 cGray,
Gui, Add, Text, x140 y220 w100 h30   vTEXT_Timer6 cGray,
Gui, Add, Text, x140 y260 w100 h30   vTEXT_Timer7 cGray,
Gui, Add, Text, x140 y300 w100 h30   vTEXT_Timer8 cGray,
Gui, Add, Text, x140 y340 w100 h30   vTEXT_Timer9 cGray,
Gui, Add, Text, x140 y380 w100 h30   vTEXT_Timer10 cGray,
Gui, Add, Text, x140 y420 w100 h30   vTEXT_Timer11 cGray,
Gui, Add, Text, x140 y460 w100 h30   vTEXT_Timer12 cGray,
Gui, Add, Text, x140 y500 w100 h30   vTEXT_Timer13 cGray,

Gui, Add, Text, x20 y20 w100 h30 cGray, Quick Build: 
Gui, Add, Text, x20 y60 w100 h30  cGray, Auto Build:
Gui, Add, Text, x20 y100 w100 h30 cGray, Selected:
Gui, Add, Text, x20 y140 w100 h30 cGray,  Hotkey 0 =>
Gui, Add, Text, x20 y180 w100 h30 cGray,  Hotkey 1 => 
Gui, Add, Text, x20 y220 w100 h30 cGray,  Hotkey 2 =>
Gui, Add, Text, x20 y260 w100 h30 cGray,  Hotkey 3 =>
Gui, Add, Text, x20 y300 w100 h30 cGray,  Hotkey 4 =>
Gui, Add, Text, x20 y340 w100 h30 cGray,  Hotkey 5 => 
Gui, Add, Text, x20 y380 w100 h30  cGray, Hotkey 6 =>  
Gui, Add, Text, x20 y420 w100 h30  cGray, Hotkey 7 => 
Gui, Add, Text, x20 y460 w100 h30  cGray, Hotkey 8 => 
Gui, Add, Text, x20 y500 w100 h30  cGray, Hotkey 9 =>

Gui, Color, 000000
WinSet, Transparent, 220
Winset, AlwaysOnTop, on
Gui, Show, Hide, Overlay   
Gui, GUI_Overlay:Show, NoActivate, starcraft 

gosub reset

SetTimer, AutoBuild, 1000

+::
    autoBuild:=true
    UpdateWindow()
    return
-::
    autoBuild:=false
    UpdateWindow()
    return 
q::
    callbuild()
    return 

`:: 
    SetCurrentHotkey()
    return

tab::
    NextHotkey()
    return

+tab::
    PrevHotkey()
    return

^z::
    gosub reset
    return 



AutoBuild:
if(autobuild=true){
    waitTime:=4
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
    
                        ;Building Name      ,key sequence
    global builds:= [    ["Depot"           ,["b","s"]]
                        ,["Turret"          ,["b","t"]]
                        ,["Bunker"          ,["b","u"]]
                        ,["Barracks"        ,["b","b"]]
                        ,["Acadamy"         ,["b","a"]]
                        ,["Refinery"        ,["b","r"]]
                        ,["Factory"         ,["v","f"]]
                        ,["Engineering Bay" ,["b","e"]]
                        ,["Starport"        ,["v","s"]]
                        ,["Science Facility",["v","b"]]
                        ,["Armory"          ,["v","a"]]
                        ,["Command Center"  ,["b","c"]]]
    
    now:=a_tickcount
    
    ; type , key sequence , frequency(seconds) , autoTrainEnabled , lastAutoTrainTime , numberAutoTrained , hotkeysToTrain
    global UNIT_TYPE=1
    global units:=[      ["scv"             ,"s",9     ,False,now,0,[],"Command Center"]
                        ,["marine"          ,"m",9     ,False,now,0,[],"Barracks"]
                        ,["tank"            ,"t",20     ,false,now,0,[],"Factory"]
                        ,["wraith"          ,"w",20     ,false,now,0,[],"Starport"]
                        ,["Medic"           ,"c",90     ,false,now,0,[],"Barracks"]
                        ,["Ghost"           ,"g",50     ,false,now,0,[],"Barracks"]
                        ,["Scienve Vessel"  ,"v",360     ,false,now,0,[],"Starport"]
                        ,["battle cruiser"  ,"b",60     ,false,now,0,[],"Starport"]]
    
                        ; Assigned  ,Building Name      ,autobuild
    global hotkeys:=[    [false     ,""                 ,false] ;0
                        ,[false     ,""                 ,false] ;1
                        ,[false     ,""                 ,false] ;2
                        ,[false     ,""                 ,false] ;3
                        ,[false     ,""                 ,false] ;4
                        ,[false     ,""                 ,false] ;5
                        ,[false     ,""                 ,false] ;6 
                        ,[false     ,""                 ,false] ;7
                        ,[false     ,""                 ,false] ;8
                        ,[false     ,""                 ,false]] ;9

                         ;Building Name     , upgrade keys
    global upgrades:= [  ["Machine Shop"    ,["s","c"]]
                        ,["Engineering Bay" ,["w","a"]]
                        ,["Control Tower"   ,["c","a"]]
                        ,["Armory"          ,["w","p","s","h"]]
                        ,["Acadamy"         ,["u","r","d"]]
                        ,["Science"         ,["e","i","t"]]
                        ,["Covert Ops"      ,["c","o","l","m"]
                        ,["physics lab"     ,["y","c"]]] ] 
    
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
    sleep 500
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
    GuiControl, GUI_Overlay:, TEXT_Timer2,  %building%
    Gui, Font, cYellow Bold, Verdana
    GuiControl, Font, TEXT_Timer2

    auto:=autobuild    
    GuiControl, GUI_Overlay:,  TEXT_Timer3 , %auto% 
    
    if(autobuild=true){
        Gui, Font, cYellow Bold, Verdana
        GuiControl, Font, TEXT_Timer3
    }
    
    GuiControl, GUI_Overlay:, TEXT_Timer, %currentHotkey%
    hotkey:=hotkeys[1][2]
    GuiControl, GUI_Overlay:, TEXT_Timer4, %hotkey%
    hotkey:=hotkeys[2][2]
    GuiControl, GUI_Overlay:, TEXT_Timer5, %hotkey%
    hotkey:=hotkeys[3][2]
    GuiControl, GUI_Overlay:, TEXT_Timer6, %hotkey%
    hotkey:=hotkeys[4][2]
    GuiControl, GUI_Overlay:, TEXT_Timer7, %hotkey%
   hotkey:=hotkeys[5][2]
    GuiControl, GUI_Overlay:, TEXT_Timer8, %hotkey%
   hotkey:=hotkeys[6][2]
    GuiControl, GUI_Overlay:, TEXT_Timer9, %hotkey%
   hotkey:=hotkeys[7][2]
    GuiControl, GUI_Overlay:, TEXT_Timer10,  %hotkey%
   hotkey:=hotkeys[8][2]
    GuiControl, GUI_Overlay:, TEXT_Timer11,  %hotkey%
   hotkey:=hotkeys[9][2]
    GuiControl, GUI_Overlay:, TEXT_Timer12,  %hotkey%
   hotkey:=hotkeys[10][2]
    GuiControl, GUI_Overlay:, TEXT_Timer13,  %hotkey%
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