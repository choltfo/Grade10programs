% Antialiased drawing methods. I hope.


type Vector3 : record
    x : real
    y : real
    z : real
end record

type Vector2 : record
    x : real
    y : real
end record

var zero2 : Vector2
zero2.x := 0
zero2.y := 0
var zero3 : Vector3
zero3.x := 0
zero3.y := 0
zero3.z := 0

module Vectors2
    import Vector2, zero2
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
    
end Vectors2

module AADraw
    proc Line (x1,y1,x2,y2 : real)
        var steep : boolean := abs(y1-y2) > abs(x1-x2) % Is the line steeper (/) than 45 degrees?
        
        if (x1 > x2) then
            Line(x2,y2,x1,y1)
            return
        end if
        
        if steep then
            
        else
            for x : round(x1)..round(x2)
                % Select the two nearest pixels to the point encroached by the line at (x,y).
                var h := ceil(x1)
                
                
            end for
        end if
        
        
    end Line
end AADraw

