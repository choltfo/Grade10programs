View.Set("offscreenonly")

var x, y, button :int %vars for the mouse where code 


Draw.FillBox(0,0,maxx,maxy,255)

procedure DrawTriangle (x1,y1,x2,y2,x3,y3,c,cf : int)
    Draw.ThickLine(x1,y1,x2,y2,3,c)
    Draw.ThickLine(x1,y1,x3,y3,3,c)
    Draw.ThickLine(x2,y2,x3,y3,3,c)
    
    var xM := round((x1+x2+x3)/3)
    var yM := round((y1+y2+y3)/3)
    
    if (xM > maxx) then
        xM := maxx
    end if
    if (yM > maxy) then
        yM := maxy
    end if
    if (xM < 0) then
        xM := 0
    end if
    if (yM < 0) then
        yM := 0
    end if
    
    Draw.Fill(xM,yM,cf,c)
    Draw.Line(xM-10,yM,xM+10,yM, blue)
    Draw.Line(xM,yM-10,xM,yM+10, blue)
end DrawTriangle




loop %needs to be in a loop to keep on reading mouse data 

       Mouse.Where (x, y, button) %code to find data on mouse ]
       %check to see if button is hit 
       if button = 1 then 
                 delay (1) 
                 DrawTriangle(0,0,maxx,maxy,x,y,black,red)
        end if 
        View.Update()
        Draw.Cls()
end loop