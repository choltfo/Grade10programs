% Charles Holtforster
% Make isometric 3D cubes with draw functions.

var font:int
font := Font.New ("arial:14") 

% Configuration variables

var split : int := 60
var yDiff  : int := 50
var lineWidth : int:= 0

var rt2 : real := sqrt(2)

Draw.FillBox(0, 0, maxx, maxy, white)
if yDiff >= split then
    put "Invalid settings! yDiff must be lesser than split!"
else
    for x : -500 .. maxx+500 by split
        for y : -500 .. maxy+500 by split
            if (x/(split) mod 2) = (y/(split) mod 2)then
                
                var arrX:array 1..4 of int := init(0,0,0,0)
                var arrY:array 1..4 of int := init(0,0,0,0)
                
                
                arrX(1) := x-split
                arrX(2) := x-split
                arrX(3) := x
                arrX(4) := x
                
                arrY(1) := y-yDiff
                arrY(2) := y-split
                arrY(3) := y - (split-yDiff) - yDiff - yDiff
                arrY(4) := y
                
                Draw.FillPolygon(arrX, arrY, 4, grey)
                
                arrX(1) := x
                arrX(2) := x-split
                arrX(3) := x
                arrX(4) := x+split
                
                arrY(1) := y - (split-yDiff)
                arrY(2) := y-split
                arrY(3) := y - (split-yDiff) - yDiff - yDiff
                arrY(4) := y-split
                
                Draw.FillPolygon(arrX, arrY, 4, darkgrey)
                
                Draw.FillOval(x, y - (split-yDiff) - yDiff, round(split/rt2), round((split-yDiff)/rt2), black)
                
            end if
        end for
    end for
        
    for x : -500 .. maxx+500 by split
        for y : -500 .. maxy+500 by ceil(split)
            if (x/(split) mod 2) = (y/(split) mod 2)then
                %Draw.Line(x-20,y,x+20,y,blue) % just a placeholder
                %Draw.ThickLine(x,y,x,y + split+yDiff,5,green)
                
                Draw.ThickLine(x,y +(split-yDiff),x,y - (split-yDiff),lineWidth,red) % Primary vertical
                
                Draw.ThickLine(x,y,x+split,y-yDiff,lineWidth,blue)
                Draw.ThickLine(x,y,x-split,y-yDiff,lineWidth,green)
                Draw.ThickLine(x,y - (split-yDiff),x+split,y - (split-yDiff)-yDiff,lineWidth,blue)
                Draw.ThickLine(x,y - (split-yDiff),x-split,y - (split-yDiff)-yDiff,lineWidth,green)
            end if
        end for
    end for
end if

Draw.Text("Isometric boxes.",5,maxy-24,font,255)
Draw.Text("Made by Charles Holtforster.",5,5,font,255)