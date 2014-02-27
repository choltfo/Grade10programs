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
    Draw.FillBox(x1,y1,x2,y2,c1)
    %put X,Y
    if button = 1 then
        if PTInRect (X,Y,x1,y1,x2,y2) then
            Draw.FillBox(x1,y1,x2,y2,c2)
            result true
        end if
    end if
    result false
end ButtonBox

loop % Needs to be in a loop to keep on reading mouse data
    Mouse.Where (X, Y, button) % Code to find data on mouse
    
    var Clicked := ButtonBox(X,Y,200,200,300,300,black,red)
    if (Clicked) then
        play("8CEG>CEG>CEGGEC<GEC<GEC")
    end if
    View.Update()
    delay(50)
    cls()
end loop