% All main game code

include "Vectors.t"
include "Lightning.t"
include "Particles.t"

View.Set("Graphics:1200;650,offscreenonly,nobuttonbar")

var Font1 := Font.New ("Impact:72")
var Font2 := Font.New ("Arial:18")

var chars : array char of boolean
var formerChars : array char of boolean

var GUIBase : int := maxy - 50

var PS : pointer to ParticleSystem
new ParticleSystem, PS

var playerHasControl := true

var frameMillis : int := 10

var mX, mY, mB, mLB : int := 0      % Mouse vars


class Wall
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox, Vector
    export Init, draw, getP1, getP2, getB, getM, getWallIntersect, Puncture
    
    
    var p1, p2 : Vector2
    
    var m,b : real := 0 % As in Y=mX+b
    
    function getP1() : Vector2
        result p1
    end getP1
    
    function getP2() : Vector2
        result p2
    end getP2
    
    function getM() : real
        result m
    end getM
    
    function getB() : real
        result b
    end getB
    
    proc Init (e, s : Vector2)
        
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
    
    function getWallIntersect (w : pointer to Wall) : Vector2
        
        var x : real := (b - (w -> getB()) ) / ((w -> getM()) - m)
        
        %x = (b2-b1)/(m1-m2)
        
        var y : real := (m*x)+b
        
        var vec : Vector2
        
        vec.x := x
        vec.y := y
        
        result vec
        
    end getWallIntersect
    
    function Puncture(point : Vector2, holeWidth : real) : pointer to Wall
        var res : pointer to Wall
        var hP1,hP2,dif : Vector2
        /*
        Hole point 1 and 2
        hP1 is the point nearest p1, while hP2 is nearest p2.
        dif is that massive line of math.
        */
        new Wall, res
        
        %dif := zero->AddDir(0,holeWidth/2)->RotateD(arctand((p1->getY()-p2->getY())/(p1->getX()-p2->getX()))+90, zero)
        
        dif := Vector.RotateD(Vector.AddDir(zero,0,holeWidth/2),zero,arctand((p1.y-p2.y)/(p1.x-p2.x))+90)
        
        hP1 := Vector.Subtract(point,dif)
        hP2 := Vector.Add(point,dif)
        
        res -> Init (hP2, p2)
        p2 := hP1
        
        result res
    end  Puncture
    
end Wall

class Bullet
    import frameMillis, Vector2, drawVectorThickLine, zero, drawVectorBox, Wall,
        doVectorsCollide, getVectorCollision, realBetween, GUIBase, PS, Vector
    export update, Init, checkWallCol, getLoc, getVel
    
    % Location
    var Location : Vector2
    
    % Local velocity
    var Velocity : Vector2
    
    var m, b : real := 0
    
    function getLoc() : Vector2
        result Location
    end getLoc
    
    function getVel() : Vector2
        result Velocity
    end getVel
    
    procedure Init (Loc, Vel: Vector2, rot,speed:real)
        
        Velocity := Vel
        
        Location := Loc
        Velocity := Vector.AddDir(Velocity,cosd(rot)*speed,sind(rot)*speed)
        
        
        PS -> InitAngular (Location.x, Location.y, Velocity.x, Velocity.y, 100,darkgrey,2,10,20)
        PS -> InitAngular (Location.x, Location.y, Velocity.x, Velocity.y, 15,yellow,2,10,20)
        PS -> InitAngular (Location.x, Location.y, Velocity.x, Velocity.y, 15,41,2,10,20)
        PS -> InitAngular (Location.x, Location.y, Velocity.x, Velocity.y, 30,red,2,10,20)
        
    end Init
    
    function update () : boolean
        
        Location := Vector.Add(Location,Velocity)
        
        PS -> Init(Location.x,Location.y,2,2,15,grey,2,1,10)
             %Init(x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
        %drawVectorThickLine(Location, Location->Add(Velocity),3,red)
        Draw.FillOval(round(Location.x), round(Location.y), 2, 2, black)
        result Location.x < maxx and Location.x > 0 and Location.y < GUIBase and Location.y > 0
        
    end update
    
    function checkWallCol (w : pointer to Wall) : boolean
        %if (doVectorsCollide(Location, Location->Add(Velocity), w->getP1(),w->getP2())) then
        var temp : Vector2 := Vector.Add(Location,Velocity)
        var hit : Vector2 := getVectorCollision(Location, temp, w->getP1(),w->getP2())
        
        %Draw.FillOval(round(hit->getX()),round(hit->getY()),10,10,cyan)
        
        result realBetween(hit.x,w->getP1().x,w->getP2().x) and
            realBetween(hit.x,Vector.Add(Location,Velocity).x,Location.x)
        % else
        %    result false
        %end if
    end checkWallCol
    
end Bullet

class Laser
    import frameMillis, Vector2, drawVectorThickLine, zero, drawVectorBox, Wall,
        doVectorsCollide, getVectorCollision, realBetween, PS, Vector
    export update, Init, checkWallCol, getEnd, getLoc
    
    % Location
    var Location : Vector2
    
    var EndPoint : Vector2
    
    var TTL : int := 5
    var maxTTL : int := 5
    
    function getEnd() : Vector2
        result EndPoint
    end getEnd
    
    function getLoc() : Vector2
        result Location
    end getLoc
    
    procedure Init (Loc : Vector2, rot:real)
        
        Location := Loc
        EndPoint := Vector.AddDir(Location,cosd(rot)*100000,sind(rot)*100000)
        
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
        var hit : Vector2 := getVectorCollision(Location, EndPoint,
            w->getP1(),w->getP2())
        %Draw.FillOval(round(hit->getX()),round(hit->getY()),10,10,red)
        
        
        if realBetween(hit.x,w->getP1().x,w->getP2().x) and
                realBetween(hit.x,EndPoint.x,Location.x) then
            EndPoint := hit
        end if
        
    end checkWallCol
    
end Laser

class Tank
    import frameMillis, Vector2, drawVectorThickLine,zero,Bullet,drawVectorBox, Font2, Wall, getVectorCollision, doVectorsCollide, Laser, GUIBase, LightningBox, PS, Vector
    export setControls, update, Init, Fire, Reload, CanFire,checkWallCol, CanFireLaser, FireLaser, render,drawGUI, getLoc, getRot, checkBulletCollision, checkHealth, damage, updateAI, checkLaserCollision, getHealth
    
    var health := 100
    
    var LB : pointer to LightningBox
    var col : int := red
    
    % The gun
    var maxAmmo, curAmmo : int := 10
    var gunDamage := 10
    var lastShot := 0
    var shotDelay := 100
    
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
    var Location : Vector2
    var PLoc     : Vector2
    
    % Local velocity
    var Velocity : Vector2
    
    % Local friction
    var Fric : Vector2
    
    var Rotation,turretRotation : real := 0
    
    %function CheckCol
    
    function getLoc() : Vector2
        result Location
    end getLoc
    
    function getRot() : real
        result Rotation
    end getRot
    
    function getHealth() : int
        result health
    end getHealth
    
    procedure Reload()
        if (curAmmo < maxAmmo) then
            lastReload := Time.Elapsed
        end if
    end Reload
    
    procedure Init (Vel, Loc, Fri : Vector2, rot : real,c : int)
        
        Location := Loc
        Velocity := Vel
        Rotation := rot
        Fric     := Fri
        col := c
        
        Fric.x := 0
        Fric.y := 0
        
        Velocity.x := 0
        Velocity.y := 0
        
        %Location.x := 100
        %Location.y := 100
        
        new LightningBox, LB
        LB -> Init (10,maxy-10,230,GUIBase+10,black,yellow,darkgrey)
        
        PLoc := Location
    end Init
    
    procedure setControls (gas,steering,L : real)
        Gas := gas*(frameMillis/1000) * maxThrottle
        Steering := (steering*maxSteer)
        turretRotation += L*(frameMillis/1000)*100
    end setControls
    
    proc drawGUI ()
        
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
        
    end drawGUI
    
    proc damage(d : int)
        health -= d
    end damage
    
    function checkHealth() : boolean
        result health > 0
    end checkHealth
    
    proc render()
        
        % Health Bar
        Draw.FillBox(round(Location.x) - 25, round(Location.y) + 25,
            round(Location.x) + 25, round(Location.y) + 30, red)
        Draw.FillBox(round(Location.x) - 25, round(Location.y) + 25,
            round(Location.x) - 25 + floor(health*50/100), round(Location.y) + 30, green)
            
        Draw.Line(round(Location.x) - 25, round(Location.y) + 25,
            round(Location.x) + 25, round(Location.y) + 25,black)
        Draw.Line(round(Location.x) - 25, round(Location.y) + 30,
            round(Location.x) + 25, round(Location.y) + 30,black)
        Draw.Line(round(Location.x) - 25, round(Location.y) + 30,
            round(Location.x) - 25, round(Location.y) + 25,black)
        Draw.Line(round(Location.x) + 25, round(Location.y) + 30,
            round(Location.x) + 25, round(Location.y) + 25,black)
        
        % Draw the main body of the tank.
        
        var a,b,c,d,e,f : Vector2
        
        a := Vector.RotateD(Vector.AddDir(Location, 10, 20), Location, Rotation)
        b := Vector.RotateD(Vector.AddDir(Location, 10,-20), Location, Rotation)
        c := Vector.RotateD(Vector.AddDir(Location,  5, 20), Location, Rotation)
        d := Vector.RotateD(Vector.AddDir(Location,-10,-20), Location, Rotation)
        e := Vector.RotateD(Vector.AddDir(Location,-10, 20), Location, Rotation)
        f := Vector.RotateD(Vector.AddDir(Location, -5, 20), Location, Rotation)
        
        drawVectorThickLine(a, b,1,black)
        drawVectorThickLine(a, c,1,black)
        drawVectorThickLine(d, b,1,black)
        drawVectorThickLine(e, d,1,black)
        drawVectorThickLine(e, f,1,black)
        
        % Reassign these variable for use in drawing the laser gun
        a := Vector.RotateD(Vector.AddDir(Location, 5, 22), Location, Rotation)
        b := Vector.RotateD(Vector.AddDir(Location,-5, 22), Location, Rotation)
        c := Vector.RotateD(Vector.AddDir(Location,-5, 5 ), Location, Rotation)
        d := Vector.RotateD(Vector.AddDir(Location, 5, 5 ), Location, Rotation)
        
        
        % Draw the Laser Gun!
        drawVectorThickLine(a,b,1,black)
        drawVectorThickLine(a,d,1,black)
        drawVectorThickLine(c,b,1,black)
        drawVectorThickLine(c,d,1,black)
        var Forward := Vector.RotateD(Vector.AddDir(Location,0,10),Location,Rotation)
        Draw.Fill(floor(Forward.x),floor(Forward.y),grey,black)
        Draw.Fill(floor(Location.x),floor(Location.y),col,black)
        
        % And the cannon
        a := Vector.RotateD(Vector.AddDir(Location, 1, 0), Location, turretRotation)
        b := Vector.RotateD(Vector.AddDir(Location,-1, 0), Location, turretRotation)
        c := Vector.RotateD(Vector.AddDir(Location,-1,10), Location, turretRotation)
        d := Vector.RotateD(Vector.AddDir(Location, 1,10), Location, turretRotation)
        
        drawVectorBox(a,b,c,d,black,black)
        
        Draw.FillOval(round(Location.x), round(Location.y), 3, 3, grey)
        Draw.Oval(round(Location.x), round(Location.y), 3, 3, black)
        
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
        
        var RelPos, NewSpeed : Vector2
        
        % Friction
        %Velocity -> SetX(Velocity -> getX() * (1 - Fric -> getX()))
        %Velocity -> SetY(Velocity -> getY() * (1 - Fric -> getY()))
        Velocity := Vector.Multiply(Velocity,0.99)
        
        NewSpeed.x := 0
        NewSpeed.y := Gas                         %Okay, so the idea is, create a vector with
        %NewSpeed := NewSpeed -> RotateD(Steering*Gas/maxThrottle,zero->AddDir(0, Gas) )  % The magnitude of the Gas, and rotate it by steering.
        
        % Add extra speed
        Velocity := Vector.Add(Velocity,NewSpeed)
        
        % Rotate to get relative new position
        RelPos := Vector.RotateD(Velocity,zero,Rotation)
        Location := Vector.Add(Location,RelPos)
        
        Rotation += Steering*(frameMillis/1000)
        
        if (Location.x not= mX) then
            turretRotation := (arctand((Location.y- mY) / (Location.x- mX)) +270) mod 360
            if (Location.x > mX) then
                turretRotation += 180
            end if
        end if
        
        if (Location.x > maxx) then
            Location.x := maxx-1
        end if
        
        if (Location.y > GUIBase) then
            Location.y := GUIBase-1
        end if
        
        if (Location.x < 0) then
            Location.x := 1
        end if
        
        if (Location.y < 0) then
            Location.y := 1
        end if
        
    end update
    
    function realBetween(a,x,y : real) : boolean
        
        if (x>y) then
            result realBetween(a,y,x)
        end if
        
        result a > x and a < y
        
    end realBetween
    
    procedure checkPointWall (loc : Vector2, w : pointer to Wall)
        var newLoc : Vector2 := Vector.Add(loc,Velocity)
        if (doVectorsCollide(loc, PLoc, w->getP1(),w->getP2())) then
            var hit : Vector2 := getVectorCollision(loc, PLoc,
                w->getP1(),w->getP2())
            var didIHit : boolean := realBetween(hit.x,w->getP1().x,w->getP2().x) and
                realBetween(hit.x,PLoc.x,loc.x)
            if (didIHit) then
                /*Velocity := Velocity -> Multiply(0.5) -> RotateD(180,zero)
                Location := Location -> Add(Velocity)*/
                Velocity := zero
            end if
        end if
    end checkPointWall
    
    procedure checkWallCol (w : pointer to Wall)
        
        var a,b,c,d : Vector2

        a := Vector.RotateD(Vector.AddDir(Location, 10, 20),Location,Rotation)
        b := Vector.RotateD(Vector.AddDir(Location,-10, 20),Location,Rotation)
        c := Vector.RotateD(Vector.AddDir(Location,-10,-20),Location,Rotation)
        d := Vector.RotateD(Vector.AddDir(Location, 10,-20),Location,Rotation)
        
        checkPointWall(a,w)
        checkPointWall(b,w)
        checkPointWall(c,w)
        checkPointWall(d,w)
        
        
    end checkWallCol
    
    function CanFire() : boolean
        result curAmmo > 0 and lastReload = 0 and Time.Elapsed > (lastShot + shotDelay)
    end CanFire
    
    function Fire() : pointer to Bullet
        var Bul : pointer to Bullet
        new Bullet, Bul
        
        Bul -> Init(Location, Vector.RotateD(Velocity, zero, Rotation),90+turretRotation,15)
        curAmmo -= 1
        
        var vel : Vector2 := Vector.Add(Velocity,Vector.RotateD(Vector.AddDir(zero,0,10),zero,turretRotation))
        %Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
        lastShot := Time.Elapsed
        result Bul
    end Fire
    
    function CanFireLaser() : boolean
        result (curLasers > 0) and (canLase = true)
    end CanFireLaser
    
    function FireLaser() : pointer to Laser
        var laser : pointer to Laser
        new Laser, laser
        
        laser -> Init(Vector.RotateD(Vector.AddDir(Location,0,15),Location,Rotation), Rotation+90)
        curLasers-=1
        result laser
    end FireLaser
    
    function checkLaserCollision (l : pointer to Laser) : boolean
        
        var p1,p2 : Vector2
        
        p1 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,0, 20),zero,Rotation))
        p2 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,0,-20),zero,Rotation))
        
        
        %drawVectorThickLine (Vector.Add(b->getLoc(),b->getVel()),b->getLoc(),5,red)
        %drawVectorThickLine (p1,p2,5,black)
        
        var firstHit, secondHit : boolean := false
        
        if (doVectorsCollide(p1, p2, l->getLoc(), l->getEnd())) then
            
            var hit : Vector2 := getVectorCollision(p1,p2, l->getLoc(), l->getEnd())
            
            %Draw.FillOval(round(hit.x),round(hit.y),5,5,blue)
            
            firstHit := realBetween(hit.x,p1.x,p2.x) and
                    realBetween(hit.x,l->getEnd().x,l->getLoc().x)
        end if
        if (not firstHit) then
            p1 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero, 10,0),zero,Rotation))
            p2 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,-10,0),zero,Rotation))
            
            
            %drawVectorThickLine (Vector.Add(b->getLoc(),b->getVel()),b->getLoc(),5,red)
            %drawVectorThickLine (p1,p2,5,black)
            
            if (doVectorsCollide(p1, p2, l->getLoc(), l->getEnd())) then
                
                var hit : Vector2 := getVectorCollision(p1,p2, l->getLoc(), l->getEnd())
                    
                %Draw.FillOval(round(hit.x),round(hit.y),5,5,blue)
                
                secondHit := realBetween(hit.x,p1.x,p2.x) and
                        realBetween(hit.x,l->getEnd().x,l->getLoc().x)
            end if
        end if
        
        result firstHit or secondHit
    end checkLaserCollision
    
    function checkBulletCollision (b : pointer to Bullet) : boolean
        
        var p1,p2 : Vector2
        
        p1 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,0, 20),zero,Rotation))
        p2 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,0,-20),zero,Rotation))
        
        
        %drawVectorThickLine (Vector.Add(b->getLoc(),b->getVel()),b->getLoc(),5,red)
        %drawVectorThickLine (p1,p2,5,black)
        
        var firstHit,secondHit : boolean := false
        
        if (doVectorsCollide(p1, p2, b->getLoc(), Vector.Add(b->getLoc(),b->getVel()))) then
            
            var hit : Vector2 := getVectorCollision(p1,p2, b->getLoc(), Vector.Add(b->getLoc(),b->getVel()))
            
            %Draw.FillOval(round(hit.x),round(hit.y),5,5,blue)
            
            firstHit := realBetween(hit.x,p1.x,p2.x) and
                    realBetween(hit.x,Vector.Add(b->getLoc(),b->getVel()).x,b->getLoc().x)
        end if
        if (not firstHit) then
            p1 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,10,0),zero,Rotation))
            p2 := Vector.Add(Location,Vector.RotateD(Vector.AddDir(zero,-10,0),zero,Rotation))
            if (doVectorsCollide(p1, p2, b->getLoc(), Vector.Add(b->getLoc(),b->getVel()))) then
            
                var hit : Vector2 := getVectorCollision(p1,p2, b->getLoc(), Vector.Add(b->getLoc(),b->getVel    ()))
            
                %Draw.FillOval(round(hit.x),round(hit.y),5,5,blue)
                
                secondHit := realBetween(hit.x,p1.x,p2.x) and
                        realBetween(hit.x,Vector.Add(b->getLoc(),b->getVel()).x,b->getLoc().x)
            end if
        end if
        
        result firstHit or secondHit
    end checkBulletCollision
    
    
    function updateAI (target : pointer to Tank) : boolean
        % This needs to drive the tank!
        
        if (Location.x not= target->getLoc().x) then
            if (Location.x < target->getLoc().x) then
                turretRotation := (arctand((Location.y- target -> getLoc().y) / (Location.x- target -> getLoc().x)) +270) mod 360
            else
                turretRotation := (arctand((Location.y- target -> getLoc().y) / (Location.x- target -> getLoc().x)) +90) mod 360
            end if
            %turretRotation := (arctand((Location.y- mY) / (Location.x- mX)) +270) mod 360
        else
            if (Location.y > target->getLoc().y) then
                turretRotation := 90
            else
                turretRotation := 270
            end if
        end if
        
        var sqDist : real := Vector.getSqrMag(Vector.Subtract(target->getLoc(),Location))
        
        
        if (sqDist > 10000) then
            setControls (1,(turretRotation-Rotation)/2,0)
        else
            setControls (-1,(turretRotation-Rotation),0)
        end if
        
        if (CanFire()) then
            result true
        else
            if (lastReload = 0) then
                Reload()
            end if
        end if
        result false
    end updateAI
end Tank


var Player : pointer to Tank

var LastFrame : int := 0

var loc, vel,fric : Vector2

var bullets :   flexible array 1..0 of pointer to Bullet
var lasers :    flexible array 1..0 of pointer to Laser
var walls :     flexible array 1..0 of pointer to Wall
var enemies :   flexible array 1..0 of pointer to Tank

proc loadMap (map : string)
% generate map from walls and vector points
var stream : int
var mapFile : flexible array 1..0 of string
open : stream, map, get

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
        
        var e,s : Vector2
        
        s.x:=x1+0.01
        s.y:=y1+0.01
        e.x:=x2+0.01
        e.y:=y2+0.01
        
        walls(upper(walls)) -> Init (e,s)
        
    end if
    
    if (mapFile(i) = "Enemy:") then
        
        var x, y : real := 0
        
        x := strint(mapFile (i+1))
        y := strint(mapFile (i+2))
        put "Found enemy at (",x,", ",y,")."
        new enemies, upper(enemies) + 1
        new Tank, enemies(upper(enemies))
        enemies(upper(enemies))->Init(vel,Vector.AddDir(zero,x,y),fric,45,red)
    end if
end for

put "Done!"
View.Update()
delay(500)


fric.x := 0.1
fric.y := 0.1

loc.x := 100
loc.y := 100

new Tank, Player
Player -> Init(vel,loc,fric,0,green)

end loadMap


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

proc clearLevel ()
    for i : 1..upper(bullets)
        free bullets(i)
    end for
    free bullets
    
    for i : 1..upper(lasers)
        free lasers(i)
    end for
    free lasers
    
    for i : 1..upper(walls)
        free walls(i)
    end for
    free walls
    
    for i : 1..upper(enemies)
        free enemies(i)
    end for
    free enemies
    
    free Player
    
end clearLevel

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


function playLoadedLevel() : boolean
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
        /*if chars (KEY_ENTER) and not formerChars (KEY_ENTER) then
            new enemies, upper(enemies) + 1
            new Tank, enemies(upper(enemies))
            enemies(upper(enemies))->Init(vel,Player->getLoc(),fric,45,red)
        end if*/
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
    var RemoveTheseEnemies : flexible array 0..-1 of int
    
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
                    
                    var hitLoc : Vector2 := getVectorCollision(walls(o)->getP1(), walls(o)->getP2(), bullets(i)->getLoc(), Vector.Add(bullets(i)->getLoc(),bullets(i)->getVel()))
                    
                    if (Vector.getSqrMag(Vector.Subtract(walls(o)->getP1(),hitLoc)) < 100) then
                        if (Vector.getSqrMag(Vector.Subtract(walls(o)->getP2(),hitLoc)) < 100) then
                            new RemoveTheseWalls, upper (RemoveTheseWalls) + 1
                            RemoveTheseWalls (upper (RemoveTheseWalls)) := o - upper (RemoveTheseWalls)
                        else
                            walls(o)->Init(hitLoc,walls(o)->getP2())
                        end if
                    elsif (Vector.getSqrMag(Vector.Subtract(walls(o)->getP2(),hitLoc)) < 100) then
                        if (Vector.getSqrMag(Vector.Subtract(walls(o)->getP1(),hitLoc)) < 100) then
                            new RemoveTheseWalls, upper (RemoveTheseWalls) + 1
                            RemoveTheseWalls (upper (RemoveTheseWalls)) := o - upper (RemoveTheseWalls)
                        else
                            walls(o)->Init(walls(o)->getP1(),hitLoc)
                        end if
                    else
                        new walls, upper(walls)+1
                        walls(upper(walls)) := walls(o) -> Puncture(hitLoc, 20)
                    end if
                    
                    
                    PS -> Init (hitLoc.x, hitLoc.y, 2,2,20,red,5,20,20)
                    PS -> Init (hitLoc.x, hitLoc.y, 2,2,20,yellow,5,20,20)
                    PS -> Init (hitLoc.x, hitLoc.y, 10,10,100,grey,2,20,75)
                    PS -> Init (hitLoc.x, hitLoc.y, 10,10,100,black,1,20,75)
                    %Init (x,y,maxXSpeed,maxYSpeed,numOfP,Colour,size,TTLMin,TTLMax : int)
                    
                    new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
                    RemoveTheseBullets (upper (RemoveTheseBullets)) := i% - upper (RemoveTheseBullets)
                    alive := false
                end if
            end for
            
            for o : 1..upper(enemies)
                
                if (enemies(o) -> checkBulletCollision(bullets(i))) then
                    enemies(o) -> damage(10)
                    alive := false
                    new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
                    RemoveTheseBullets (upper (RemoveTheseBullets)) := i
                    
                    PS -> Init (enemies(o)->getLoc().x, enemies(o)->getLoc().y, 5,5,50,red,1,10,20)
                    PS -> Init (enemies(o)->getLoc().x, enemies(o)->getLoc().y, 5,5,50,yellow,1,10,20)
                    PS -> Init (enemies(o)->getLoc().x, enemies(o)->getLoc().y, 5,5,50,41,1,10,20)
                end if
                
            end for
            
            if (Player -> checkBulletCollision(bullets(i))) then
                Player -> damage(10)
                alive := false
                new RemoveTheseBullets, upper (RemoveTheseBullets) + 1 
                    RemoveTheseBullets (upper (RemoveTheseBullets)) := i
            end if
            
            
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
        
        for o : 1..upper(enemies)
            if (alive) then
                if (enemies(o)->checkLaserCollision(lasers(i))) then
                    enemies(o)->damage(1)
                    PS -> Init (enemies(o) -> getLoc().x,enemies(o) -> getLoc().y,10,10,10,blue,2,5,10)
                end if
            end if
        end for
        
        
        PS -> Init (lasers(i) -> getEnd().x,lasers(i) -> getEnd().y,10,10,10,cyan,2,1,2)
        %     Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
    end for
        
    Player -> render()
    Player -> drawGUI()
    
    for i : 1..upper(enemies)
        enemies(i) -> render()
        enemies(i) -> update(0,0,0)
        if (enemies(i) -> updateAI(Player)) then
            new bullets, upper(bullets)+1
            bullets(upper(bullets)) := enemies(i) -> Fire()
        end if
        if ( not enemies(i) -> checkHealth()) then
            PS -> Init (enemies(i)->getLoc().x, enemies(i)->getLoc().y, 2,2,50,red,1,20,50)
            PS -> Init (enemies(i)->getLoc().x, enemies(i)->getLoc().y, 2,2,50,yellow,1,20,50)
            PS -> Init (enemies(i)->getLoc().x, enemies(i)->getLoc().y, 2,2,50,41,1,20,50)
            PS -> Init (enemies(i)->getLoc().x, enemies(i)->getLoc().y, 2,2,100,grey,1,100,150)
            PS -> Init (enemies(i)->getLoc().x, enemies(i)->getLoc().y, 2,2,100,black,1,100,150)
            new RemoveTheseEnemies, upper (RemoveTheseEnemies) + 1 
            RemoveTheseEnemies (upper (RemoveTheseEnemies)) := i
        end if
    end for
    
    for i : 0 .. upper (RemoveTheseEnemies)
        for j : RemoveTheseEnemies (i) .. upper (enemies) - 1 
            enemies (j) := enemies (j + 1)
        end for
            if (upper(enemies) > 0) then
            new enemies, upper (enemies) - 1
        end if
    end for
    
    PS -> update()
    PS -> draw()
    
    %put "Pre Check!"
    
    for i : 1..upper(walls)
        Player -> checkWallCol(walls(i))    % The gitch!
        for o : 1..upper(enemies)
            enemies(o) -> checkWallCol(walls(i))
        end for
    end for
    
    %put "Post Check!"
        
        
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
        bgImg := Pic.Blur(bgImg,10)
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
    
    if (upper(enemies) = 0) then
        clearLevel()
        result true
    end if
    if (Player -> getHealth() <= 0) then
        clearLevel()
        result false
    end if
    
end loop

end playLoadedLevel
