class Vector2
    
    export (x,y,RotateD,getX,getY,Set,SetX,SetY,Multiply,AddDir,Add,Subtract,normalize,getMag,getNormal,dotProduct,Normalize)
    
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
    
    function Normalize () : pointer to Vector2
        var r : pointer to Vector2
        new Vector2, r
        r := r -> AddDir (x,y)
        r -> normalize()
        result r
    end Normalize
    
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


proc drawVectorThickLine (a,b : pointer to Vector2, w, c : int)
    Draw.ThickLine(round(a->getX()),round(a->getY()),
        round(b->getX()),round(b->getY()),w,c)
end drawVectorThickLine

function vectorPtInRect (p,a,b : pointer to Vector2) : boolean
    result true 
end vectorPtInRect

View.Set("offscreenonly")

var x,y,b : int := 0

loop
    Mouse.Where(x,y,b)
    var r : real := 0           % The radius of the ball
    
    var c1 : pointer to Vector2 % The current postion of the ball
    new Vector2, c1
    c1 -> Set(x-100,y-100)
    
    var c2 : pointer to Vector2 % The next position of the ball
    new Vector2, c2
    c2 -> Set(100,0)
    
    var p1 : pointer to Vector2 % End one of the wall
    new Vector2, p1
    p1 -> Set(1000,1000)
    
    var p2 : pointer to Vector2 % End two of the wall
    new Vector2, p2
    p2 -> Set(-100,-100)
    
    var n : pointer to Vector2 := p1 -> Subtract(p2) -> getNormal(zero)
    
    var d1 : real := abs(p2 -> Subtract(c1) -> dotProduct(n))
    var d2 : real := abs(p2 -> Subtract(c2) -> dotProduct(n))
    
    var t : real := 0
    
    if (d1 = d2) then
        if (c1->Subtract(c2)-> Normalize() = p1->Subtract(p2)-> Normalize()) then
            t := 0.5
        else
        
        end if
    else
        %t := (r - d1) / (d2-d1)
        t := (-d1) / (d2-d1)
    end if
    
    put "p1-p2*t                ", p1->Subtract(p2)->Multiply(t)->getX(), ", ",p2->Subtract(p1)->Multiply(t)->getY()
    put "p1-p2                  ", p1->Subtract(p2)->getX(), ", ",p2->Subtract(p1)->getY()
    put "p1+p1+((p2-p1)*t)      ", p1->Add(p1->Add(p2->Subtract(p1)->Multiply(t)))->getX(), ", ", p1->Add(p1->Add(p2->Subtract(p1)->Multiply(t)))->getY()
    
    var hit : pointer to Vector2 := c1->Add(c1->Add(c2->Subtract(c1)->Multiply(t)))
    
    put "Distance from c1 to p  ", d1
    put "Distance from c2 to p  ", d2
    put "Scalar of collision    ", t
    put "Length of p            ", p1 -> Subtract(p2) -> getMag()
    put "Length of c            ", c1 -> Subtract(c2) -> getMag()
    put "Collision location     ", hit -> getX(), ", ", hit -> getY()
    
    drawVectorThickLine(p1->AddDir(100,100),p2->AddDir(100,100),3,black)
    drawVectorThickLine(c1->AddDir(100,100),c2->AddDir(100,100),3,red)
    Draw.FillOval(floor(hit->AddDir(100,100) -> getX()),floor(hit->AddDir(100,100) -> getY()),5,5,blue)
    Draw.Line(100,100,100,maxy,black)
    Draw.Line(100,100,maxx,100,black)
    View.Update()
    cls()
    delay(10)
end loop




