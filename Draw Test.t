%var x : int := floor((i mod (maxx/50))*50)

var ySplit : int := 50
var yDiff  : int := 10
var xSplit : int := 50
var lineWidth : int:= 0

Draw.FillBox(0, 0, maxx, maxy, white)

for x : 0 .. maxx by xSplit
    for y : 0 .. maxy by ceil(ySplit)
        if (x/(xSplit) mod 2) = (y/(ySplit) mod 2)then
            
            var arrX:array 1..4 of int := init(0,0,0,0)
            var arrY:array 1..4 of int := init(0,0,0,0)
            
            
            arrX(1) := x-xSplit
            arrX(2) := x-xSplit
            arrX(3) := x
            arrX(4) := x
            
            arrY(1) := y-yDiff
            arrY(2) := y-ySplit
            arrY(3) := y - (ySplit-yDiff) - yDiff - yDiff
            arrY(4) := y
            
            Draw.FillPolygon(arrX, arrY, 4, grey)
            
            arrX(1) := x
            arrX(2) := x-xSplit
            arrX(3) := x
            arrX(4) := x+xSplit
            
            arrY(1) := y - (ySplit-yDiff)
            arrY(2) := y-ySplit
            arrY(3) := y - (ySplit-yDiff) - yDiff - yDiff
            arrY(4) := y-ySplit
            
            Draw.FillPolygon(arrX, arrY, 4, darkgrey)
            
            Draw.Line(x-20,y,x+20,y,blue) % just a placeholder
            %Draw.ThickLine(x,y,x,y + ySplit+yDiff,5,green)
            
            Draw.ThickLine(x,y +(ySplit-yDiff),x,y - (ySplit-yDiff),lineWidth,black) % Primary vertical
            
            Draw.ThickLine(x,y,x+xSplit,y-yDiff,lineWidth,green)
            Draw.ThickLine(x,y,x-xSplit,y-yDiff,lineWidth,green)
            Draw.ThickLine(x,y - (ySplit-yDiff),x+xSplit,y - (ySplit-yDiff)-yDiff,lineWidth,green)
            Draw.ThickLine(x,y - (ySplit-yDiff),x-xSplit,y - (ySplit-yDiff)-yDiff,lineWidth,green)
       end if
    end for
end for

Draw.ThickLine(0,0,maxx,0,xSplit,black)
Draw.ThickLine(maxx,0,maxx,maxy,xSplit,black)
Draw.ThickLine(0,0,0,maxy,xSplit,black)
Draw.ThickLine(0,maxy,maxx,maxy,xSplit,black)