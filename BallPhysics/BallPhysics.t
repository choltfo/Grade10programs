% A physics game!
include "Vectors.t"
include "Particles.t"

View.Set("Graphics")

var start,finish,startVel : Vector2
var p : pointer to ParticleSystem

var parForTheCourse : int := 1

new ParticleSystem, p

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


function getString (prompt:string,x,y,font,c,bgc : int) : string
    var chars : array char of boolean
    var formerChars : array char of boolean
    var output : string := ""
    Draw.FillBox(x-2,y-2,maxx,y+45,bgc)
    Font.Draw("-> " + output,x,y,font,c)
    Font.Draw(prompt,x,y+25,font,c)
    Input.KeyDown (chars)
    formerChars := chars
    View.Update()
    loop
        Input.KeyDown (chars)
        for i : 97 .. 122
            if (chars(chr(i)) and not formerChars(chr(i)) ) then
                if chars(cheat(char,180)) then
                    output += chr(i-32)
                else
                    output += chr(i)
                end if
                Draw.FillBox(x,y-1,maxx,y+22,bgc)
                Font.Draw("-> " + output,x,y,font,c)
                View.Update()
            end if
        end for
        if (chars(chr(32)) and not formerChars(chr(32)) ) then
            output += ' '
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + output,x,y,font,c)
            View.Update()
        end if
        
        
        if (chars(cheat(char,8)) and not formerChars(cheat(char,8)) ) then
            var newLine : string := ""
            for i : 1..length(output)-1
                newLine += output(i)
            end for
            output := newLine
            
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + output,x,y,font,c)
            View.Update()
        end if
        
        if (chars(cheat(char,10)) and not formerChars(cheat(char,10)) ) then
            View.Update()
            result output
        end if
        formerChars := chars
        View.Update()
    end loop
end getString

var f : int := Font.New("TimesNewRoman:12")
var f2 : int := Font.New("Arial:48")

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
            p -> InitAngular (accels(upper(accels)).x*lvlWidth,accels(upper(accels)).y*lvlHeight,10,500,grey,5,50,50)
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
            %p -> InitAngular (wells(upper(wells)).x*lvlWidth,wells(upper(wells)).y*lvlHeight,10,500,41,5,50,50)
        elsif (mapFile(i) = "Start:") then
            i:=i+1
            start.x := strint(mapFile(i))
            i:=i+1
            start.y := strint(mapFile(i))
            i:=i+1
            startVel.x := strint(mapFile(i))
            i:=i+1
            startVel.y := strint(mapFile(i))
            p -> InitAngular (start.x,start.y,10,500,green,5,50,50)
        elsif (mapFile(i) = "Finish:") then
            i:=i+1
            finish.x := strint(mapFile(i))
            i:=i+1
            finish.y := strint(mapFile(i))
            p -> InitAngular (finish.x,finish.x,10,500,red,5,50,50)
        elsif (mapFile(i) = "Par:") then
            i:=i+1
            parForTheCourse := strint(mapFile(i))
        end if
        i:=i+1
        exit when i >= upper(mapFile)
    end loop
    
    close : stream
    
end loadLevel

proc applyPhysics
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
                p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,blue,5,75,75)
            end if
            ball.Force := zero
end applyPhysics


function playLevel (map : string) : int
    loadLevel(map)
    var mx,my,mb,lmb := 0
    var Tries : int := 0
    var levelComplete : boolean := false
    ball.Alive := false
    loop
        Mouse.Where(mx,my,mb)
        if (not ball.Alive) then
            ball.Location := start
            ball.Velocity := startVel
            ball.Force := zero
            ball.Alive := true
            
        else
            
            applyPhysics

            % Have we won?
            if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 + 5**2 then
                ball.Alive := false
                levelComplete := true
                p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,41,5,50,50)
            end if
            
            
            drawVectorThickLine(ball.Location,Vector.Subtract(ball.Location,Vector.Multiply(ball.Velocity,deltaT)),5,black)
            
            %ball.Velocity := Vector.Multiply(ball.Velocity,0.999999)
            
            if (mb = 1 and lmb = 0) then
                %put "ZOINK!"
                for i : 1..upper(wells)
                    if (Math.Distance(wells(i).x*lvlSize,wells(i).y*lvlSize,mx,my) < 5) then
                        ball.Alive := false
                        p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,red,5,50,50)
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
                        p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,red,5,50,50)
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
        
        %put Tries
        
        %p -> InitAngular (100,100,10,100,red,5,100,150)
        
        p -> update()
        p -> draw()
        
        Font.Draw("Par  : "+intstr(parForTheCourse),maxx-220,maxy-50,f2,black)
        Font.Draw("Tries: "+intstr(Tries),maxx-220,maxy-100,f2,black)
        
        Draw.FillBox(10,maxy-10,40,maxy-40,red)
        Draw.Box(10,maxy-10,40,maxy-40,black)
        Draw.Box(11,maxy-11,39,maxy-39,darkgrey)
        Draw.Box(12,maxy-12,38,maxy-38,grey)
        if (PTInRect(mx,my,10,maxy-10,40,maxy-40) and mb = 1 and lmb = 0) then
            loadLevel(map)
            ball.Alive := false
            Tries := 0
        end if
        
        if not ball.Alive then
            Music.PlayFileReturn("Failure.mp3")
        end if
        
        View.Update
        
        cls
        
        Time.DelaySinceLast(round(deltaT*1000))
        lmb := mb
        if (levelComplete) then
            Music.PlayFileReturn("Success.mp3")
            result Tries - parForTheCourse
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
        if (i < 10) then
            put ' '..
        end if
        put '  '..
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

proc titleScreen (var mX,mY,mB,mLB : int)
    var hasWaited := false
    loop    % Title screen loop
        mLB := mB
        Mouse.Where(mX, mY, mB)
        Font.Draw("Marbles",round((maxx/2)-(Font.Width("Marbles",f2)/2)),maxy-100,f2,black)
        
        Font.Draw("The goal of the game:",round((maxx/2)-(Font.Width("The goal of the game:",f)/2)),maxy-140,f,black)
        Font.Draw("Steer the blue ball into the red circle",round((maxx/2)-(Font.Width("Steer the blue ball into the red circle",f)/2)),maxy-160,f,black)
        Font.Draw("Drag the other items around with the mouse",round((maxx/2)-(Font.Width("Drag the other items around with the mouse",f)/2)),maxy-180,f,black)
        
        if (not hasWaited) then
            View.Update()
            delay(2000)
            hasWaited := true
        end if
        
        
        
        
        %Draw.FillBox(round((maxx/2)-(Font.Width("Click to start!",f)/2))-5,195,round((maxx/2)+(Font.Width("Click to start!",f)/2))+5,215,blue)
        %Draw.Box(round((maxx/2)-(Font.Width("Click to start!",f)/2))-5,195,round((maxx/2)+(Font.Width("Click to start!",f)/2))+5,215,black)
        %Draw.Box(round((maxx/2)-(Font.Width("Click to start!",f)/2))-4,196,round((maxx/2)+(Font.Width("Click to start!",f)/2))+4,214,grey)
        Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",f)/2)),200,f,((round(Time.Elapsed() / 200)) mod 2)*black)
        
        if (mB = 1 and mLB = 0 and PTInRect(mX,mY,maxx,maxy,0,0)) then
            exit
        end if
        
        %((round(Time.Elapsed() / 200)) mod 2)*green
        
        mLB := mB
        View.Update()
        cls()
        delay(10)
    end loop
end titleScreen

proc tutorial(var mX,mY,mB,mLB : int)
    % The grey squares accelerate the ball in a direction.
    % The black balls with the orange circles have gravity.
    
    start.x := 100
    start.y := 200
    startVel.x := 500
    startVel.y := 0
    
    finish.x := 700
    finish.y := 200
    
    ball.Location.x := start.x
    ball.Location.y := start.y
    
    ball.Velocity.x := startVel.x
    ball.Velocity.y := startVel.y
    
    loop
        mLB := mB
        Mouse.Where(mX,mY,mB)
        drawLevel(20,40,15)
        if (not ball.Alive) then
            ball.Location := start
            ball.Velocity := startVel
            ball.Force := zero
            ball.Alive := true
        else
            applyPhysics
        end if
        
        p -> update()
        p -> draw()
        
        Font.Draw("The goal of the game:",round((maxx/2)-(Font.Width("The goal of the game:",f)/2)),maxy-140,f,black)
        Font.Draw("Steer the blue ball into the red circle",round((maxx/2)-(Font.Width("Steer the blue ball into the red circle",f)/2)),maxy-160,f,black)
        if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 + 5**2 then
            ball.Alive := false
            p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,41,5,50,50)
            Music.PlayFileReturn("Success.mp3")
        end if
        
        View.Update
        cls
        Time.DelaySinceLast(round(deltaT * 1000))
        exit when mLB = 0 and mB = 1
    end loop
    
    start.x := 100
    start.y := 200
    startVel.x := 500
    startVel.y := 100
    
    finish.x := 700
    finish.y := 200
    
    ball.Location.x := start.x
    ball.Location.y := start.y
    
    ball.Velocity.x := startVel.x
    ball.Velocity.y := startVel.y
    
    new accels, 1
    
    accels(1).x := 19
    accels(1).y := 13
    
    accels(1).Force.y := -50000000
    accels(1).Force.x := 0
    
    loop
        mLB := mB
        Mouse.Where(mX,mY,mB)
        drawLevel(20,40,15)
        if (not ball.Alive) then
            ball.Location := start
            ball.Velocity := startVel
            ball.Force := zero
            ball.Alive := true
        else
            applyPhysics
        end if
        
        p -> update()
        p -> draw()
        
        Font.Draw("The grey squares accelerate the ball in a consistent, but unknown manner.",round((maxx/2)-(Font.Width("The grey squares accelerate the ball in a consistent, but unknown manner.",f)/2)),maxy-140,f,black)
        if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 + 5**2 then
            ball.Alive := false
            p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,41,5,50,50)
            Music.PlayFileReturn("Success.mp3")
        end if
        
        View.Update
        cls
        Time.DelaySinceLast(round(deltaT * 1000))
        exit when mLB = 0 and mB = 1
    end loop
    
    start.x := 100
    start.y := 200
    startVel.x := 500
    startVel.y := 20
    
    finish.x := 700
    finish.y := 200
    
    ball.Location.x := start.x
    ball.Location.y := start.y
    
    ball.Velocity.x := startVel.x
    ball.Velocity.y := startVel.y
    
    new accels, 0
    new wells, 1
    
    wells(1).x := 32
    wells(1).y := 11
    
    wells(1).Pull := 10000
    wells(1).maxDist := 100
    
    loop
        mLB := mB
        Mouse.Where(mX,mY,mB)
        drawLevel(20,40,15)
        if (not ball.Alive) then
            ball.Location := start
            ball.Velocity := startVel
            ball.Force := zero
            ball.Alive := true
        else
            applyPhysics
        end if
        
        p -> update()
        p -> draw()
        
        Font.Draw("The black balls with orange rings pull the ball towards them with power equal to the inverse-square of their distance.",round((maxx/2)-(Font.Width("The black balls with orange rings pull the ball towards them with power equal to the inverse-square of their distance.",f)/2)),maxy-140,f,black)
        if (ball.Location.x - finish.x)**2 + (ball.Location.y - finish.y)**2 < 20**2 + 5**2 then
            ball.Alive := false
            p -> InitAngular (ball.Location.x,ball.Location.y,10,1000,41,5,50,50)
            Music.PlayFileReturn("Success.mp3")
        end if
        
        View.Update
        cls
        Time.DelaySinceLast(round(deltaT * 1000))
        exit when mLB = 0 and mB = 1
    end loop
    
    
end tutorial


proc Play
    var mX,mY,mB,mLB : int := 0
    titleScreen(mX,mY,mB,mLB)
    loadHS
    var score : int := 0
    var n : int := 1
    tutorial(mX,mY,mB,mLB)
    loop
        exit when not File.Exists("map"+intstr(n)+".map")
        score += playLevel ("map"+intstr(n)+".map")
        n+=1
    end loop
    cls
    
    if (checkHS(score)) then
        %put "Congrats! You have a high score! Please enter your name!"
        View.Update()
        var name : string := ""
        name := getString("You have a highscore! Please enter your name: ",100,100,f,black,white)
        addHS(name,score)
        cls
    end if

    putHS
    saveHS
    View.Update

    View.Update()
    delay(2000) 
    
    loop    % Title screen loop
        mLB := mB
        Mouse.Where(mX, mY, mB)
        
        Font.Draw("Click to Continue",round((maxx/2)-(Font.Width("Click to Continue",f)/2)),200,f,((round(Time.Elapsed() / 200)) mod 2)*black)
        View.Update
        if (mB = 1 and mLB = 0) then
            cls
            exit
        end if
    end loop
end Play

loop
    Play
end loop



