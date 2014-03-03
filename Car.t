% Let's drive a car!

View.Set("Graphics:900;600,offscreenonly")
var chars : array char of boolean

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
        x := Y
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

class car
    import frameMillis, Vector2, drawVectorThickLine,zero
    export setControls, update, Init
    
    % Controls
    var Gas, Steering : real := 0
    var maxSteer : real := 10 % Degrees of max steering
    
    % Location
    var Location : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    % Local friction
    var Fric : pointer to Vector2
    
    
    var Rotation : real := 0
    
    procedure Init (Vel, Loc, Fri : pointer to Vector2, rot : real) 
        Location := Loc
        Velocity := Vel
        Rotation := rot
        Fric     := Fri
    end Init
    
    procedure setControls (gas,steering : real)
        Gas := gas*(frameMillis/1000)
        Steering := (steering*maxSteer)
        
    end setControls
    
    procedure update ()
        
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 10, 10, red)
        drawVectorThickLine(Location, Location -> AddDir (0,100) -> RotateD(Rotation+Steering, Location),5,green)
        drawVectorThickLine(Location, Location -> AddDir (0,100) -> RotateD(Rotation, Location),2,black)
        
        var RelPos, NewSpeed : pointer to Vector2
        new Vector2, RelPos
        new Vector2, NewSpeed
        
        % Friction
        Velocity -> SetX(Velocity -> getX() * (1 - Fric -> getX()))
        Velocity -> SetY(Velocity -> getY() * (1 - Fric -> getY()))
        
        NewSpeed -> Set(0,Gas)
        NewSpeed := NewSpeed -> RotateD(Steering,zero)
        
        % Add extra speed
        Velocity := Velocity -> Add(NewSpeed)
        
        % Rotate to get relative new position
        RelPos := Velocity -> RotateD(Rotation, zero)
        
        Location := Location -> Add (RelPos)
        
        put (Gas)
        
        Rotation += Steering*(frameMillis/1000)
        
        
        
        %   Okay, so here's the plan:
        %   So, the new position after movment has to be the 
        %   CurrentPositon.x + (cos(steering)*speed) Rotated by rotation
        %   CurrentPositon.y + (sin(steering)*speed) Rotated by rotation
        
        
    end update
    
end car

var PlayerCar : pointer to car

new car, PlayerCar

var LastFrame : int :=0

var loc, vel,fric : pointer to Vector2

new Vector2, vel
new Vector2, loc
new Vector2, fric

fric ->Set(0.1,0.1)
loc -> Set(100,100)

PlayerCar -> Init(vel,loc,fric,0)

loop
    
    Input.KeyDown (chars)
    
    var H,V : int := 0
    
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
    
    PlayerCar -> setControls(V,H)
    PlayerCar -> update()
    
    View.Update()
    cls()
    
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
end loop
