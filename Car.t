% Let's drive a car!

View.Set("Graphics:600;400,offscreenonly")
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

proc drawVectorThickLine (a,b : pointer to Vector2, w, c : int)
    Draw.ThickLine(round(a->getX()),round(a->getY()),
    round(b->getX()),round(b->getY()),w,c)
end drawVectorThickLine

class car
    import frameMillis, Vector2, drawVectorThickLine
    export setControls, update, Init
    
    % Controls
    var Gas, Steering : real := 0
    
    % Location
    var Location : pointer to Vector2
    
    % Local velocity
    var Velocity : pointer to Vector2
    
    var Rotation : real := 0
    
    procedure Init (Vel, Loc : pointer to Vector2, rot : real) 
        Location := Loc
        Velocity := Vel
        Rotation := rot
    end Init
    
    procedure setControls (gas,steering : real)
        Gas := gas
        Steering := steering
    end setControls
    
    procedure update ()
        
        Draw.FillOval(round(Location -> getX()), round(Location -> getY()), 10, 10, red)
        drawVectorThickLine(Location -> RotateD(Rotation,Location), Location -> AddDir (0,100) -> RotateD(Rotation, Location),5,black)
        Rotation += Steering*100*(frameMillis/1000)
        
        var GlobalPower : pointer to Vector2 := Location -> Multiply(1)
    end update
    
end car

var PlayerCar : pointer to car

new car, PlayerCar

var LastFrame : int :=0

var loc, vel : pointer to Vector2

new Vector2, vel
new Vector2, loc

PlayerCar -> Init(vel,loc,0)

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
        H += 1
    end if
     if chars (KEY_LEFT_ARROW) then
        H -= 1
    end if
    
    
    PlayerCar -> update()
    PlayerCar -> setControls(V,H)
    
    View.Update()
    cls()
    
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
end loop
