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


function getVectorCollision (s1,e1,s2,e2 : pointer to Vector2) : pointer to Vector2
    var x,y : real := 0
    var foundX : boolean := false
    var res : pointer to Vector2
    
    new Vector2, res
    
    if (s1->getX()not=e1->getX()) then  % The line is not vertical
        
        var m1 : real := (s1 -> getY() - e1 -> getY()) / (s1 -> getX() - e1 -> getX())
        var a1 : real := s1->getY() - (s1->getX() * m1)
        var m2,a2 : real := 0
        
        if (s2->getX() = e2->getX()) then
            x := s2->getX()
            foundX := true
        else
            m2 := (s2 -> getY() - e2 -> getY()) / (s2 -> getX() - e2 -> getX())
            a2 := s2->getY() - (s2->getX() * m2)
        end if
        if (foundX) then
            y := (m1*x)+a1
        else
            x := (a2-a1)/(m1-m2)
            y := (m1*x)+a1
        end if
    else                                % Line 1 is vertical
        var m2 : real := (s2 -> getY() - e2 -> getY()) / (s2 -> getX() - e2 -> getX())
        
        var a2 : real := s2->getY() - (s2->getX() * m2)
        x := s1 -> getX()   % Line 1 is vertical, subsequently, we know where the point's X is.
        y := (m2*x)+a2
    end if
    
    res->Set(x,y)
    result res
    
end getVectorCollision

function doVectorsCollide (s1,e1,s2,e2 : pointer to Vector2) : boolean
    if (s1->getX()not=e1->getX()) then  % The line is not vertical
        
        var m1 : real := (s1 -> getY() - e1 -> getY()) / (s1 -> getX() - e1 -> getX())
        
        if (s2->getX() = e2->getX()) then
            result true         % One is vertical, the other is not. Thusly do they touch.
        end if
        
        var m2 : real := (s2 -> getY() - e2 -> getY()) / (s2 -> getX() - e2 -> getX())
        var a2 : real := s2->getY() - (s2->getX() * m2)
        
        result (m1 not= m2) % lines are not parallel?
        
    else                                % Line 1 is vertical
        result (s2->getX() = e2->getX())    % Is Line 2 vertical also?
    end if
end doVectorsCollide

proc drawVectorThickLine (a,b : pointer to Vector2, w, c : int)
    Draw.ThickLine(round(a->getX()),round(a->getY()),
        round(b->getX()),round(b->getY()),w,c)
end drawVectorThickLine

function vectorPtInRect (p,a,b : pointer to Vector2) : boolean
    result true 
end vectorPtInRect


var x,y,b : int := 0
View.Set("offscreenonly")

loop
    Mouse.Where(x,y,b)
    
    var c1 : pointer to Vector2 % The current postion of the ball
    new Vector2, c1
    c1 -> Set(maxx-200,maxy-200)
    
    var c2 : pointer to Vector2 % The next position of the ball
    new Vector2, c2
    c2 -> Set(x,y)
    
    var p1 : pointer to Vector2 % End one of the wall
    new Vector2, p1
    p1 -> Set(maxx,0)
    
    var p2 : pointer to Vector2 % End two of the wall
    new Vector2, p2
    p2 -> Set(0,maxy)
    
    drawVectorThickLine (p1,p2,5,red)
    drawVectorThickLine (c1,c2,5,green)
    
    var hit : pointer to Vector2 := getVectorCollision(c1,c2,p1,p2)
    Draw.FillOval(floor(hit -> getX()),floor(hit -> getY()),10,10,blue)
    View.Update()
    cls()
end loop
