
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


module Vectors3
    import Vector3
    export Add, Subtract, RotateD
    function Add(a, b : Vector3) : Vector3
        var res : Vector3
        res.x := a.x + b.x
        res.y := a.y + b.y
        res.z := a.z + b.z
        result res
    end Add
    
    function Subtract(a, b : Vector3) : Vector3
        var res : Vector3
        res.x := a.x - b.x
        res.y := a.y - b.y
        res.z := a.z - b.z
        result res
    end Subtract
    
    function RotateD (a, c, r : Vector3) : Vector3
        var res : Vector3
        %res.x := ((a.x-o.x)*cosd(theta))-((a.y-o.y)*(sind(theta))) + (o.x)
        %res.y := ((a.x-o.x)*sind(theta))+((a.y-o.y)*(cosd(theta))) + (o.y)
        
        res.x := ((a.x-c.x)*cosd(r.y))-((a.z-c.z)*(sind(r.y))) + (c.x)
        res.z := ((a.x-c.x)*sind(r.y))+((a.z-c.z)*(cosd(r.y))) + (c.z)
        res.y := a.y
        result res
    end RotateD
end Vectors3


