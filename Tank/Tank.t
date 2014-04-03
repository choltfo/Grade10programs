% Let's drive a Tank!

View.Set("Graphics:900;600,offscreenonly")

var Font1 := Font.New ("Impact:72")
var Font2 := Font.New ("Arial:18")

var chars : array char of boolean
var formerChars : array char of boolean

var mX, mY, mB, mLB : int := 0      % Mouse vars
var hasWaited := false
loop    % Title screen loop
    Mouse.Where(mX, mY, mB)
    Font.Draw("The Tank Game",round((maxx/2)-(Font.Width("The Tank Game",Font1)/2)),maxy-100,Font1,black)
    Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),maxy-200,Font2,black)
    Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),maxy-220,Font2,black)
    Font.Draw("R to reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),maxy-240,Font2,black)
    
    View.Update()
    if (not hasWaited) then 
        delay(2000)
    else
        Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",Font2)/2)),maxy-300,Font2,black*(round(Time.Elapsed() / 200)) mod 2)
    end if
    
    hasWaited := true
    
    exit when mB = 1 and mLB not=1
    mLB := mB
end loop

var frameMillis : int := 10

class Vector2
    
    export (x,y,RotateD,getX,getY,Set,SetX,SetY,Multiply,AddDir,Add)
    
    var x,y : real := 0
    
    procedure Set (X,Y : real)
        x := X
        y := Y
    end Set
    
    procedure SetX (X : real)
        x := X
    end SetX
    
    procedure SetY (Y : real)
        y := Y
    end SetY
    
    function getX () :real
        result x
    end getX
    
    function getY () :real
        result y
    end getY
    
    function Multiply (newMag : real) : pointer to Vector2
        var Output : pointer to Vector2
        new Vector2, Output
        Output -> Set(x*newMag,y*newMag)
        result Output
    end Multiply
    
    function Add (b : pointer to Vector2) : pointer to Vector2
        var Output : pointer to Vector2
        new Vector2, Output
        Output -> Set(x + (b -> getX()), y + (b -> getY()))
        result Output
    end Add
    
    function AddDir (h,v : real) : pointer to Vector2
        var Output : pointer to Vector2
        new Vector2, Output
        Output -> Set(x + h, y + v)
        result Output
    end AddDir
    
    function Subtract (b : pointer to Vector2) : pointer to Vector2
        var Output : pointer to Vector2
        new Vector2, Output
        Output -> Set(x - (b -> getX()), y - (b -> getY()))
        result Output
    end Subtract
    
    function RotateD (theta : real, o : pointer to Vector2) : pointer to Vector2
        
        var NewVec : pointer to Vector2
        new Vector2, NewVec
        
        NewVec -> Set( ((x- (o-> getX()) )*cosd(theta))-((y- (o-> getY()) )*(sind(theta))) + (o-> getX()), ((x- (o-> getX()) )*sind(theta))+((y- (o-> getY()) )*cosd(theta)) + (o-> getY()))
        
        result NewVec
    end RotateD
end Vector2


var zero : pointer to Vector2
new Vector2, zero

proc drawVectorThickLine (a,b : pointer to Vector2, w, c : int)
    Draw.ThickLine(round(a->getX()),round(a->getY()),
        round(b->getX()),round(b->getY()),w,c)
end drawVectorThickLine

proc drawVectorBox (a,b,c,d : pointer to Vector2, col, o : int)
    Draw.Line(round(a->getX()),round(a->getY()),round(b->getX()),round(b->getY()),o)
    Draw.Line(round(a->getX()),round(a->getY()),round(d->getX()),round(d->getY()),o)
    Draw.Line(round(b->getX()),round(b->getY()),round(c->getX()),round(c->getY()),o)
    Draw.Line(round(c->getX()),round(c->getY()),round(d->getX()),round(d->getY()),o)
end drawVectorBox


class Wall
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox
    export Init, draw
    
    
    var p1, p2 : pointer to Vector2
    
    proc Init (e, s : pointer to Vector2)
        p1 := e
        p2 := s
    end Init
    
    proc draw
        drawVectorThickLine (p1,p2,5,black)
    end draw
    
end Wall

class Bullet
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox, Wall
    export update, Init, checkWallCol
    
    % Location
    var Location : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    procedure Init (Loc, Vel: pointer to Vector2, rot,speed:real)
        
        new Vector2, Location
        Velocity := Vel
        
        Location := Loc
        Velocity := Velocity -> AddDir(cosd(rot)*speed,sind(rot)*speed)
    end Init
    
    function update () : boolean
        Location := Location -> Add(Velocity)
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 2, 2, black)
        
        result Location->getX() < maxx and Location->getX() > 0 and Location->getY() < maxy and Location->getY() > 0
        
    end update
    
    function checkWallCol (w : pointer to Wall) : boolean
        result false
    end checkWallCol
    
end Bullet

class Tank
    import frameMillis, Vector2, drawVectorThickLine,zero,Bullet,drawVectorBox, Font2
    export setControls, update, Init, Fire, Reload, CanFire
    
    var health := 100
    
    % The gun
    var maxAmmo, curAmmo : int := 10
    var damage := 10
    
    var lastReload := 0
    var reloadMillis := 2500
    
    % Controls
    var Gas, Steering : real := 0
    var maxSteer : real := 90 % Degrees of max steering
    var maxThrottle:real:= 3
    
    
    % Location
    var Location : pointer to Vector2
    
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
        
        
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(-10,20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,-20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,20) -> RotateD(Rotation, Location), Location -> AddDir(-10,-20) -> RotateD(Rotation, Location),1,black)
        
        Draw.Fill(floor(Location -> getX()),floor(Location -> getY()),green,black)
        
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
        
        render()
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
        
        %   Okay, so here's the plan:
        %   So, the new position after movment has to be the 
        %   CurrentPositon.x + (cos(steering)*speed) Rotated by rotation
        %   CurrentPositon.y + (sin(steering)*speed) Rotated by rotation
        
        if (Location -> getX() > maxx) then
            Location -> SetX(maxx-1)
        end if
        
        if (Location -> getY() > maxy) then
            Location -> SetY(maxy-1)
        end if
        
        if (Location -> getX() < 0) then
            Location -> SetX(1)
        end if
        
        if (Location -> getY() < 0) then
            Location -> SetY(1)
        end if
        
    end update
    
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
        
        Player -> setControls(V,H,L)
        Player -> update(mX, mY, mB)
        
    end if
    
    for i : 1..upper(walls) 
        walls(i) -> draw()
    end for
    
    var RemoveThese : flexible array 0..-1 of int
    
    for i : 1..upper(bullets) 
        if (bullets(i) -> update() not= true) then
            new RemoveThese, upper (RemoveThese) + 1 
            RemoveThese (upper (RemoveThese)) := i - upper (RemoveThese) 
        end if
        for o : 1..upper(walls)
            if ( bullets(i) -> checkWallCol(walls(o))) then
                new RemoveThese, upper (RemoveThese) + 1 
                RemoveThese (upper (RemoveThese)) := i - upper (RemoveThese)
                exit
            end if
        end for
    end for
        
    for i : 0 .. upper (RemoveThese)
        
        for j : RemoveThese (i) .. upper (bullets) - 1 
            bullets (j) := bullets (j + 1)
        end for
            new bullets, upper (bullets) - 1
        
    end for
        
    
    
    
    
    View.Update()
    cls()
    
    put (LastFrame + frameMillis) - Time.Elapsed
    
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
    mLB := mB
end loop

