% A physics game!
include "Vectors.t"

var start,finish,startVel : Vector2

start.x := 20
start.y := 20
startVel.x := 5
startVel.y := 5

type Ball : record
    Location : Vector2
    Velocity : Vector2
    Force : Vector2
    Alive : boolean
    Mass : real
end record

var ball : Ball
ball.Location := start
ball.Velocity := startVel
ball.Force := zero
ball.Alive := true
ball.Mass := 10


type accelZone : record
    x : int
    y : int
    Force : Vector2
end record

type gravWell : record
    x : int
    y : int
    Pull : real
    maxDist : real
end record

var accels : array 1..2 of accelZone
var wells : array 1..2 of gravWell

accels(1).x := 10
accels(1).y := 6
accels(1).Force.x := 10
accels(1).Force.y := 0

accels(2).x := 20
accels(2).y := 20
accels(2).Force.x := -16.65
accels(2).Force.y := 0

wells(1).x := 12
wells(1).y := 10
wells(1).Pull := 1
wells(1).maxDist := 100

wells(2).x := 20
wells(2).y := 20
wells(2).Pull := 1
wells(2).maxDist := 50

proc drawLevel(boxSize,x,y : int)
    
    
    for i : 1..upper(wells)
        Draw.FillOval(floor((wells(i).x+0.5)*boxSize),floor((wells(i).y+0.5)*boxSize),round(wells(i).maxDist),round(wells(i).maxDist),41)
        Draw.FillOval(floor((wells(i).x+0.5)*boxSize),floor((wells(i).y+0.5)*boxSize),5,5,black)
    end for
    
    for i : 1..upper(accels)
        Draw.FillBox(accels(i).x*boxSize-1,accels(i).y*boxSize-1,(accels(i).x-1)*boxSize,(accels(i).y-1)*boxSize,grey)
    end for
    
    for i : 1..x
        for o : 1..y
            Draw.Box(o*boxSize,maxy-(i*boxSize),(o-1)*boxSize,maxy-((i-1)*boxSize),black)
        end for
    end for
    
    
    
    Draw.FillOval(round(ball.Location.x),round(ball.Location.y),5,5,blue)
end drawLevel

function PTInRect (x,y,x1,y1,x2,y2:real):boolean
    if x1 > x2 then
    %put "x1 > x2, retrying"
        result PTInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
    %put "y1 > y2, retrying"
        result PTInRect(x,y,x1,y2,x2,y1)
    end if
    result x > x1 and x < x2 and y > y1 and y < y2
end PTInRect

View.Set("offscreenonly")

const lvlWidth := 20
const lvlHeight := 20
const lvlSize := 20

loop
    if (not ball.Alive) then
        ball.Location := start
        ball.Velocity := startVel
        ball.Force := zero
        ball.Alive := true
    else
        for i : 1..upper(accels)
            if (PTInRect(ball.Location.x,ball.Location.y,accels(i).x*lvlSize-1,accels(i).y*lvlSize-1,(accels(i).x-1)*lvlSize,(accels(i).y-1)*lvlSize)) then
                
                ball.Force := Vector.Add(ball.Force,accels(i).Force)
                
            end if
        end for
        
        for i : 1..upper(wells)
            var sqDist := Vector.getSqrMag(Vector.Subtract(ball.Location,Vector.AddDir(zero,wells(i).x*lvlSize,wells(i).y*lvlSize)))
            if (sqDist < wells(i).maxDist**2) then
                put "In range"
                % Doesn't work, but worth holding on to.
                %ball.Force := Vector.Add(Vector.Multiply(Vector.Subtract(ball.Location,Vector.AddDir(zero,wells(i).x*lvlSize,wells(i).y*lvlSize)),(wells(i).maxDist**2-sqDist)/wells(i).maxDist**2 * wells(i).Pull),ball.Force)
                
            end if
        end for
            
        ball.Velocity := Vector.Add(ball.Velocity,Vector.Divide(ball.Force,ball.Mass))
        ball.Location := Vector.Add(ball.Location,ball.Velocity)

        if (not PTInRect(ball.Location.x,ball.Location.y,0,0,lvlWidth*lvlSize,lvlHeight*lvlSize)) then
            ball.Alive := false
        end if
    end if

    ball.Force := zero

    drawLevel(lvlSize,lvlWidth,lvlHeight)

    View.Update
    cls
    Time.DelaySinceLast(15)
end loop







