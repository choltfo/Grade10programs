
type point : record
x : int
y : int
end record

class LightningBox

import point
export Init, draw, update

var x1,x2,y1,y2,c1,c2,c3 : int := 0

const seperation : int := 10

var points : flexible array 0 .. 0 of point

proc Init (X1,Y1,X2,Y2,C1,C2,C3 : int)
    x1 := X1
    x2 := X2
    y1 := Y1
    y2 := Y2
    c1 := C1
    c2 := C2
    c3 := C3
    points(0).x := x1
    points(0).y := y1+round((y2-y1)/2)
    
    for i : 1.. ceil((x2-x1)/seperation)
        new points, upper (points) + 1
        points(i).x := x1+(i*seperation)
        points(i).y := y1+round((y2-y1)/2)+ Rand.Int(-abs(round((y2-y1)/3)), abs(round((y2-y1)/3)))
    end for
        
    points(upper(points)).y := y1+round((y2-y1)/2)
end Init

proc draw (current,maximum : int, greyed : boolean)
    Draw.FillBox(x1,y1,x2,y2,c3)
    
    if (greyed) then
        for i : 1 .. upper(points)
            Draw.Line(points(i).x,points(i).y,points(i-1).x,points(i-1).y,red)
        end for
    else
        for i : 1 .. upper(points)
            Draw.Line(points(i).x,points(i).y,points(i-1).x,points(i-1).y,c2)
        end for
    end if
    
    Draw.FillBox(x2,y1,x1+round((current/maximum)*(x2-x1)),y2,c3)
    
    Draw.Box(x1,y1,x2,y2,c1)
    %Draw.Box(x1+1,y1-1,x2-1,y2+1,c1)
end draw

proc update ()
    %put upper(points)
    for i : 1.. upper(points)
        points(i).x := x1+(i*seperation)
        points(i).y := y1+round((y2-y1)/2)+Rand.Int(-abs(round((y2-y1)/3)), abs(round((y2-y1)/3)))
    end for
    
    points(upper(points)).y := y1+round((y2-y1)/2)
end update

end LightningBox

proc test ()
var LB : pointer to LightningBox
new LightningBox, LB

Draw.FillBox(0,0,maxx,maxy,white)
View.Set("offscreenonly")
LB -> Init (50,50,250,100,black,cyan,blue)
var lastFrame := 0
loop
    LB -> update()
    LB -> draw(100,100,true)
    
    lastFrame := Time.Elapsed
    View.Update()
    cls
    delay (10)
end loop
end test