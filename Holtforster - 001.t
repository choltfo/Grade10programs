% Charles Holtforster
% Make isometric 3D cubes with draw functions.

View.Set("offscreenonly")

var font:int
font := Font.New ("arial:14") 

% Configuration variables

var ySplit : int := 100
var yDiff  : int := 50
var xSplit : int := 100
var lineWidth : int:= 1

var rt2 : real := sqrt(2)
loop
    Draw.FillBox(0, 0, maxx, maxy, white)
    if yDiff >= ySplit then
        put "Invalid settings! yDiff must be lesser than ySplit!"
    else
        for x : -1000 .. maxx+1000 by xSplit
            for y : -1000 .. maxy+1000 by ySplit
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
                end if
            end for
        end for
            
        for x : -1000 .. maxx+1000 by xSplit
            for y : -1000 .. maxy+1000 by ceil(ySplit)
                if (x/(xSplit) mod 2) = (y/(ySplit) mod 2)then
                    %Draw.Line(x-20,y,x+20,y,blue) % just a placeholder
                    %Draw.ThickLine(x,y,x,y + ySplit+yDiff,5,green)
                    
                    Draw.ThickLine(x,y +(ySplit-yDiff),x,y - (ySplit-yDiff),lineWidth,red) % Primary vertical
                    
                    Draw.ThickLine(x,y,x+xSplit,y-yDiff,lineWidth,blue)
                    Draw.ThickLine(x,y,x-xSplit,y-yDiff,lineWidth,green)
                    Draw.ThickLine(x,y - (ySplit-yDiff),x+xSplit,y - (ySplit-yDiff)-yDiff,lineWidth,blue)
                    Draw.ThickLine(x,y - (ySplit-yDiff),x-xSplit,y - (ySplit-yDiff)-yDiff,lineWidth,green)
                end if
            end for
        end for
    end if
    
   % ySplit := (ySplit+1) mod maxy + 1
   % xSplit := (xSplit+1) mod maxx + 1
    yDiff  := (yDiff +1) mod (ySplit)
    View.Update()
    delay(10)
end loop

Draw.Text("Isometric boxes.",5,maxy-24,font,255)
Draw.Text("Made by Charles Holtforster.",5,5,font,255)