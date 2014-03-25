Mouse.ButtonChoose ("multibutton")
loop
var x, y, button, left, middle, right : int
Mouse.Where (x, y, button)
left := button mod 10           % left = 0 or 1
middle := (button - left) mod 100   % middle = 0 or 10
right := button - middle - left     % right = 0 or 100
if left = 1 then
    put "left button down"
end if
if middle = 10 then
    put "middle button down"
end if
if right = 100 then
    put "right button down"
end if
end loop