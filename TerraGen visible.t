
include "AADraw.t"

View.Set("Graphics:1362;702,offscreenonly,nobuttonbar,title:Turing TerraGen - 1362 x 702")
var camX, camY := 0

var rot : real := 45

var darkergrey := RGB.AddColor(0.4,0.4,0.4)
var darkerwhite := RGB.AddColor(0.90,0.90,0.90)
var linecol := RGB.AddColor(0.2,0.2,0.2)



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

var levels : int := 6
var noiseLevel : int := 100

var size,x,y := 3



for i : 1..levels
    size := (size*2)-1
end for


var verts : array 1..size,1..size of real

proc terraRend(totalWidth,totalDepth : int)

var width := totalWidth/x
var depth := totalDepth/y

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
    
for decreasing o : x-1..1
    for decreasing p : y-1..1
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
                pos2.x := (o+q-1)*width
                pos2.z := (p+w-1)*depth
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
        
        if (verts(o,p) > 0) then
            if (verts(o,p) > 200) then
                if (verts(o+1,p+1) < verts(o,p)) then
                    Draw.FillPolygon(xs,ys,4,white)
                else
                    Draw.FillPolygon(xs,ys,4,darkerwhite)
                end if
            else
                if (verts(o+1,p+1) < verts(o,p)) then
                    Draw.FillPolygon(xs,ys,4,darkgrey)
                else
                    Draw.FillPolygon(xs,ys,4,darkergrey)
                end if
            end if
        else
            Draw.FillPolygon(xs,ys,4,blue)
        end if
        
        
        
        Draw.Polygon(xs,ys,4,linecol)
        
    end for
end for
View.Update
Time.DelaySinceLast(1000)
end terraRend


proc terraGen (totalWidth,totalDepth : int)

var lines : flexible array 1..0 of line

if (true) then
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
    verts(2,2) := 400
    verts(3,2) := 0
    verts(1,3) := 400
    verts(2,3) := 0
    verts(3,3) := 400
end if



for i : 1..levels
    var oldX := x
    var oldY := y
    cls
    Draw.FillBox(0,0,maxx,maxy,black)
    terraRend(totalWidth,totalDepth)
    x := (x*2)-1
    y := (y*2)-1
    
    var width := totalWidth/x
    var depth := totalDepth/y
    
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
                verts(o,p) += Rand.Int(-round((levels-i)/levels)*noiseLevel,round((levels-i)/levels)*noiseLevel)
            end if
        end for
    end for
end for

end terraGen

drawCompass()
terraGen(500,500)

var mx,my,mb,lmx,lmy,lmb : int := 0
var lastFrameTime := 0
var chars : array char of boolean
loop
    Input.KeyDown(chars)
    Draw.FillBox(0,0,maxx,maxy,black)
    lmb := mb
    lmx := mx
    lmy := my
    Mouse.Where(mx,my,mb)
    
    
    if (chars(KEY_LEFT_ARROW)) then
        rot += 10
        drawCompass()
        terraRend(500,500)
        lastFrameTime := Time.Elapsed
    View.Update
    end if
    if (chars(KEY_RIGHT_ARROW)) then
        rot += -10
        drawCompass()
        terraRend(500,500)
        lastFrameTime := Time.Elapsed
    View.Update
    end if

    if (mb = 1) then
        camX += mx-lmx
        camY += my-lmy
        drawCompass()
        terraRend(500,500)
        lastFrameTime := Time.Elapsed
        View.Update
    end if

    %Time.DelaySinceLast(15)
    %put Time.Elapsed - lastFrameTime
    %cls
end loop


