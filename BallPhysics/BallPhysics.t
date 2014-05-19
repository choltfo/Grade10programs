% A physics game!
include "Vectors.t"

View.Set("Graphics")

var start,finish,startVel : Vector2

start.x := 20
start.y := 20
startVel.x := 200
startVel.y := 200

finish.x := 200
finish.y := 200

var deltaT : real := 0.001

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

accels(1).x := 5
accels(1).y := 5
accels(1).Force.x := 100000000
accels(1).Force.y := 0

accels(2).x := 20
accels(2).y := 20
accels(2).Force.x := 100
accels(2).Force.y := 0

% The big one
wells(1).x := 13
wells(1).y := 10
wells(1).Pull := 10000
wells(1).maxDist := 100

wells(2).x := 16
wells(2).y := 10
wells(2).Pull := 10000
wells(2).maxDist := 100

proc drawLevel(boxSize,x,y : int)
    
    
    for i : 1..upper(wells)
        Draw.Oval(floor((wells(i).x)*boxSize),floor((wells(i).y)*boxSize),round(wells(i).maxDist),round(wells(i).maxDist),41)
        Draw.FillOval(floor((wells(i).x)*boxSize),floor((wells(i).y)*boxSize),5,5,black)
    end for
    
    for i : 1..upper(accels)
        Draw.FillBox(accels(i).x*boxSize-1,accels(i).y*boxSize-1,(accels(i).x-1)*boxSize,(accels(i).y-1)*boxSize,grey)
    end for
    
    for i : 1..x
        for o : 1..y
            Draw.Box(i*boxSize,(o*boxSize),(i-1)*boxSize,((o-1)*boxSize),black)
        end for
    end for
    
    Draw.FillOval(round(start.x),round(start.y),5,5,green)
    Draw.FillOval(round(finish.x),round(finish.y),5,5,red)
    Draw.Oval(round(finish.x),round(finish.y),20,20,red)
    
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

View.Set("Graphics:800;600,offscreenonly,nobuttonbar")

const lvlWidth := 40
const lvlHeight := 30
const lvlSize := 20

var mx,my,mb,lmb := 0
var Tries : int := 0
var levelComplete : boolean := false
loop
    Mouse.Where(mx,my,mb)
    if (not ball.Alive) then
        ball.Location := start
        ball.Velocity := startVel
        ball.Force := zero
        ball.Alive := true
    else
        for i : 1..upper(accels)
            if (PTInRect(ball.Location.x,ball.Location.y,accels(i).x*lvlSize-1,accels(i).y*lvlSize-1,(accels(i).x-1)*lvlSize,(accels(i).y-1)*lvlSize)) then
                
                ball.Force := Vector.Add(ball.Force,Vector.Multiply(accels(i).Force,deltaT))
                
            end if
        end for
        
        for i : 1..upper(wells)
            var dist := sqrt(Vector.getSqrMag(Vector.Subtract(ball.Location,Vector.AddDir(zero,wells(i).x*lvlSize,wells(i).y*lvlSize))))
            if (dist < wells(i).maxDist) then
                %put "In range"
                % Doesn't work, but worth holding on to.
                %ball.Force := Vector.Add(Vector.Multiply(Vector.Subtract(ball.Location,Vector.AddDir(zero,wells(i).x*lvlSize,wells(i).y*lvlSize)),(wells(i).maxDist**2-sqDist)/wells(i).maxDist**2 * wells(i).Pull),ball.Force)
                
                var impartedForce := Vector.Multiply(Vector.Normalize(Vector.Subtract(ball.Location,Vector.AddDir(zero,wells(i).x*lvlSize,wells(i).y*lvlSize))),(wells(i).Pull*(dist-wells(i).maxDist)/dist))
                
                ball.Force := Vector.Add(ball.Force,impartedForce)
                
            end if
        end for
        
        ball.Velocity := Vector.Add(ball.Velocity,Vector.Multiply(Vector.Divide(ball.Force,ball.Mass),deltaT))
        ball.Location := Vector.Add(ball.Location,Vector.Multiply(ball.Velocity,deltaT))

        if (not PTInRect(ball.Location.x,ball.Location.y,0,0,lvlWidth*lvlSize,lvlHeight*lvlSize)) then
            ball.Alive := false
        end if
        
        % Have we won?
        if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 then
            ball.Alive := false
            levelComplete := true
        end if
        
        
        drawVectorThickLine(ball.Location,Vector.Subtract(ball.Location,Vector.Multiply(ball.Velocity,deltaT)),5,black)
        
        %ball.Velocity := Vector.Multiply(ball.Velocity,0.999999)
        
        if (mb = 1 and lmb = 0) then
            ball.Alive := false
            %put "ZOINK!"
            for i : 1..upper(wells)
                if (Math.Distance(wells(i).x*lvlSize,wells(i).y*lvlSize,mx,my) < 5) then
                    ball.Alive := false
                    loop
                        Mouse.Where(mx,my,mb)
                        
                        wells(i).x := round(mx/lvlSize)
                        wells(i).y := round(my/lvlSize)
                        
                        cls
                        drawLevel(lvlSize,lvlWidth,lvlHeight)
                        View.Update
                        exit when mb = 0 and lmb = 1
                        lmb := mb
                    end loop
                    Tries += 1
                end if
            end for
        end if
        
        if (mb = 1 and lmb = 0) then
            %put "ZOINK!"
            for i : 1..upper(accels)
                if (PTInRect(mx,my,accels(i).x*lvlSize-1,accels(i).y*lvlSize-1,(accels(i).x-1)*lvlSize,(accels(i).y-1)*lvlSize)) then
                    ball.Alive := false
                    loop
                        Mouse.Where(mx,my,mb)
                        
                        accels(i).x := ceil(mx/lvlSize)
                        accels(i).y := ceil(my/lvlSize)
                        
                        cls
                        drawLevel(lvlSize,lvlWidth,lvlHeight)
                        View.Update
                        exit when mb = 0 and lmb = 1
                        lmb := mb
                    end loop
                    Tries += 1
                end if
            end for
        end if
        
    end if

    ball.Force := zero

    drawLevel(lvlSize,lvlWidth,lvlHeight)
    
    put Tries
    
    View.Update
    
    cls
    
    Time.DelaySinceLast(round(deltaT*1000))
    lmb := mb
end loop







