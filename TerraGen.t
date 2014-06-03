
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

function worldToScreen (pos : Vector3) : Vector2
    var point : Vector2
    
    point.x := pos.x
    point.y := pos.z
    
    point := Vectors2.RotateD(point, zero2, 30)
    
    point.x := 150 + point.x
    point.y := pos.y + 20 + point.y
    
    result point
    
end worldToScreen

var zero : Vector2 := worldToScreen(zero3)

proc drawCompass()
    var X : Vector3 % To remain unused
    X.x := 100
    X.y := 0
    X.z := 0
    var Y : Vector3 % To remain unused
    Y.x := 0
    Y.y := 100
    Y.z := 0
    var Z : Vector3 % To remain unused
    Z.x := 0
    Z.y := 0
    Z.z := 100
    var x : Vector2 := worldToScreen(X)
    var y : Vector2 := worldToScreen(Y)
    var z : Vector2 := worldToScreen(Z)

    Draw.Line(round(zero.x),round(zero.y),round(x.x),round(x.y),red)
    Draw.Line(round(zero.x),round(zero.y),round(y.x),round(y.y),green)
    Draw.Line(round(zero.x),round(zero.y),round(z.x),round(z.y),blue)
end drawCompass




type line : record
    a,b : Vector3
    col : int
end record

proc terraGen (levels,width,depth : int)
    var lines : flexible array 1..0,1..0 of line
    var verts : flexible array 1..2,1..2 of real
    
    verts(1,1) := 100
    verts(2,1) := 0
    verts(1,2) := 0
    verts(2,2) := 400
    
    var x,y : int := 2
    
    for i : 1..levels
        var oldX := upper(verts, 1)
        var oldY := upper(verts, 2)
        x := (x*2)-1
        y := (y*2)-1
        
        for decreasing o :  oldX..1
            for decreasing p : oldY..1
                verts((2*o)-1,(2*p)-1) := verts(o,p)
            end for
        end for
        
        for o : 1..upper(verts, 1)
            for p : 1..upper(verts, 2)
                if not(o mod 2 = 1 and p mod 2 = 1) then
                    verts(o,p) := (verts(o,p-1)+verts(o,p+1)+verts(o-1,p)+verts(o+1,p))/4
                end if
            end for
        end for
    end for
    
    new lines, upper(verts,1)-1,upper(verts,2)-1
    
    for o : 1..upper(lines,1)
        for p : 1..upper(lines,2)
            lines(o,p).a.x := width * (o-1)
            lines(o,p).a.z := depth * (o-1)
            lines(o,p).a.y := verts(o+1,p+1)
            
            lines(o,p).b.x := width * (o)
            lines(o,p).b.z := depth * (o)
            lines(o,p).b.y := verts(o,p)
            
            lines(o,p).col := black
        end for
    end for
    
    for o : 1..upper(lines,1)
        for p : 1..upper(lines,2)
            var a,b : Vector2
            a := worldToScreen(lines(o,p).a)
            b := worldToScreen(lines(o,p).b)
            
            Draw.Line(round(a.x),round(a.y),round(b.x),round(b.y),lines(o,p).col)
        end for
    end for
    
end terraGen

drawCompass()

terraGen(1,20,20)


