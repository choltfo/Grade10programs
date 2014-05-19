% Character creator

type player : record
    Level : int
    name : string
    
    Money : int
    
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

function displayStatEdit (title : string,mx,my,mz,lmb,x,y,m:int, var c: int, c1:int) : int
    for i : 0 .. c-1
        %Draw.FillBox((x+100)+(((i mod 20)+1)*10),y-10*ceil((i) / 20),(x+100)+(((i mod 20)+1)*10)-8,y-10*ceil((i)/ 20)+8,c1)
        Draw.FillBox((x+100)+(((i mod 20))*10),y-10*(i div 20),(x+100)+(((i mod 20))*10)+8,y-10*(i div 20)+8,c1)
    end for
    for i : 0 .. m-1
        Draw.Box((x+100)+(((i mod 20))*10)+1,y-10*(i div 20)+1,(x+100)+(((i mod 20))*10)+7,y-10*(i div 20)+7,grey)
        Draw.Box((x+100)+(((i mod 20))*10),y-10*(i div 20),(x+100)+(((i mod 20))*10)+8,y-10*(i div 20)+8,black)
    end for
    Draw.Text(title,x-50,y,toolTitle,black)
    if (momentaryButtonBox(mx,my,mz,lmb,x+80,y,x+88,y+8,red,black)) then
        c-=1
    end if
    if (momentaryButtonBox(mx,my,mz,lmb,x+90,y,x+98,y+8,red,black)) then
        c+=1
    end if
    if (c < 0) then
        c := 0
    end if
    if (c > m) then
        c := m
    end if
    if (ceil(m / 20) = 0) then
        result 1
    else
        result ceil(m / 20)
    end if
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

        var i : int := 0
        
        newPlayer.name := "THIS IS A NAME, BITCH!"
        i+=displayStatEdit("Level",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Level,green)
        i+=displayStatEdit("HP",x,y,z,lmb,50,maxy-100-(10*i),newPlayer.maxHP,newPlayer.HP,green)
        newPlayer.maxHP := 2*newPlayer.Strength + 3*newPlayer.Level
        i+=displayStatEdit("Consciousness",x,y,z,lmb,50,maxy-100-(10*i),newPlayer.maxCons,newPlayer.Cons,green)
        newPlayer.maxCons := 2*newPlayer.Willpower + 3* newPlayer.Level
        
        i+=displayStatEdit("Strength",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Strength,green)
        i+=displayStatEdit("Agility",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Agility,green)
        i+=displayStatEdit("Finesse",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Finesse,green)
        i+=displayStatEdit("Awareness",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Awareness,green)
        i+=displayStatEdit("Intelligence",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Intelligence,green)
        i+=displayStatEdit("Presence",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Presence,green)
        i+=displayStatEdit("Willpower",x,y,z,lmb,50,maxy-100-(10*i),20,newPlayer.Willpower,green)
        View.Update()
        cls()
        lmb := z
    end loop
    
end createNewPlayer

View.Set("offscreenonly")
var a := createNewPlayer
