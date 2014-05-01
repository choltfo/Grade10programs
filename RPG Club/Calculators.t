% RPG club calculator for random stuff

type rangedWeapon : record
    name : string
end record

type player : record
    Level : int
    name : string
    
    HP : int
    maxHP : int
    Cons : int
    maxCons : int
    
    Strength : int
    Agility : int
    Finesse : int
    Awareness : int
    Intelligence : int
    Presence : int
    Willpower : int
end record

function PTInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        put "x1 > x2, retrying"
        result PTInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        put "y1 > y2, retrying"
        result PTInRect(x,y,x1,y2,x2,y1)
    end if
    result x > x1 and x < x2 and y > y1 and y < y2
end PTInRect

function ButtonBox (x,y,button,x1,y1,x2,y2,c1,c2:int):boolean
    Draw.Box(x1,y1,x2,y2,c1)
    if button = 1 then
        if PTInRect (x,y,x1,y1,x2,y2) then
            Draw.FillBox(x1,y1,x2,y2,c2)
            Draw.Box(x1,y1,x2,y2,c1)
            result true
        end if
    end if
    result false
end ButtonBox

function momentaryButtonBox (x,y,button,lmb,x1,y1,x2,y2,c1,c2:int):boolean
    Draw.Box(x1,y1,x2,y2,c1)
    if button = 1 and lmb = 0 then
        if PTInRect (x,y,x1,y1,x2,y2) then
            Draw.FillBox(x1,y1,x2,y2,c2)
            Draw.Box(x1,y1,x2,y2,c1)
            result true
        end if
    end if
    result false
end momentaryButtonBox


function displayStatEdit (mx,my,mz,lmb,x,y,m:int, var c: int, c1:int) : int
    for i : 1 .. c
        Draw.FillBox((x+44)+(i*10),y,(x+44)+(i*10)-8,y+8,c1)
    end for
    for i : 1 .. m
        Draw.Box((x+43)+(i*10),y+1,(x+44)+(i*10)-7,y+7,gray)
        Draw.Box((x+44)+(i*10),y,(x+44)+(i*10)-8,y+8,black)
    end for
    if (momentaryButtonBox(mx,my,mz,lmb,x,y,x+8,y+8,red,black)) then
        c-=1
        if (c < 0) then
            c := 0
        end if
    end if
    if (momentaryButtonBox(mx,my,mz,lmb,x+10,y,x+18,y+8,red,black)) then
        c+=1
        if (c > 20) then
            c := 20
        end if
    end if
    result c
end displayStatEdit

function createNewPlayer : player
    var newPlayer : player
    newPlayer.Level := 0
    newPlayer.name := "THIS IS A NAME, BITCH!"
    
    newPlayer.HP := 20
    newPlayer.maxHP := 20
    newPlayer.Cons := 0
    newPlayer.maxCons := 0
    
    newPlayer.Strength := 0
    newPlayer.Agility := 0
    newPlayer.Finesse := 0
    newPlayer.Awareness := 0
    newPlayer.Intelligence := 0
    newPlayer.Presence := 0
    newPlayer.Willpower := 0
    var x,y,z,lmb : int := 0
    loop
        Mouse.Where(x,y,z)
        
        newPlayer.Level := displayStatEdit(x,y,z,lmb,50,60,20,newPlayer.Level,green)
        
        View.Update()
        cls
        lmb := z
    end loop
    
end createNewPlayer

View.Set("offscreenonly")

var a := createNewPlayer