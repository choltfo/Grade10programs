% Random program

View.Set("offscreenonly")

var Font1 := Font.New ("Impact:72")
var Font2 := Font.New ("Arial:18")

var LastFrame : int := 0
var frameMillis : int := 10

var chars : array char of boolean
var formerChars : array char of boolean
Input.KeyDown(chars)
Input.KeyDown(formerChars)

type wall:record
posX : int
alive: boolean
end record

var walls : flexible array 0..-1 of wall
var pPos: array 1..100 of int

for i : 1..upper(pPos)
pPos (i) := 0
end for

var hasWaited := false
loop    % Title screen loop
Input.KeyDown(chars)
Font.Draw("Cannonbalt",round((maxx/2)-(Font.Width("Cannonbalt",Font1)/2)),maxy-100,Font1,black)
Font.Draw("Space to jump",round((maxx/2)-(Font.Width("Space to jump",Font2)/2)),maxy-200,Font2,black)

View.Update()
if (not hasWaited) then 
    delay(1000)
else
    Font.Draw("Space to start!",round((maxx/2)-(Font.Width("Space to start!",Font2)/2)),maxy-300,Font2,black*(round(Time.Elapsed() / 200)) mod 2)
end if

hasWaited := true

exit when chars(' ') and not formerChars(' ')
end loop

var x : int := 0
var y : int := 0
var yVel:real:=0

var floorHeight : int := 100

var Walls : flexible array 1..0 of int

var Health : real := 100

loop
Input.KeyDown(chars)

% Draw BG
Draw.FillBox(0,0,maxx,maxy,black)
Draw.FillBox(0,floorHeight,maxx,0,purple)

var grounded : boolean := y <= floorHeight

if (y <= floorHeight) then
    %y := floorHeight
    yVel := 0
end if

var jumping := chars(' ') and not formerChars(' ')



if (jumping and grounded) then
    y := floorHeight+1
    yVel := 20
else
    if (not grounded) then
        yVel := yVel - 1%1000*(frameMillis/1000)
        y += round(yVel)%floor(yVel*(frameMillis/1000))
    else
        yVel := 0
        y := floorHeight
    end if
end if

if (y < floorHeight) then y := floorHeight end if
    
    %delay (500)
    
    for i : 1..upper(walls)
        if walls(i).alive then
            Draw.ThickLine(walls(i).posX-x, floorHeight, walls(i).posX-x, floorHeight+50,5,purple)
            
            if (walls(i).posX-x -2.5 < 100 and walls(i).posX-x +2.5 > 100) then
                
                if (y < floorHeight+50) then
                    put "Crashed!"
                    Health -= 20
                    walls(i).alive := false
                end if
                
            end if
        end if
    end for
        
    if (Rand.Int(0,100) = 50) then
        new walls, upper(walls)+1
        walls(upper(walls)).posX := maxx+x+100
        walls(upper(walls)).alive := true
    end if
    
    x += floor(250*(frameMillis/1000))
    
    if (Health < 100) then
        Health += 1*(frameMillis/1000)
    end if
    if (Health > 100) then
        Health := 100
    end if
    
    
    % Upper is most recent!
    
    for i : 1..upper(pPos)-1
        Draw.FillOval(
        round(250*i*(frameMillis/1000)   ),
        pPos(i)+5,
        round(5*(i/upper(pPos))),
        round(5*(i/upper(pPos))),
        white)
    end for
        
    for i : 1..upper(pPos)-1
        pPos (i) := pPos (i+1)
    end for
        
    pPos(upper(pPos)) := y
    
    
    Draw.FillOval   (100,y+5,5,5,red)
    Draw.FillBox    (8,8,162,32,black)
    Draw.FillBox    (10,10,160,30,red)
    Draw.FillBox    (10,10,10+round((Health/100)*150),30,green)
    
    put "FT:    ",(LastFrame + frameMillis) - Time.Elapsed
    put "Y:     ",y
    put "yVel:  ",(yVel)
    put "x:     ",x
    
    if (Health <= 0) then
        % So, we just lost. Now to explode!
        
        
    end if
    
    View.Update()
    cls()
    
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
    formerChars := chars
    exit when Health <= 0
end loop
View.Update