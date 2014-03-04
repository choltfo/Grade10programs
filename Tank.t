% Let's drive a Tank!

View.Set("Graphics:900;600,offscreenonly")
var chars : array char of boolean
var formerChars : array char of boolean

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

class Bullet
    import frameMillis, Vector2, drawVectorThickLine,zero,drawVectorBox
    export update, Init
    
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
    
end Bullet


class Tank
    import frameMillis, Vector2, drawVectorThickLine,zero,Bullet,drawVectorBox
    export setControls, update, Init, Fire
    
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
    
    procedure Init (Vel, Loc, Fri : pointer to Vector2, rot : real) 
        Location := Loc
        Velocity := Vel
        Rotation := rot
        Fric     := Fri
    end Init
    
    procedure setControls (gas,steering,L : real)
        Gas := gas*(frameMillis/1000) * maxThrottle
        Steering := (steering*maxSteer)
        turretRotation += L*(frameMillis/1000)*100

    end setControls
    
    proc render()
        
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(10,20) -> RotateD(Rotation, Location), Location -> AddDir(-10,20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,-20) -> RotateD(Rotation, Location), Location -> AddDir(10,-20) -> RotateD(Rotation, Location),1,black)
        drawVectorThickLine(Location -> AddDir(-10,20) -> RotateD(Rotation, Location), Location -> AddDir(-10,-20) -> RotateD(Rotation, Location),1,black)
        
        drawVectorBox(Location -> AddDir(1,0) -> RotateD(turretRotation+Rotation, Location),
            Location -> AddDir(-1,0) -> RotateD(turretRotation+Rotation, Location),
            Location -> AddDir(-1,10) -> RotateD(turretRotation+Rotation, Location),
            Location -> AddDir(1,10) -> RotateD(turretRotation+Rotation, Location),
            black,black)
        
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 3, 3, green)
        Draw.Oval(round(Location -> getX()), round(Location -> getY()), 3, 3, black)
        
    end render
    
    procedure update ()
        render()
        var RelPos, NewSpeed : pointer to Vector2
        new Vector2, RelPos
        new Vector2, NewSpeed
        
        % Friction
        % Velocity -> SetX(Velocity -> getX() * (1 - Fric -> getX()))
        % Velocity -> SetY(Velocity -> getY() * (1 - Fric -> getY()))
        Velocity := Velocity -> Multiply(0.99)
        
        NewSpeed -> Set(0,Gas)                          %Okay, so the idea is, create a vector with
        NewSpeed := NewSpeed -> RotateD(Steering*Gas/maxThrottle,zero->AddDir(0, Gas) )  %the magnitude of the Gas, and rotate it by steering.
        
        % Add extra speed
        Velocity := Velocity -> Add(NewSpeed)
        
        % Rotate to get relative new position
        RelPos := Velocity -> RotateD(Rotation, zero)
        
        Location := Location -> Add (RelPos)
        
        Rotation += Steering*(frameMillis/1000)
        
        
        
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
    
    function Fire() : pointer to Bullet
        var Bul : pointer to Bullet
        new Bullet, Bul
        
        Bul -> Init(Location, zero, Rotation+90+turretRotation, 10)
        
        result Bul
    end Fire
    
end Tank


var Player : pointer to Tank

new Tank, Player

var LastFrame : int :=0

var loc, vel,fric : pointer to Vector2

new Vector2, vel
new Vector2, loc
new Vector2, fric

fric ->Set(0.1,0.1)
loc -> Set(100,100)

Player -> Init(vel,loc,fric,0)

var bullets : flexible array 1..0 of pointer to Bullet

loop
    formerChars := chars
    Input.KeyDown (chars)
    
    var H,V,L : int := 0
    
    if chars (KEY_UP_ARROW) then
        V += 1
    end if
    if chars (KEY_DOWN_ARROW) then
        V -= 1
    end if
    if chars (KEY_RIGHT_ARROW) then
        H -= 1
    end if
    if chars (KEY_LEFT_ARROW) then
        H += 1
    end if
    if chars ('a') then
        L += 1
    end if
    if chars ('f') then
        L -= 1
    end if
    if chars (chr(ORD_SPACE)) and not formerChars (chr(ORD_SPACE)) then
        new bullets, upper(bullets)+1
        bullets(upper(bullets)) := Player -> Fire()%SHOOT FROM THE TANK!
    end if
    
    Player -> setControls(V,H,L)
    Player -> update()
    
    var RemoveThese : flexible array 0..-1 of int
    
    for i : 1..upper(bullets)
        if (bullets(i) -> update() not= true) then
            new RemoveThese, upper (RemoveThese) + 1 
            RemoveThese (upper (RemoveThese)) := i - upper (RemoveThese) 
        end if
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
end loop
