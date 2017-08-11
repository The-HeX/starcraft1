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
global AutoUpgrade
global cheatSent

Gui, HeadsUpDisplay:New, +AlwaysOnTop +hwndGUI_Overlay_hwnd
Gui, Font, s10 q4 cGray, Segoe UI Bold
Gui, Add, Text, x20 y20 w100 h30  vlabel1 ,Build Selection:
Gui, Add, Text, x20 y60 w100 h30  vlabel2 ,Build
Gui, Add, Text, x20 y100 w100 h30 vlabel3 ,
Gui, Add, Text, x20 y140 w100 h30 vlabel4 , Hotkey 0 =>
Gui, Add, Text, x20 y180 w100 h30 vlabel5 , Hotkey 1 => 
Gui, Add, Text, x20 y220 w100 h30 vlabel6 , Hotkey 2 =>
Gui, Add, Text, x20 y260 w100 h30 vlabel7 , Hotkey 3 =>
Gui, Add, Text, x20 y300 w100 h30 vlabel8 , Hotkey 4 =>
Gui, Add, Text, x20 y340 w100 h30 vlabel9 , Hotkey 5 => 
Gui, Add, Text, x20 y380 w100 h30 vlabel10, Hotkey 6 =>  
Gui, Add, Text, x20 y420 w100 h30 vlabel11, Hotkey 7 => 
Gui, Add, Text, x20 y460 w100 h30 vlabel12, Hotkey 8 => 
Gui, Add, Text, x20 y500 w100 h30 vlabel13, Hotkey 9 =>

Gui, Add, Text, x140 y20 w100 h30   vTEXT1 ,
Gui, Add, Text, x140 y60 w100 h30   vTEXT2 ,Upgrade
Gui, Add, Text, x140 y100 w100 h30  vTEXT3 ,
Gui, Add, Text, x140 y140 w100 h30  vTEXT4 ,
Gui, Add, Text, x140 y180 w100 h30  vTEXT5 ,
Gui, Add, Text, x140 y220 w100 h30  vTEXT6 ,
Gui, Add, Text, x140 y260 w100 h30  vTEXT7 ,
Gui, Add, Text, x140 y300 w100 h30  vTEXT8 ,
Gui, Add, Text, x140 y340 w100 h30  vTEXT9 ,
Gui, Add, Text, x140 y380 w100 h30  vTEXT10,
Gui, Add, Text, x140 y420 w100 h30  vTEXT11,
Gui, Add, Text, x140 y460 w100 h30  vTEXT12,
Gui, Add, Text, x140 y500 w100 h30  vTEXT13,


Gui, Add, Text, x260 y20 w100 h30   vunitLabel1 ,
Gui, Add, Text, x260 y60 w100 h30   vunitLabel2 ,
Gui, Add, Text, x260 y100 w100 h30  vunitLabel3 ,
Gui, Add, Text, x260 y140 w100 h30  vunitLabel4 ,
Gui, Add, Text, x260 y180 w100 h30  vunitLabel5 ,
Gui, Add, Text, x260 y220 w100 h30  vunitLabel6 ,
Gui, Add, Text, x260 y260 w100 h30  vunitLabel7 ,
Gui, Add, Text, x260 y300 w100 h30  vunitLabel8 ,
Gui, Add, Text, x260 y340 w100 h30  vunitLabel9 ,
Gui, Add, Text, x260 y380 w100 h30  vunitLabel10,
Gui, Add, Text, x260 y420 w100 h30  vunitLabel11,
Gui, Add, Text, x260 y460 w100 h30  vunitLabel12,
Gui, Add, Text, x260 y500 w100 h30  vunitLabel13,


Gui, Color, 000000
WinSet, Transparent, 220
Winset, AlwaysOnTop, on
Gui, Show, Hide, Overlay   
Gui, HeadsUpDisplay:Show, NoActivate, starcraft 

gosub reset

SetTimer, AutoBuild, 1000

`:: 
    SetCurrentHotkey()
    return

w::
    if(AutoBuild=true){
        autoBuild:=False
    }else{
        autoBuild:=true
    }    
    UpdateWindow()
    return

e::
    if(AutoUpgrade=true){
        AutoUpgrade:=False
    }else{
        AutoUpgrade:=true
    }    
    UpdateWindow()
    return

q::
    callbuild()
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

s::
    units[1][4]:=!units[1][4]
    UpdateWindow()
    return 

t::
    units[2][4]:=!units[2][4]
    UpdateWindow()
    return 
c::
    units[3][4]:=!units[3][4]
    UpdateWindow()
    return 

*g::
    units[4][4]:=!units[4][4]
    UpdateWindow()
    return 

*m::
    units[5][4]:=!units[5][4]
    UpdateWindow()
    return 

*v::
    units[6][4]:=!units[6][4]
    UpdateWindow()
    return 

*h::
    units[7][4]:=!units[7][4]
    UpdateWindow()
    return 

*b::
    units[8][4]:=!units[8][4]
    UpdateWindow()
    return 
^c::
    if(cheatSent=false){
        send {enter}Show me the money{enter}medieval man{enter}modify the phase variance{enter}war aint what it used to be{enter}food for thought{enter}    
        cheatSent:=true
    }
    else{
        send {enter}Show me the money{enter}
    }
    
    return


AutoBuild:
if(AutoBuild=true){
    waitTime:=4
    if((a_tickcount - lastAction)/1000> waitTime){
     
        ; train units ============================================================
        global units
        for index, unit in units  {  
            if(unit[4]=true){
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
        }
          UpdateWindow()
    }
}
if(AutoUpgrade=true){
    waitTime:=4
    if((a_tickcount - lastAction)/1000> waitTime){
        ; ====================================================================
        ; upgrade buildings
         diff:= (a_tickcount - lastUpgrade)/1000
         ; try to upgrade every 45 seconds
         if(diff>60){  
            RunUpgrades()            
         }         
    }
}
return

reset:
    global AutoUpgrade:=false
    global autoBuild:=false
    global maxHotkey:=0
    global lastAction:=a_tickcount
    global lastBuild:=a_tickcount
    global currentHotkey:=1
    global currentBuild:=1
    global cheatSent:=false    
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
                        ,["Science Facility",["v","i"]]
                        ,["Armory"          ,["v","a"]]
                        ,["Command Center"  ,["b","c"]]]
    
    now:=a_tickcount
    
    ; type , key sequence , frequency(seconds) , autoTrainEnabled , lastAutoTrainTime , numberAutoTrained , hotkeysToTrain
    global UNIT_TYPE=1
    global units:=[      ["Scv"             ,"s",10    ,true,now,0,[],"Command Center"]
                        ,["Tank"            ,"t",20    ,true,now,0,[],"Factory"]
                        ,["mediC"           ,"c",90    ,true,now,0,[],"Barracks"]
                        ,["Ghost"           ,"g",60    ,true,now,0,[],"Barracks"]
                        ,["Marine"          ,"m",9     ,true,now,0,[],"Barracks"]
                        ,["scienve Vessel"  ,"v",360   ,true,now,0,[],"Starport"]
                        ,["wraitH"          ,"w",20    ,true,now,0,[],"Starport"]
                        ,["Battle cruiser"  ,"b",60    ,true,now,0,[],"Starport"]]
    
                        ; Assigned  ,Building Name  , autobuild , unit index to build (array of unit index) , upgrade index
    global hotkeys:=[    [false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;
                        ,[false     ,""                 ,false,[],[]] ;6
                        ,[false     ,""                 ,false,[],[]] ;7
                        ,[false     ,""                 ,false,[],[]] ;8
                        ,[false     ,""                 ,false,[],[]]] ;9

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

    currentHotkey+=1
    if(currentHotkey> maxHotkey){
        maxHotkey:=currentHotkey
    }
    updateHotkeyUnitMappings()
    dumpHotKeys()
}
return 

dumpHotKeys(){
    for hotkeyIndex, hotkey in hotkeys{
        out(hotkey[1] hotkey[2] hotkey[3] hotkey[4] hotkey[5])        
        
    }                        
}

updateHotkeyUnitMappings(){
        
        for hotkeyIndex, hotkey in hotkeys{
            actualIndex:=hotkeyIndex-1
            hotkeyName:=hotkey[2]
            if(strlen(hotkeyName)>0){
                for unitIndex, unit in units
                {
                    if(unit[4]=true){
                        unitBuildingName:=unit[8]
                        If InStr( hotkeyName, unitBuildingName,false)
                        {
                            hotkeys[actualIndex][4].Add(unitIndex)
                        }
                    }
                }
                for upgradeIndex, upgrade in upgrades
                {
                    upgradeBuildingName:=upgrades[1]
                    If InStr( hotkeyName, upgradeBuildingName,false)
                    {
                        hotkeys[actualIndex][5].Add(unitIndex)
                    }
                }                
            }
            else{
                hotkeys[actualIndex][4]:=[]
                hotkeys[actualIndex][5]:=[]
            }                        
        }    
    return
}

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
    global AutoUpgrade
    global autoBuild
    global currentHotkey
    global currentBuild

    building:=builds[currentBuild][1]

    GuiControl,HeadsUpDisplay:, TEXT1,  %building%    
    Gui, HeadsUpDisplay:Font, cYellow Bold, Verdana
    GuiControl, HeadsUpDisplay:Font, TEXT1
   
    Gui, HeadsUpDisplay:Font,% AutoBuild=TRUE ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label2

    Gui, HeadsUpDisplay:Font,% AutoUpgrade=TRUE ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, TEXT2
            
    hotkey:=hotkeys[1][2]
    GuiControl,HeadsUpDisplay: , TEXT4, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=0 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label4        
    GuiControl, HeadsUpDisplay:Font, TEXT4        
    

    hotkey:=hotkeys[2][2]
    GuiControl,HeadsUpDisplay: , TEXT5, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=1 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label5        
    GuiControl, HeadsUpDisplay:Font, TEXT5        


    hotkey:=hotkeys[3][2]
    GuiControl,HeadsUpDisplay: , TEXT6, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=2 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label6        
    GuiControl, HeadsUpDisplay:Font, TEXT6        

    hotkey:=hotkeys[4][2]
    GuiControl, HeadsUpDisplay:, TEXT7, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=3 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label7        
    GuiControl, HeadsUpDisplay:Font, TEXT7        

    hotkey:=hotkeys[5][2]
    GuiControl,HeadsUpDisplay: , TEXT8, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=4 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label8        
    GuiControl, HeadsUpDisplay:Font, TEXT8        
    
    hotkey:=hotkeys[6][2]
    GuiControl, HeadsUpDisplay:, TEXT9, %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=5 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label9        
    GuiControl, HeadsUpDisplay:Font, TEXT9        
    

    hotkey:=hotkeys[7][2]
    GuiControl,HeadsUpDisplay: , TEXT10,  %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=6 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label10        
    GuiControl, HeadsUpDisplay:Font, TEXT10        


    hotkey:=hotkeys[8][2]
    GuiControl,HeadsUpDisplay: , TEXT11,  %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=7 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label11        
    GuiControl, HeadsUpDisplay:Font, TEXT11        
    
    hotkey:=hotkeys[9][2]
    GuiControl,HeadsUpDisplay: , TEXT12,  %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=8 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label12 
    GuiControl, HeadsUpDisplay:Font, TEXT12        
    
    hotkey:=hotkeys[10][2]
    GuiControl, HeadsUpDisplay:, TEXT13,  %hotkey%
    Gui, HeadsUpDisplay:Font,% currentHotkey=9 ? "cYellow":"cGray"
    GuiControl, HeadsUpDisplay:Font, label13        
    GuiControl, HeadsUpDisplay:Font, TEXT13        

    for unitIndex, unit in units
    {
        name := unit[1]
        unitEnabled := unit[4]
        labelname := "unitLabel" . unitIndex
        Gui, HeadsUpDisplay:Font,% unitEnabled=true ? "cYellow":"cGray"
        GuiControl,HeadsUpDisplay: , %labelname%,  %name%       
        GuiControl, HeadsUpDisplay:Font, %labelname%        
    }
        
    ;Gui, HeadsUpDisplay:Hide 
    Gui, HeadsUpDisplay:Show, NoActivate, starcraft 
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