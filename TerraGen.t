
include "AADraw.t"

View.Set("Graphics:max;max,offscreenonly")
var camX, camY := 0

var rot : real := 45


function worldToScreen (pos : Vector3) : Vector2
    var point : Vector2
    
    point.x := pos.x
    point.y := pos.z
    
    point := Vectors2.RotateD(point, zero2, rot)
    
    point.x := round(maxx/2) + point.x + camX
    point.y := pos.y + 20 + point.y + camY
    
    result point
    
end worldToScreen


proc drawCompass()

var zero : Vector2 := worldToScreen(zero3)
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
    zero := worldToScreen(zero3)

    Draw.Line(round(zero.x),round(zero.y),round(x.x),round(x.y),red)
    Draw.Line(round(zero.x),round(zero.y),round(y.x),round(y.y),green)
    Draw.Line(round(zero.x),round(zero.y),round(z.x),round(z.y),blue)
end drawCompass




type line : record
    a,b : Vector3
    col : int
end record

var levels : int := 5

var size,x,y := 3



for i : 1..levels
    size := (size*2)-1
end for


var verts : flexible array 1..size,1..size of real

proc terraGen ()
    var lines : flexible array 1..0 of line
    
    if (false) then
    verts(1,1) := 0
    verts(2,1) := 0
    verts(3,1) := 0
    verts(1,2) := 0
    verts(2,2) := 400
    verts(3,2) := 0
    verts(1,3) := 0
    verts(2,3) := 0
    verts(3,3) := 0
    else
    verts(1,1) := 400
    verts(2,1) := 0
    verts(3,1) := 400
    verts(1,2) := 0
    verts(2,2) := -100
    verts(3,2) := 0
    verts(1,3) := 400
    verts(2,3) := 0
    verts(3,3) := 400
    end if
    
    
    
    for i : 1..levels
        var oldX := x
        var oldY := y
        x := (x*2)-1
        y := (y*2)-1
        
        for decreasing o :  oldX..1
            for decreasing p : oldY..1
                verts((2*o)-1,(2*p)-1) := verts(o,p)
            end for
        end for
        
        % Populate centers
        % 10101
        % 0X0X0
        % 10101
        % 0X0X0
        % 10101
        for o : 1..x
            for p : 1..y
                if o mod 2 = 0 and p mod 2 = 0 then
                    verts(o,p) := (verts(o+1,p+1)+verts(o+1,p-1)+verts(o-1,p+1)+verts(o-1,p-1))/4
                end if
            end for
        end for
        
        % Populate sides
        % 1X1X1
        % X1X1X
        % 1X1X1
        % X1X1X
        % 1X1X1
        for o : 1..x
            for p : 1..y
                if (o mod 2 = 0) xor (p mod 2 = 0) then 
                    %put o," ",p
                    if (o = 1) then
                        verts(o,p) := (verts(o,p-1)+verts(o,p+1)+verts(o+1,p))/3
                    elsif (o = x) then
                        verts(o,p) := (verts(o,p-1)+verts(o,p+1)+verts(o-1,p))/3
                    elsif (p = y) then
                        verts(o,p) := (verts(o,p-1)+verts(o-1,p)+verts(o+1,p))/3
                    elsif (p = 1) then
                        verts(o,p) := (verts(o,p+1)+verts(o-1,p)+verts(o+1,p))/3
                    else
                        verts(o,p) := (verts(o,p-1)+verts(o,p+1)+verts(o-1,p)+verts(o+1,p))/4
                    end if
                    verts(o,p) += Rand.Int(-(levels-i)*10,(levels-i)*10)
                end if
            end for
        end for
    end for
    
    /*new lines, (x-1)*(y-1)
    
    for o : 1..upper(lines)
        lines(o).a.x := 
        lines(o).a.z := depth * (o-1)
        lines(o).a.y := verts(o+1,p+1)
            
        lines(o).b.x := width * (p)
        lines(o).b.z := depth * (o)
        lines(o).b.y := verts(o,p)
        
        lines(o).col := black
    end for*/
    
    
    /*for o : 1..upper(lines)
        var a,b : Vector2
        a := worldToScreen(lines(o).a)
        b := worldToScreen(lines(o).b)
        
        Draw.Line(round(a.x),round(a.y),round(b.x),round(b.y),lines(o).col)
    end for*/
    
end terraGen

proc terraRend(width,depth : int)
    for o : 1..x
        for p : 1..y
            var L : Vector3
            L.x := width * (o-1)
            L.z := depth * (p-1)
            L.y := 0
            var P : Vector2 := worldToScreen(L)
            %Draw.Line(round(P.x),round(P.y),round(P.x),round(P.y+verts(o,p)),red)
        end for
    end for
    
    for decreasing o : x-1..2
        for decreasing p : y-1..2
            var pos : Vector3
            pos.x := (o-1)*width
            pos.z := (p-1)*depth
            pos.y := verts(o,p)
            var drawPos : Vector2 := worldToScreen(pos)
            
            var xs : array 1..4 of int := init(0,0,0,0)
            var ys : array 1..4 of int := init(0,0,0,0)
            
            xs(1) := round(drawPos.x)
            ys(1) := round(drawPos.y)
            for q : 0..1
                for w : 0..1
                    var pos2 : Vector3
                    pos2.x := (o+q-2)*width
                    pos2.z := (p+w-2)*depth
                    pos2.y := verts(o+q,p+w)
                    var drawPos2 : Vector2 := worldToScreen(pos2)
                    
                    %xs((q*2)+w+1) := round(drawPos2.x)
                    %ys((q*2)+w+1) := round(drawPos2.y)
                    
                    if (w = 0) then
                        if (q = 0) then
                            xs(1) := round(drawPos2.x)
                            ys(1) := round(drawPos2.y)
                        else
                            xs(2) := round(drawPos2.x)
                            ys(2) := round(drawPos2.y)
                        end if
                    else
                        if (q = 0) then
                            xs(4) := round(drawPos2.x)
                            ys(4) := round(drawPos2.y)
                        else
                            xs(3) := round(drawPos2.x)
                            ys(3) := round(drawPos2.y)
                        end if
                    end if
                    
                    %Draw.Line(round(drawPos.x),round(drawPos.y),round(drawPos2.x),round(drawPos2.y),max(round(drawPos2.x-drawPos.x),round(drawPos.x-drawPos2.x)))
                end for
            end for
            if (verts(o,p) > 200) then
                Draw.FillPolygon(xs,ys,4,white)
            else
                Draw.FillPolygon(xs,ys,4,darkgrey)
            end if
            
            Draw.Polygon(xs,ys,4,grey)
            
        end for
    end for
        
end terraRend
    
drawCompass()
terraGen

var mx,my,mb,lmx,lmy,lmb : int := 0
var lastFrameTime := 0
loop
    
    
    lmb := mb
    lmx := mx
    lmy := my
    Mouse.Where(mx,my,mb)
    drawCompass()
    terraRend(10,10)
    rot += 1
    
    if (mb = 1) then
        camX += mx-lmx
        camY += my-lmy
    end if
    
    %Time.DelaySinceLast(15)
    put Time.Elapsed - lastFrameTime
    lastFrameTime := Time.Elapsed
    View.Update
    cls
    Draw.FillBox(0,0,maxx,maxy,black)
    
end loop


