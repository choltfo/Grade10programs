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

var accels : flexible array 1..0 of accelZone
var wells : flexible array 1..0 of gravWell

/*
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
*/

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

proc loadLevel (map : string)
    
    new accels, 0
    new wells, 0
    
    % generate map from walls and vector points
    var stream : int
    var mapFile : flexible array 1..0 of string
    
    open : stream, map, get
    %open : stream, "map1.map", get
    
    cls
    put "Loading map..."
    
    loop
        exit when eof(stream)
        new mapFile, upper(mapFile) + 1
        get : stream, mapFile(upper(mapFile)) : *
    end loop
    
    put upper(mapFile)
    
    for i : 1..upper(mapFile)
        put i," : ",mapFile(i)
    end for
    
    var i : int := 1
    loop
        put i
        if (mapFile(i) = "Accel:") then
            new accels, upper(accels)+1
            i:=i+1
            accels(upper(accels)).x := strint(mapFile(i))
            i:=i+1
            accels(upper(accels)).y := strint(mapFile(i))
            i:=i+1
            accels(upper(accels)).Force.x := strint(mapFile(i))
            i:=i+1
            accels(upper(accels)).Force.y := strint(mapFile(i))
        elsif (mapFile(i) = "Well:") then
            new wells, upper(wells)+1
            i:=i+1
            wells(upper(wells)).x := strint(mapFile(i))
            i:=i+1
            wells(upper(wells)).y := strint(mapFile(i))
            i:=i+1
            wells(upper(wells)).Pull := strint(mapFile(i))
            i:=i+1
            wells(upper(wells)).maxDist := strint(mapFile(i))
        elsif (mapFile(i) = "Start:") then
            i:=i+1
            start.x := strint(mapFile(i))
            i:=i+1
            start.y := strint(mapFile(i))
            i:=i+1
            startVel.x := strint(mapFile(i))
            i:=i+1
            startVel.y := strint(mapFile(i))
        elsif (mapFile(i) = "Finish:") then
            i:=i+1
            finish.x := strint(mapFile(i))
            i:=i+1
            finish.y := strint(mapFile(i))
        end if
        i:=i+1
        exit when i >= upper(mapFile)
    end loop
    
    close : stream
    
end loadLevel

function playLevel () : int
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
            if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 + 5**2 then
                ball.Alive := false
                levelComplete := true
            end if
            
            
            drawVectorThickLine(ball.Location,Vector.Subtract(ball.Location,Vector.Multiply(ball.Velocity,deltaT)),5,black)
            
            %ball.Velocity := Vector.Multiply(ball.Velocity,0.999999)
            
            if (mb = 1 and lmb = 0) then
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
        if (levelComplete) then
            result Tries
        end if
        
    end loop
end playLevel

type highscore : record
    player : string
    score : int
end record

var highscores : array 1..10 of highscore

for i : 1..upper(highscores)
    highscores(i).player := "NULL"
    highscores(i).score  := 1000
end for

proc sortHS
    var sortedHighscores : array 1..10 of highscore
    
    % We want them descending.
    
    for i : 1..upper(highscores)
        var lowestInd : int := 1
        
        for o : 1..upper(highscores)-(i-1)
            if (highscores(o).score < highscores(lowestInd).score) then
                lowestInd := o
            end if
        end for
        sortedHighscores (i) := highscores(lowestInd)
        for o : lowestInd..upper(highscores)-i
            highscores(o) := highscores(o+1)
        end for
    end for
    
    highscores := sortedHighscores
end sortHS

proc addHS (player : string, score : int)
    sortHS
    if (score < highscores(upper(highscores)).score) then
        highscores(upper(highscores)).score := score
        highscores(upper(highscores)).player := player
    end if
    sortHS
end addHS

function checkHS (score : int) : boolean
    sortHS
    result (score < highscores(upper(highscores)).score)
end checkHS

proc putHS
    for i : 1..upper(highscores)
        put i," : ",highscores(i).player," : ",highscores(i).score
    end for
end putHS

proc saveHS
    var stream : int
    open : stream, "highscores.txt", write
    
    for i : 1..upper(highscores)
        write : stream, highscores(i)
    end for
    close : stream
end saveHS

proc loadHS
    var stream : int
    open : stream, "highscores.txt", read
    
    for i : 1..upper(highscores)
        read : stream, highscores(i)
    end for
    close : stream
end loadHS


loadHS
var score : int := 0

loadLevel("map1.map")
score += playLevel ()
/*loadLevel("map2.map")
score += playLevel ()
loadLevel("map3.map")
score += playLevel ()*/
cls
if (checkHS(score)) then
    put "Congrats! You have a high score! Please enter your name!"
    View.Update()
    var name : string := ""
    get name
    addHS(name,score)
end if

putHS
saveHS





