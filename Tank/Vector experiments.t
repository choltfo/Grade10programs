class Vector2
    
    export (x,y,RotateD,getX,getY,Set,SetX,SetY,Multiply,AddDir,Add,Subtract,normalize,getMag,getNormal,dotProduct)
    
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
    
    function dotProduct (b : pointer to Vector2) : real
        result (x*b->getX())+(y*b->getY())
    end dotProduct
    
    function getMag () : real
        result sqrt(x**2 + y**2)
    end getMag
    
    procedure normalize ()
        var mag : real := getMag()
        x := x/mag
        y := y/mag
    end normalize
    
    % (r - d1) / (d2-d1) = t
    % Probably best used as A -> Subtract (B) -> getNormal()
    
    function getNormal (zero : pointer to Vector2) : pointer to Vector2
        var r : pointer to Vector2 := RotateD(90,zero)
        r -> normalize()
        result r
    end getNormal
    
end Vector2

var zero : pointer to Vector2
new Vector2, zero

var r : real := 5           % The radius of the ball

var c1 : pointer to Vector2 % The current postion of the ball
new Vector2, c1
c1 -> Set(50,50)

var c2 : pointer to Vector2 % The next position of the ball
new Vector2, c2
c2 -> Set(100,0)

var p1 : pointer to Vector2 % End one of the wall
new Vector2, p1
p1 -> Set(0,0)

var p2 : pointer to Vector2 % End two of the wall
new Vector2, p2
p2 -> Set(100,100)

var n : pointer to Vector2 := p1 -> Subtract(p2) -> getNormal(zero)

var d1 : real := abs(p1 -> Subtract(c1) -> dotProduct(n))
var d2 : real := abs(p2 -> Subtract(c2) -> dotProduct(n))

put d1
put d2
put (r - d1) / (d2-d1)


        
        
        
