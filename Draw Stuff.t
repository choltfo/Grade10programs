Draw.FillBox(0,0, maxx, maxy, black)
for i : 0..100
    
    %var x : int := floor((i mod (maxx/50))*50)
    
    var ySplit : int := 50
    var yDiff  : int := 20
    var xSplit : int := 25
    
    var y : int := floor(i/ceil(maxx/ySplit))*ySplit
    var x : int := xSplit * (i mod ceil(maxx/ySplit)) - round(((y/xSplit)mod 2) * ySplit)
    
    var arrX:array 1..4 of int := init(0,0,0,0)
    var arrY:array 1..4 of int := init(0,0,0,0)
    
    %x, y-100,y-50, y+50
    %y,x,x-25,x+25
    
    arrX(1) := x
    arrX(2) := x
    arrX(3) := x-25
    arrX(4) := x+25
    
    arrY(1) := y
    arrY(2) := y-60
    arrY(3) := y-50
    arrY(4) := y+50
    
    
    %Draw.FillPolygon(arrX, arrY, 4, white)
    
    %Draw.ThickLine(x,y,x,y + 80,5,green)
    Draw.ThickLine(x,y,x,y + ySplit+yDiff,5,green)
   % Draw.ThickLine(x,y+60,x+15,y+75,5,purple)
   % Draw.ThickLine(x,y+60,x-15,y+75,5,white)
   % Draw.ThickLine(x,y+60,x+15,y+5,5,green)
   % Draw.ThickLine(x,y+60,x-15,y+5,5,green)
    
end for