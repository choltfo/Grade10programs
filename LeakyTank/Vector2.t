class Vector2
    
    export (x,y,RotateD,getX,getY,Set,SetX,SetY,Multiply,AddDir,Add,Subtract,getSqrMag)
    
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
    
    % (r - d1) / (d2-d1) = t
    % Probably best used as A -> Subtract (B) -> getNormal()
    
    function getNormal () : pointer to Vector2
        
    end getNormal
    
    function getMag () : real
        result sqrt(x**2 + y**2)
    end getMag
    
    function getSqrMag () : real
        result (x**2 + y**2)
    end getSqrMag
    
    procedure normalize ()
        var mag : real := getMag()
        x := x/mag
        y := y/mag
    end normalize
    
end Vector2


var zero : pointer to Vector2
new Vector2, zero

function realBetween(a,x,y : real) : boolean
    
    if (x>y) then
        result realBetween(a,y,x)
    end if
    
    result a > x and a < y
    
end realBetween

/*
This finds the collision between (a1,b1) and (a2,b2). NOT SAFE: Can crash if not called on checked vars.
*/
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
            if (m1-m2 = 0) then
                % Lines are parallel, and we're screwed.
            else
                x := (a2-a1)/(m1-m2)
                y := (m1*x)+a1
            end if
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

proc drawVectorBox (a,b,c,d : pointer to Vector2, col, o : int)
    Draw.Line(round(a->getX()),round(a->getY()),round(b->getX()),round(b->getY()),o)
    Draw.Line(round(a->getX()),round(a->getY()),round(d->getX()),round(d->getY()),o)
    Draw.Line(round(b->getX()),round(b->getY()),round(c->getX()),round(c->getY()),o)
    Draw.Line(round(c->getX()),round(c->getY()),round(d->getX()),round(d->getY()),o)
end drawVectorBox