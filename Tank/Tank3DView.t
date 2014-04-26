% Let's drive a Tank!

include "Vector2.t"

View.Set("Graphics:600;400,offscreenonly")

var Font1 := Font.New ("Impact:72")
var Font2 := Font.New ("Arial:18")

var chars : array char of boolean
var formerChars : array char of boolean

var GUIBase : int := maxy - 50

var mX, mY, mB, mLB : int := 0      % Mouse vars
var hasWaited := false
loop    % Title screen loop
    Mouse.Where(mX, mY, mB)
    Font.Draw("The Tank Game",round((maxx/2)-(Font.Width("The Tank Game",Font1)/2)),GUIBase-100,Font1,black)
    Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),GUIBase-200,Font2,black)
    Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),GUIBase-220,Font2,black)
    Font.Draw("R to reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),GUIBase-240,Font2,black)
    
    View.Update()
    if (not hasWaited) then 
        delay(2000)
    else
        Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",Font2)/2)),GUIBase-300,Font2,black*(round(Time.Elapsed() / 200)) mod 2)
    end if
    
    hasWaited := true
    
    exit when mB = 1 and mLB not=1
    mLB := mB
end loop

var frameMillis : int := 10

class Wall
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox
    export Init, draw, getP1, getP2, getB, getM, getWallIntersect, getColour, getHeight
    
    var height : int := 100
    var col    : int := red 
    function getHeight() : int
        result height
    end getHeight
    function getColour() : int
        result col
    end getColour
    
    var p1, p2 : pointer to Vector2
    
    var m,b : real := 0 % As in Y=mX+b
    
    function getP1() : pointer to Vector2
        result p1
    end getP1
    
    function getP2() : pointer to Vector2
        result p2
    end getP2
    
    function getM() : real
        result m
    end getM
    
    function getB() : real
        result b
    end getB
    
    proc Init (e, s : pointer to Vector2, c:int)
        
        p1 := e
        p2 := s
        col := c
        
        
    end Init
    
    proc draw
        drawVectorThickLine (p1,p2,5,black)
        %Draw.FillOval(0,round(b),5,5,red)
    end draw
    
    function realBetween(a,x,y : real) : boolean
        
        if (x>y) then
            result realBetween(a,y,x)
        end if
        
        result a > x and a < y
        
    end realBetween
    
    /*function checkWallCol (w : pointer to Wall) : boolean
    var x : real := (b - (w -> getB()) ) / ((w -> getM()) - m)
    %x = (b2-b1)/(m1-m2)
    
    var y : real := (m*x)+b
    %Draw.FillOval(round(x),round(y),5,5,red)
    %result realBetween(x,w->getP1()->getX(),w->getP2()->getX()) andrealBetween(x,Location->Add(Velocity)->getX(),Location->getX())
    
    end checkWallCol*/
    
    function getWallIntersect (w : pointer to Wall) : pointer to Vector2
        
        var x : real := (b - (w -> getB()) ) / ((w -> getM()) - m)
        
        %x = (b2-b1)/(m1-m2)
        
        var y : real := (m*x)+b
        
        var vec : pointer to Vector2
        
        new Vector2, vec
        
        vec -> Set(x,y)
        
        result (vec)
        
    end getWallIntersect
    
end Wall

class Bullet
    import frameMillis, Vector2, drawVectorThickLine, zero, drawVectorBox, Wall,
        doVectorsCollide, getVectorCollision, realBetween, GUIBase
    export update, Init, checkWallCol
    
    % Location
    var Location : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    var m, b : real := 0
    
    procedure Init (Loc, Vel: pointer to Vector2, rot,speed:real)
        
        new Vector2, Location
        Velocity := Vel
        
        Location := Loc
        Velocity := Velocity -> AddDir(cosd(rot)*speed,sind(rot)*speed)
        
        m := (Location -> getY() - Location -> Add(Velocity) -> getY()) / (Location -> getX() - Location -> Add(Velocity) -> getX())
        b := Location->getY() - (Location -> Add(Velocity)->getX() * m)
        
    end Init
    
    function update () : boolean
        Location := Location -> Add(Velocity)
        
        %drawVectorThickLine(Location, Location->Add(Velocity),3,red)
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 2, 2, black)
        result Location->getX() < maxx and Location->getX() > 0 and Location->getY() < GUIBase and Location->getY() > 0
        
    end update
    
    function checkWallCol (w : pointer to Wall) : boolean
        %if (doVectorsCollide(Location, Location->Add(Velocity), w->getP1(),w->getP2())) then
        var hit : pointer to Vector2 := getVectorCollision(Location, Location->Add(Velocity),
            w->getP1(),w->getP2())
        
        %Draw.FillOval(round(hit->getX()),round(hit->getY()),10,10,cyan)
        
        result realBetween(hit->getX(),w->getP1()->getX(),w->getP2()->getX()) and
            realBetween(hit->getX(),Location->Add(Velocity)->getX(),Location->getX())
        % else
        %    result false
        %end if
    end checkWallCol
    
end Bullet

class Laser
    import frameMillis, Vector2, drawVectorThickLine, zero, drawVectorBox, Wall,
        doVectorsCollide, getVectorCollision, realBetween
    export update, Init, checkWallCol
    
    % Location
    var Location : pointer to Vector2
    
    var EndPoint : pointer to Vector2
    
    var TTL : int := 3
    var maxTTL : int := 3
    
    procedure Init (Loc : pointer to Vector2, rot:real)
        new Vector2, Location
        
        Location := Loc
        EndPoint := Location -> AddDir(cosd(rot)*100000,sind(rot)*100000)
        
    end Init
    
    function update () : int    % 0 for dead, 1 for firing, 2 for fading
        %Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 2, 2, black)
        TTL -= 1
        if (TTL = 0) then
            result 0
        elsif (TTL = maxTTL-1) then
            result 1
        else
            drawVectorThickLine(Location, EndPoint,TTL,blue)
            result 2
        end if
    end update
    
    proc checkWallCol (w : pointer to Wall)
        var hit : pointer to Vector2 := getVectorCollision(Location, EndPoint,
            w->getP1(),w->getP2())
        %Draw.FillOval(round(hit->getX()),round(hit->getY()),10,10,red)
        
        
        if realBetween(hit->getX(),w->getP1()->getX(),w->getP2()->getX()) and
                realBetween(hit->getX(),EndPoint->getX(),Location->getX()) then
            EndPoint := hit
        end if
    end checkWallCol
    
end Laser


class Tank
    import frameMillis, Vector2, drawVectorThickLine,zero,Bullet,drawVectorBox, Font2, Wall, getVectorCollision, doVectorsCollide, Laser, GUIBase
    export setControls, update, Init, Fire, Reload, CanFire,checkWallCol, CanFireLaser, FireLaser, render, getLocation,Rotation, getRotation
    
    var health := 100
    
    % The gun
    var maxAmmo, curAmmo : int := 10
    var damage := 10
    var curLasers, maxLasers : int := 100
    var laserDamage := 5
    
    var lastReload := 0
    var reloadMillis := 2500
    
    % Controls
    var Gas, Steering : real := 0
    var maxSteer : real := 90 % Degrees of max steering
    var maxThrottle:real:= 3
    
    
    % Location
    var Location : pointer to Vector2
    var PLoc     : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    % Local friction
    var Fric : pointer to Vector2
    
    var Rotation,turretRotation : real := 0
    
    %function CheckCol
    
    
    procedure Reload()
        if (curAmmo < maxAmmo) then
            lastReload := Time.Elapsed
        end if
    end Reload
    
    procedure Init (Vel, Loc, Fri : pointer to Vector2, rot : real) 
        Location := Loc
        Velocity := Vel
        Rotation := rot
        Fric     := Fri
        
        Fric ->Set(0,0)
    end Init
    
    procedure setControls (gas,steering,L : real)
        Gas := gas*(frameMillis/1000) * maxThrottle
        Steering := (steering*maxSteer)
        turretRotation += L*(frameMillis/1000)*100
        
    end setControls
    
    function getLocation () : pointer to Vector2
        result Location
    end getLocation
    
    function getRotation () : real
        result Rotation
    end getRotation
    
    proc render()
        
        Draw.FillBox(round(Location -> getX()) - 25, round(Location -> getY()) + 25,
            round(Location -> getX()) + 25, round(Location -> getY()) + 30, red)
        Draw.FillBox(round(Location -> getX()) - 25, round(Location -> getY()) + 25,
            round(Location -> getX()) - 25 + floor(health*50/100), round(Location -> getY()) + 30, green)
        Draw.Line(round(Location -> getX()) - 25, round(Location -> getY()) + 25,round(Location -> getX()) + 25, round(Location -> getY()) + 25,black)
        Draw.Line(round(Location -> getX()) - 25, round(Location -> getY()) + 30,round(Location -> getX()) + 25, round(Location -> getY()) + 30,black)
        Draw.Line(round(Location -> getX()) - 25, round(Location -> getY()) + 30,
            round(Location -> getX()) - 25, round(Location -> getY()) + 25,black)
        Draw.Line(round(Location -> getX()) + 25, round(Location -> getY()) + 30,
            round(Location -> getX()) + 25, round(Location -> getY()) + 25,black)
        
        
        
        % Draw the main body of the tank.
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(5,20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,-20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,20) -> RotateD(Rotation, Location), Location -> AddDir(-10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,20) -> RotateD(Rotation, Location), Location -> AddDir(-5,20) -> RotateD(Rotation, Location),1,black)
        % Draw the Laser Gun!
        drawVectorThickLine(Location -> AddDir(5,22) -> RotateD(Rotation, Location), Location -> AddDir(-5,22) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-5,22) -> RotateD(Rotation, Location), Location -> AddDir(-5,5) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-5,5) -> RotateD(Rotation, Location), Location -> AddDir(5,5) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(5,5) -> RotateD(Rotation, Location), Location -> AddDir(5,22) -> RotateD(Rotation, Location),1,black)
        var Forward := Location -> AddDir(0,10) -> RotateD(Rotation, Location)
        Draw.Fill(floor(Forward -> getX()),floor(Forward -> getY()),grey,black)
        Draw.Fill(floor(Location -> getX()),floor(Location -> getY()),green,black)
        
        
        Draw.FillBox(0,GUIBase, maxx,maxy,grey)
        Draw.ThickLine(0,GUIBase,maxx,GUIBase,3,black)
        
        if (lastReload = 0) then
            var ammoLine : string := "Ammo remaining: " + intstr(curAmmo) +"/"+intstr(maxAmmo)
            Font.Draw(ammoLine, maxx - 400, maxy-20,Font2, black)
        else
            Font.Draw("Reloading",maxx-400,maxy-20,Font2, red * (round(Time.Elapsed / 200) mod 2))
        end if
        
        drawVectorBox(Location -> AddDir(1,0) -> RotateD(turretRotation, Location),
            Location -> AddDir(-1,0) -> RotateD(turretRotation, Location),
            Location -> AddDir(-1,10) -> RotateD(turretRotation, Location),
            Location -> AddDir(1,10) -> RotateD(turretRotation, Location),
            black,black)
        
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 3, 3, grey)
        Draw.Oval(round(Location -> getX()), round(Location -> getY()), 3, 3, black)
        
    end render
    
    procedure update (mX, mY, mB : int)
        
        if (lastReload not= 0) then
            if (lastReload + reloadMillis < Time.Elapsed) then
                curAmmo := maxAmmo
                lastReload := 0
            end if
        end if
        
        PLoc := Location
        
        var RelPos, NewSpeed : pointer to Vector2
        new Vector2, RelPos
        new Vector2, NewSpeed
        
        % Friction
        %Velocity -> SetX(Velocity -> getX() * (1 - Fric -> getX()))
        %Velocity -> SetY(Velocity -> getY() * (1 - Fric -> getY()))
        Velocity := Velocity -> Multiply(0.99)
        
        NewSpeed -> Set(0,Gas)                          %Okay, so the idea is, create a vector with
        NewSpeed := NewSpeed -> RotateD(Steering*Gas/maxThrottle,zero->AddDir(0, Gas) )  % The magnitude of the Gas, and rotate it by steering.
        
        % Add extra speed
        Velocity := Velocity -> Add(NewSpeed)
        
        % Rotate to get relative new position
        RelPos := Velocity -> RotateD(Rotation, zero)
        
        Location := Location -> Add (RelPos)
        
        Rotation += Steering*(frameMillis/1000)
        
        if (Location -> getX() not= mX) then
            turretRotation := (arctand((Location -> getY()- mY) / (Location -> getX()- mX)) +270) mod 360
            if (Location -> getX() > mX) then
                turretRotation += 180
            end if
        end if
        
        if (Location -> getX() > maxx) then
            Location -> SetX(maxx-1)
        end if
        
        if (Location -> getY() > GUIBase) then
            Location -> SetY(GUIBase-1)
        end if
        
        if (Location -> getX() < 0) then
            Location -> SetX(1)
        end if
        
        if (Location -> getY() < 0) then
            Location -> SetY(1)
        end if
        
    end update
    
    function realBetween(a,x,y : real) : boolean
        
        if (x>y) then
            result realBetween(a,y,x)
        end if
        
        result a > x and a < y
        
    end realBetween
    
    procedure checkPointWall (loc : pointer to Vector2, w : pointer to Wall)
        var newLoc : pointer to Vector2 := loc->Add(Velocity)
        if (doVectorsCollide(loc, PLoc, w->getP1(),w->getP2())) then
            var hit : pointer to Vector2 := getVectorCollision(loc, PLoc,
                w->getP1(),w->getP2())
            var didIHit : boolean := realBetween(hit->getX(),w->getP1()->getX(),w->getP2()->getX()) and
                realBetween(hit->getX(),PLoc->getX(),loc->getX())
            if (didIHit) then
                /*Velocity := Velocity -> Multiply(0.5) -> RotateD(180,zero)
                Location := Location -> Add(Velocity)*/
                Velocity := zero
            end if
        end if
    end checkPointWall
    
    procedure checkWallCol (w : pointer to Wall)
        checkPointWall(Location->AddDir(10,20)->RotateD(Rotation,Location),w)
        checkPointWall(Location->AddDir(-10,20)->RotateD(Rotation,Location),w)
        checkPointWall(Location->AddDir(-10,-20)->RotateD(Rotation,Location),w)
        checkPointWall(Location->AddDir(10,-20)->RotateD(Rotation,Location),w)
    end checkWallCol
    
    function CanFire() : boolean
        result curAmmo > 0 and lastReload = 0
    end CanFire
    
    function Fire() : pointer to Bullet
        var Bul : pointer to Bullet
        new Bullet, Bul
        
        Bul -> Init(Location, Velocity -> RotateD(Rotation,zero), 90+turretRotation, 15)
        curAmmo -= 1
        
        result Bul
    end Fire
    
    function CanFireLaser() : boolean
        result true
    end CanFireLaser
    
    function FireLaser() : pointer to Laser
        var laser : pointer to Laser
        new Laser, laser
        
        laser -> Init(Location -> AddDir(0,15)->RotateD(Rotation, Location), Rotation+90)
        result laser
    end FireLaser
    
end Tank


var Player : pointer to Tank

new Tank, Player

var LastFrame : int := 0

var loc, vel,fric : pointer to Vector2

new Vector2, vel
new Vector2, loc
new Vector2, fric

fric ->Set(0.1,0.1)
loc -> Set(100,100)

Player -> Init(vel,loc,fric,0)

var bullets : flexible array 1..0 of pointer to Bullet
var lasers : flexible array 1..0 of pointer to Laser
var walls : flexible array -1..0 of pointer to Wall

% generate map from walls and vector points

var stream : int
var mapFile : flexible array 1..0 of string
open : stream, "map1.txt", get

cls
put "Loading map..."

loop
    exit when eof(stream)
    new mapFile, upper(mapFile) + 1
    get : stream, mapFile(upper(mapFile))
end loop

for i : 1..upper(mapFile)
    if (mapFile(i) = "Wall:") then
        
        var x1,x2,y1,y2,c : int := 0
        
        x1 := strint(mapFile (i+1))
        y1 := strint(mapFile (i+2))
        x2 := strint(mapFile (i+3))
        y2 := strint(mapFile (i+4))
        c  := i*5%strint(mapFile (i+5))
        
        put "Found a wall declaration: (", x1, ",",y1,"),(",x2,",",y2,"),",c,"."
        
        new walls, upper(walls)+1
        new Wall, walls(upper(walls))
        
        var e,s : pointer to Vector2
        new Vector2, e
        new Vector2, s
        s -> Set (x1+0.01,y1+0.01)
        e -> Set (x2+0.01,y2+0.01)
        
        walls(upper(walls)) -> Init (e,s,c)
        
    end if
end for
    put "Done!"
View.Update()
delay(500)

var playerHasControl := true

delay (20)
mLB := mB
Mouse.Where(mX,mY,mB)

var FRPlotX : int := 1


function getWall(camera, endPoint : pointer to Vector2) : pointer to Wall
    var W : pointer to Wall := nil
    var d : real := 1000000    % The square distance
    for i : 1..upper(walls)
        var w : pointer to Wall := walls(i)
        if (doVectorsCollide(camera, endPoint, w->getP1(),w->getP2())) then
            var hit : pointer to Vector2 := getVectorCollision(camera, endPoint,
                w->getP1(),w->getP2())
            var didIHit : boolean := realBetween(hit->getX(),w->getP1()->getX(),w->getP2()->getX()) and
                realBetween(hit->getX(),endPoint->getX(),camera->getX())
            if (didIHit) then
                var SM : real := hit -> Subtract(camera) -> getSqrMag()
                if (SM < d) then
                    W := w
                    d := SM
                end if
                %Draw.FillOval(round(hit->getX()),round(hit->getY()),5,5,blue)
            end if
        end if
    end for
    result W
end getWall

proc drawCol(x:int)
    var c : pointer to Vector2 := Player->getLocation()
    var e : pointer to Vector2 := Player->getLocation() -> AddDir(x-maxx/2,200) -> RotateD(Player->getRotation(),Player->getLocation())
    %drawVectorThickLine(c,e,1,red)
    var w : pointer to Wall := getWall(c,e)
    if (w not= nil) then
        Draw.Line(x, 0, x, 100, w -> getColour())
    end if
end drawCol

loop    % Main game logic loop
    
    if (playerHasControl) then 
        Mouse.Where(mX,mY,mB)
        formerChars := chars
        Input.KeyDown (chars)
        
        var H,V,L : int := 0
        
        if chars ('w') then
            V += 1
        end if
        if chars ('s') then
            V -= 1
        end if
        if chars ('d') then
            H -= 1
        end if
        if chars ('a') then
            H += 1
        end if
        if chars ('r') then
            Player -> Reload()
        end if
        if mB =1 and not mLB = 1 and Player -> CanFire() then
            new bullets, upper(bullets)+1
            bullets(upper(bullets)) := Player -> Fire() %SHOOT FROM THE TANK!
        end if
        if chars (' ') and Player -> CanFireLaser() then
            new lasers, upper(lasers)+1
            lasers(upper(lasers)) := Player -> FireLaser() %SHOOT FROM THE TANK!
        end if
        
        Player -> setControls(V,H,L)
        Player -> update(mX, mY, mB)
        
    end if
    
    for i : 1..upper(walls) 
        walls(i) -> draw()
    end for
        
    var RemoveTheseBullets : flexible array 0..-1 of int
    var RemoveTheseLasers : flexible array 0..-1 of int
    
    for i : 1..upper(bullets)
        var alive: boolean := true
        
        if (bullets(i) -> update() not= true) then
            new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
            RemoveTheseBullets (upper (RemoveTheseBullets)) := i - upper (RemoveTheseBullets) 
        end if
        
        if (alive) then
            for o : 1..upper(walls)
                if ( bullets(i) -> checkWallCol(walls(o))) then
                    new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
                    RemoveTheseBullets (upper (RemoveTheseBullets)) := i - upper (RemoveTheseBullets)
                    alive := false
                end if
            end for
        end if
    end for
        
    for i : 1..upper(lasers)
        var alive: boolean := true
        
        if (alive) then
            var lState := lasers(i) -> update()
            if (lState = 0 ) then
                new RemoveTheseLasers, upper (RemoveTheseLasers) + 1 
                RemoveTheseLasers (upper (RemoveTheseLasers)) := i - upper (RemoveTheseLasers) 
            elsif (lState = 1) then
                for o : 1..upper(walls)
                    lasers(i) -> checkWallCol(walls(o))
                end for
            end if
        end if
    end for
        
    Player -> render()
    
    for x : 1..maxx
        drawCol(x)
    end for
    
    for i : 1..upper(walls)
        Player -> checkWallCol(walls(i))
    end for
        
    for i : 0 .. upper (RemoveTheseBullets)
        
        for j : RemoveTheseBullets (i) .. upper (bullets) - 1 
            bullets (j) := bullets (j + 1)
        end for
            if (upper(bullets) > 0) then
            new bullets, upper (bullets) - 1
        end if
        
    end for
        
    for i : 0 .. upper (RemoveTheseLasers)
        
        for j : RemoveTheseLasers (i) .. upper (lasers) - 1 
            lasers (j) := lasers (j + 1)
        end for
            if (upper(lasers) > 0) then
            new lasers, upper (lasers) - 1
        end if
        
    end for
    
    
    
    put (LastFrame + frameMillis) - Time.Elapsed
    
    %FRPlotX := (FRPlotX+1) mod 200
    %draw.
    
    View.Update()
    cls()
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
    mLB := mB
end loop

