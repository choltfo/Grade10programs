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

var toolTitle : int := Font.New("Arial:9")

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
        Draw.FillBox((x+100)+(i*10),y,(x+100)+(i*10)-8,y+8,c1)
    end for
    for i : 1 .. m
        Draw.Box((x+99)+(i*10),y+1,(x+100)+(i*10)-7,y+7,gray)
        Draw.Box((x+100)+(i*10),y,(x+100)+(i*10)-8,y+8,black)
    end for
    Draw.Text("Agility",x,y,toolTitle,black)
    if (momentaryButtonBox(mx,my,mz,lmb,x+80,y,x+88,y+8,red,black)) then
        c-=1
        if (c < 0) then
            c := 0
        end if
    end if
    if (momentaryButtonBox(mx,my,mz,lmb,x+90,y,x+98,y+8,red,black)) then
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
        
        newPlayer.Level := displayStatEdit(x,y,z,lmb,50,maxy-100,20,newPlayer.Level,green)
        newPlayer.Level := displayStatEdit(x,y,z,lmb,50,maxy-110,20,newPlayer.Level,green)
        newPlayer.name := "THIS IS A NAME, BITCH!"
        
        newPlayer.HP := displayStatEdit(x,y,z,lmb,50,maxy-120,20,newPlayer.HP,green)
        newPlayer.maxHP := displayStatEdit(x,y,z,lmb,50,maxy-130,20,newPlayer.maxHP,green)
        newPlayer.Cons := displayStatEdit(x,y,z,lmb,50,maxy-140,20,newPlayer.Cons,green)
        newPlayer.maxCons := displayStatEdit(x,y,z,lmb,50,maxy-150,20,newPlayer.maxCons,green)
    
        newPlayer.Strength := displayStatEdit(x,y,z,lmb,50,maxy-160,20,newPlayer.Strength,green)
        newPlayer.Agility := displayStatEdit(x,y,z,lmb,50,maxy-170,20,newPlayer.Agility,green)
        newPlayer.Finesse := displayStatEdit(x,y,z,lmb,50,maxy-180,20,newPlayer.Finesse,green)
        newPlayer.Awareness := displayStatEdit(x,y,z,lmb,50,maxy-190,20,newPlayer.Awareness,green)
        newPlayer.Intelligence := displayStatEdit(x,y,z,lmb,50,maxy-200,20,newPlayer.Intelligence,green)
        newPlayer.Presence := displayStatEdit(x,y,z,lmb,50,maxy-210,20,newPlayer.Presence,green)
        newPlayer.Willpower := displayStatEdit(x,y,z,lmb,50,maxy-220,20,newPlayer.Level,green)
        View.Update()
        cls
        lmb := z
    end loop
    
end createNewPlayer

View.Set("offscreenonly")

var a := createNewPlayer