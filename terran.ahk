; v1.0

#IfWinActive Brood War
#InstallKeybdHook
#InstallMouseHook
#SingleInstance

Global basicbuilding :=1 , advbuilding:=1
    basicbuildingKey:=["s","b","r","e"]
    advbuildingKey:=["f","s","a"]
f1::
{
  gosub MakeWorkerUnit
}
return
f2::
{
    gosub CycleAllUnits
}
return

;==================================
; pylon /depot /lord
;==================================
f9::
{
  global basicbuilding

    key :=basicbuildingKey[basicbuilding]
    debug(basicbuilding " " basicbuildingKey[basicbuilding]" " key)
    send {Esc}
    WaitGameCycle(2)
    send b
    WaitGameCycle(2)    
    send %key%    
    toggleBasic()
}
return

toggleBasic(){
    basicbuilding:=basicbuilding+1
    if(basicbuilding > 3) {
      basicbuilding:=1
    }
}
return

toggleadv(){
    advbuilding:=advbuilding+1
    if(advbuilding > 3) {
      advbuilding:=1
    }
}
return

;==================================
; build gate / barracks / hatch
;==================================
f10::
{
  global advbuilding

    key :=advbuildingKey[advbuilding]
    debug(advbuilding " " advbuildingKey[advbuilding]" " key)
    send {Esc}
    WaitGameCycle(2)
    send v
    WaitGameCycle(2)    
    send %key%    
    toggleadv()
}
return



debug(message){
OutputDebug, sc1 %message%
}
return

WaitGameCycle(NumberOfCycles=1)
{
  Global GAME_CYCLE
  GAME_CYCLE := 50
  Loop %NumberOfCycles%
  {
    Sleep %GAME_CYCLE%
  }
}
return

CycleAllUnits:
{
    Loop 10{
        send %A_index%
        WaitGameCycle(2)
        gosub MakeWorkerUnit 
        WaitGameCycle(2)
    }
}

MakeWorkerUnit:
{
  send s
  send m
  send t
  send w
}
return