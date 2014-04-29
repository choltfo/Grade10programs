% The non-object oriented Vectors system

type Vector2 : record
    x : real
    y : real
end record

module Vector
    import Vector2
    export Multiply, Add, AddDir, Subtract, RotateD, getMag, getSqrMag, normalize
    
    function * Multiply (v : Vector2, newMag : real) : Vector2
        var res : Vector2
        res.x := v.x * newMag
        res.y := v.y * newMag
        result res
    end Multiply
    
    function Add (a, b : Vector2) : Vector2
        var res : Vector2
        res.x := a.x+b.x
        res.y := a.y+b.y
        result res
    end Add
    
    function * AddDir (a:Vector2,x,y:real) : Vector2
        var res : Vector2
        res.x := a.x+x
        res.y := a.y+y
        result res
    end AddDir
    
    function * Subtract (a,b : Vector2) : Vector2
        var res : Vector2
        res.x := a.x-b.x
        res.y := a.y-b.y
        result res
    end Subtract
    
    function RotateD (a,o:Vector2,theta:real) : Vector2
        var res : Vector2
        
        res.x := ((a.x-o.x)*cosd(theta))-((a.y-o.y)*(sind(theta))) + (o.x)
        res.y := ((a.x-o.x)*sind(theta))+((a.y-o.y)*(cosd(theta))) + (o.y)
        
        /*NewVec -> Set(
        ((x- (o-> getX()) )*cosd(theta))-((y- (o-> getY()) )*(sind(theta))) + (o-> getX()),
        ((x- (o-> getX()) )*sind(theta))+((y- (o-> getY()) )*cosd(theta)) + (o-> getY())
        )*/
        
        result res
    end RotateD
    
    function getMag (a : Vector2) : real
        result sqrt(a.x**2 + a.x**2)
    end getMag
    
    function getSqrMag (a : Vector2) : real
        result (a.x**2 + a.y**2)
    end getSqrMag
    
    function normalize (a : Vector2) : Vector2
        var res : Vector2
        var mag : real := getMag(a)
        res.x := a.x/mag
        res.y := a.y/mag
        result res
    end normalize
    
end Vector

proc testRotation()
    var a : Vector2
    var o : Vector2

    a.x := 100
    a.y := 100
    
    o.x := 200
    o.y := 200
    View.Set("offscreenonly")
    loop
        a := Vector.RotateD(a,o,10)
        cls()
        Draw.FillOval(round(a.x),round(a.y),5,5,red)
        View.Update()
        delay(10)
    end loop
end testRotation

%testRotation()

var zero : Vector2
zero.x := 0
zero.y := 0


function realBetween(a,x,y : real) : boolean
    
    if (x>y) then
        result realBetween(a,y,x)
    end if
    
    result a > x and a < y
    
end realBetween

/*
This finds the collision between (a1,b1) and (a2,b2). NOT SAFE: Can crash if not called on checked vars.
*/
function getVectorCollision (s1,e1,s2,e2 : Vector2) : Vector2
    var x,y : real := 0
    var foundX : boolean := false
    var res : Vector2
    
    if (s1.x not=e1.x) then  % The line is not vertical
        
        var m1 : real := (s1.y - e1.y) / (s1.x - e1.x)
        var a1 : real := s1.y - (s1.x* m1)
        var m2,a2 : real := 0
        
        if (s2.x = e2.x) then
            x := s2.x
            foundX := true
        else
            m2 := (s2.y - e2.y) / (s2.x - e2.x)
            a2 := s2.y - (s2.x * m2)
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
        var m2 : real := (s2.y - e2.y) / (s2.x - e2.x)
        
        var a2 : real := s2.y - (s2.x * m2)
        x := s1.x   % Line 1 is vertical, subsequently, we know where the point's X is.
        y := (m2*x)+a2
    end if
    
    res.x := x
    res.y := y
    result res
    
end getVectorCollision

function doVectorsCollide (s1,e1,s2,e2 : Vector2) : boolean
    if (s1.x not=e1.x) then  % The line is not vertical
        
        var m1 : real := (s1.y - e1.y) / (s1.x - e1.x)
        
        if (s2.x = e2.x) then
            result true         % One is vertical, the other is not. Thusly do they touch.
        end if
        
        var m2 : real := (s2.y - e2.y) / (s2.x - e2.x)
        var a2 : real := s2.y - (s2.x * m2)
        
        result (m1 not= m2) % lines are not parallel?
        
    else                                % Line 1 is vertical
        result (s2.x = e2.x)    % Is Line 2 vertical also?
    end if
end doVectorsCollide


proc drawVectorThickLine (a,b : Vector2, w, c : int)
    Draw.ThickLine(round(a.x),round(a.y),
        round(b.x),round(b.y),w,c)
end drawVectorThickLine

proc drawVectorBox (a,b,c,d : Vector2, col, o : int)
    Draw.Line(round(a.x),round(a.y),round(b.x),round(b.y),o)
    Draw.Line(round(a.x),round(a.y),round(d.x),round(d.y),o)
    Draw.Line(round(b.x),round(b.y),round(c.x),round(c.y),o)
    Draw.Line(round(c.x),round(c.y),round(d.x),round(d.y),o)
end drawVectorBox