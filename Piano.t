% Animations
View.Set("offscreenonly")
var X, Y, button :int %vars for the mouse where code 

function PTInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        put "x1 > x2, retrying"
        result PTInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        put "y1 > y2, retrying"
        result PTInRect(x,y,x1,y2,x2,y1)
    end if
    result x > x1 and x < x2 and y > y1 and y < y2
end PTInRect

function ButtonBox (x,y,x1,y1,x2,y2,c1,c2:int):boolean
    Draw.Box(x1,y1,x2,y2,c1)
    %put X,Y
    if button = 1 then
        if PTInRect (X,Y,x1,y1,x2,y2) then
            Draw.Box(x1,y1,x2,y2,c2)
            result true
        end if
    end if
    result false
end ButtonBox

loop % Needs to be in a loop to keep on reading mouse data
    Mouse.Where (X, Y, button) % Code to find data on mouse
    for i : 1 .. 16
        if (ButtonBox(X,Y,(i)*20,200,20+(i)*20,300,black,red)) then
            play(chr(i+98))
        end if
    end for
    
    View.Update()
    delay(50)
    cls()
end loop

