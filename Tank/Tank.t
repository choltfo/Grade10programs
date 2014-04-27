% Let's drive a Tank!

include "Vector2.t"
include "Lightning.t"
include "Particles.t"

View.Set("Graphics:900;600,offscreenonly")

var Font1 := Font.New ("Impact:72")
var Font2 := Font.New ("Arial:18")

var chars : array char of boolean
var formerChars : array char of boolean

var GUIBase : int := maxy - 50

var PS : pointer to ParticleSystem
new ParticleSystem, PS

var mX, mY, mB, mLB : int := 0      % Mouse vars
var hasWaited := false
loop    % Title screen loop
    Mouse.Where(mX, mY, mB)
    Font.Draw("The Tank Game",round((maxx/2)-(Font.Width("The Tank Game",Font1)/2)),maxy-100,Font1,black)
    Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),maxy-200,Font2,black)
    Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),maxy-220,Font2,black)
    Font.Draw("R to reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),maxy-240,Font2,black)
    Font.Draw("Space to fire laser",round((maxx/2)-(Font.Width("Space to fire laser",Font2)/2)),maxy-260,Font2,black)
    
    
    if (not hasWaited) then
        View.Update()
        delay(2000)
    else
        Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",Font2)/2)),maxy-400,Font2,black*(round(Time.Elapsed() / 200)) mod 2)
    end if
    
    hasWaited := true
    
    exit when mB = 1 and mLB not=1
    mLB := mB
    View.Update()
    cls()
    delay(10)
end loop

var frameMillis : int := 10

class Wall
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox
    export Init, draw, getP1, getP2, getB, getM, getWallIntersect, Puncture
    
    
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
    
    proc Init (e, s : pointer to Vector2)
        
        p1 := e
        p2 := s
        
    end Init
    
    proc draw
        drawVectorThickLine (p1,p2,5,black)
        %Draw.FillOval(0,round(b),5,5,red)
        %Draw.FillOval(round(p1->getX()),round(p1->getY()),5,5,red)
        %Draw.FillOval(round(p2->getX()),round(p2->getY()),5,5,red)
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
    
    function Puncture(point : pointer to Vector2, holeWidth : real) : pointer to Wall
        var res : pointer to Wall
        var hP1,hP2,dif : pointer to Vector2
        /*
        Hole point 1 and 2
        hP1 is the point nearest p1, while hP2 is nearest p2.
        dif is that massive line of math.
        */
        new Vector2, hP1
        new Vector2, hP2
        new Wall, res
        
        dif := zero->AddDir(0,holeWidth/2)->RotateD(arctand((p1->getY()-p2->getY())/(p1->getX()-p2->getX()))+90, zero)
        
        hP1 := point->Subtract(dif)
        hP2 := point->Add(dif)
        
        res -> Init (hP2, p2)
        p2 := hP1
        result res
    end  Puncture
    
end Wall

class Bullet
    import frameMillis, Vector2, drawVectorThickLine, zero, drawVectorBox, Wall,
        doVectorsCollide, getVectorCollision, realBetween, GUIBase, PS
    export update, Init, checkWallCol, getLoc, getVel
    
    % Location
    var Location : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    var m, b : real := 0
    
    function getLoc() : pointer to Vector2
        result Location
    end getLoc
    
    function getVel() : pointer to Vector2
        result Velocity
    end getVel
    
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
        
        PS -> Init(Location -> getX(),Location -> getY(),2,2,15,grey,2,1,10)
             %Init(x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
        
        
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
        doVectorsCollide, getVectorCollision, realBetween, PS
    export update, Init, checkWallCol, getEnd
    
    % Location
    var Location : pointer to Vector2
    
    var EndPoint : pointer to Vector2
    
    var TTL : int := 5
    var maxTTL : int := 5
    
    function getEnd() : pointer to Vector2
        result EndPoint
    end getEnd
    
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
    import frameMillis, Vector2, drawVectorThickLine,zero,Bullet,drawVectorBox, Font2, Wall, getVectorCollision, doVectorsCollide, Laser, GUIBase, LightningBox, PS
    export setControls, update, Init, Fire, Reload, CanFire,checkWallCol, CanFireLaser, FireLaser, render
    
    var health := 100
    
    var LB : pointer to LightningBox
    
    % The gun
    var maxAmmo, curAmmo : int := 10
    var damage := 10
    var curLasers, maxLasers : real := 100
    var laserDamage := 5
    var canLase : boolean := true
    
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
        new LightningBox, LB
        LB -> Init (10,maxy-10,230,GUIBase+10,black,yellow,darkgrey)
    end Init
    
    procedure setControls (gas,steering,L : real)
        Gas := gas*(frameMillis/1000) * maxThrottle
        Steering := (steering*maxSteer)
        turretRotation += L*(frameMillis/1000)*100
        
    end setControls
    
    proc render()
        % Health Bar
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
        
        drawVectorBox(Location -> AddDir(1,0) -> RotateD(turretRotation, Location),
            Location -> AddDir(-1,0) -> RotateD(turretRotation, Location),
            Location -> AddDir(-1,10) -> RotateD(turretRotation, Location),
            Location -> AddDir(1,10) -> RotateD(turretRotation, Location),
            black,black)
        
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 3, 3, grey)
        Draw.Oval(round(Location -> getX()), round(Location -> getY()), 3, 3, black)
        
        Draw.FillBox(0,GUIBase, maxx,maxy,grey)
        Draw.ThickLine(0,GUIBase,maxx,GUIBase,3,black)
        
        LB -> update()
        LB -> draw(round(curLasers),round(maxLasers), not canLase)
        
        if (lastReload = 0) then
            var ammoLine : string := "Ammo remaining: " + intstr(curAmmo) +"/"+intstr(maxAmmo)
            Font.Draw(ammoLine, maxx - 400, maxy-20,Font2, black)
        else
            Font.Draw("Reloading",maxx-400,maxy-20,Font2, red * (round(Time.Elapsed / 200) mod 2))
        end if
        
    end render
    
    procedure update (mX, mY, mB : int)
        
        if (curLasers < maxLasers) then
            curLasers += 10*(frameMillis/1000)
            if (round(curLasers) - 1 < 0) then
                canLase := false
            end if
        end if
        
        if ((canLase = false) and curLasers > 25) then
            canLase := true
        end if
        
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
        %NewSpeed := NewSpeed -> RotateD(Steering*Gas/maxThrottle,zero->AddDir(0, Gas) )  % The magnitude of the Gas, and rotate it by steering.
        
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
        
        var vel : pointer to Vector2 := Velocity -> Add(zero -> AddDir(0,10) ->RotateD(turretRotation,zero))
        
        PS -> InitAngular (Location->getX(), Location -> getY(),vel->getX(), vel -> getY(),100,darkgrey,2,10,20)
        PS -> InitAngular (Location->getX(), Location -> getY(),vel->getX(), vel -> getY(),15,yellow,2,10,20)
        PS -> InitAngular (Location->getX(), Location -> getY(),vel->getX(), vel -> getY(),15,41,2,10,20)
        PS -> InitAngular (Location->getX(), Location -> getY(),vel->getX(), vel -> getY(),30,red,2,10,20)
        %Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
        result Bul
    end Fire
    
    function CanFireLaser() : boolean
        result (curLasers > 0) and (canLase = true)
    end CanFireLaser
    
    function FireLaser() : pointer to Laser
        var laser : pointer to Laser
        new Laser, laser
        
        laser -> Init(Location -> AddDir(0,15)->RotateD(Rotation, Location), Rotation+90)
        curLasers-=1
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
        
        var x1,x2,y1,y2 : int := 0
        
        x1 := strint(mapFile (i+1))
        y1 := strint(mapFile (i+2))
        x2 := strint(mapFile (i+3))
        y2 := strint(mapFile (i+4))
        
        put "Found a wall declaration: (", x1, ",",y1,"),(",x2,",",y2,")"
        
        new walls, upper(walls)+1
        new Wall, walls(upper(walls))
        
        var e,s : pointer to Vector2
        new Vector2, e
        new Vector2, s
        s -> Set (x1+0.01,y1+0.01)
        e -> Set (x2+0.01,y2+0.01)
        
        walls(upper(walls)) -> Init (e,s)
        
    end if
end for

put "Done!"
View.Update()
delay(500)

var playerHasControl := true

delay (20)
mLB := mB
Mouse.Where(mX,mY,mB)

function PtInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        result PtInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        result PtInRect(x,y,x1,y2,x2,y1)
    end if
    result (x > x1) and (x < x2) and (y > y1) and (y < y2)
end PtInRect

var bgImg : int := 0

proc pauseScreen()
    var mX,mY,mB,lMB : int := 0
    loop
        formerChars := chars
        Input.KeyDown (chars)
        Mouse.Where(mX,mY,mB)
        
        Pic.Draw(bgImg,0,0,0)
        
        Font.Draw("Paused",round((maxx/2)-(Font.Width("Paused",Font1)/2)),maxy-100,Font1,black)
        Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),maxy-200,Font2,black)
        Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),maxy-220,Font2,black)
        Font.Draw("R to reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),maxy-240,Font2,black)
        Font.Draw("Space to fire laser",round((maxx/2)-(Font.Width("Space to fire laser",Font2)/2)),maxy-260,Font2,black)
        
        
        
        exit when chars(KEY_ESC) and not formerChars(KEY_ESC)
        View.Update()
        cls()
        delay (10)
        lMB := mB
    end loop
end pauseScreen

var FRPlotX : int := 1

var paused : boolean := false

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
        if chars(KEY_ESC) and not formerChars(KEY_ESC) then
            paused := true
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
    var RemoveTheseWalls : flexible array 0..-1 of int
    
    for i : 1..upper(bullets)
        var alive: boolean := true
        
        if (bullets(i) -> update() not= true) then
            new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
            RemoveTheseBullets (upper (RemoveTheseBullets)) := i - upper (RemoveTheseBullets)
        end if
        
        if (alive) then
            for o : 1..upper(walls)
                if ( bullets(i) -> checkWallCol(walls(o))) then
                    % TODO: Blast holes in walls.
                    var hitLoc : pointer to Vector2 := getVectorCollision(walls(o)->getP1(), walls(o)->getP2(), bullets(i)->getLoc(), bullets(i)->getLoc()->Add(bullets(i)->getVel()))
                    
                    if (walls(o)->getP1()->Subtract(hitLoc)->getSqrMag() < (100)) then
                        if (walls(o)->getP2()->Subtract(hitLoc)->getSqrMag() < (100)) then
                            new RemoveTheseWalls, upper (RemoveTheseWalls) + 1
                            RemoveTheseWalls (upper (RemoveTheseWalls)) := o - upper (RemoveTheseWalls)
                        else
                            walls(o)->Init(hitLoc,walls(o)->getP2())
                        end if
                    elsif (walls(o)->getP2()->Subtract(hitLoc)->getSqrMag() < (100)) then
                        if (walls(o)->getP1()->Subtract(hitLoc)->getSqrMag() < (100)) then
                            new RemoveTheseWalls, upper (RemoveTheseWalls) + 1
                            RemoveTheseWalls (upper (RemoveTheseWalls)) := o - upper (RemoveTheseWalls)
                        else
                            walls(o)->Init(walls(o)->getP1(),hitLoc)
                        end if
                    else
                        new walls, upper(walls)+1
                        walls(upper(walls)) := walls(o) -> Puncture(hitLoc, 20)
                    end if
                    
                    
                    PS -> Init (hitLoc -> getX(), hitLoc -> getY(), 2,2,20,red,5,20,20)
                    PS -> Init (hitLoc -> getX(), hitLoc -> getY(), 2,2,20,yellow,5,20,20)
                    PS -> Init (hitLoc -> getX(), hitLoc -> getY(), 10,10,100,grey,2,20,75)
                    PS -> Init (hitLoc -> getX(), hitLoc -> getY(), 10,10,100,black,1,20,75)
                    %Init (x,y,maxXSpeed,maxYSpeed,numOfP,Colour,size,TTLMin,TTLMax : int)
                    
                    new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
                    RemoveTheseBullets (upper (RemoveTheseBullets)) := i% - upper (RemoveTheseBullets)
                    alive := false
                end if
            end for
            
        end if
        
        /*if (alive) then
            new KeepTheseBullets, upper (KeepTheseBullets) + 1 
            KeepTheseBullets (upper (KeepTheseBullets)) := o
        end if*/
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
        
        
        PS -> Init (lasers(i) -> getEnd() ->getX(),lasers(i) -> getEnd() -> getY(),10,10,10,cyan,2,1,2)
        %     Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
    end for
        
    Player -> render()
    
    PS -> update()
    PS -> draw()
    
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
        
    for i : 0 .. upper (RemoveTheseWalls)
        
        for j : RemoveTheseWalls (i) .. upper (walls) - 1 
            walls (j) := walls (j + 1)
        end for
            if (upper(walls) > 0) then
            new walls, upper (walls) - 1
        end if
        
    end for
    
    
    %put (LastFrame + frameMillis) - Time.Elapsed
    
    %FRPlotX := (FRPlotX+1) mod 200
    %draw.
    
    if (paused) then
        bgImg := Pic.New(0,0,maxx,maxy)
        %bgImg := Pic.Blur(bgImg,10)
        pauseScreen()
        paused := false
    end if
    
    View.Update()
    cls()
    Draw.FillBox(0,0,maxx,maxy,brown)
    %loop
    %    exit when (LastFrame + frameMillis) < Time.Elapsed
    %end loop
    Time.DelaySinceLast(frameMillis)
    LastFrame := Time.Elapsed
    mLB := mB
end loop

