module UIE
    export checkBox
    
    function checkBox (x,y : int, state : boolean,mx,my,mb,lmb : int) : boolean
        if (state) then
            Draw.FillBox(x,y,x+20,y+20,green)
        end if
        Draw.Box(x,y,x+20,y+20,black)
        if mx < x+20 and mx > x and my > y and my < y + 20 and mb = 1 and lmb = 0 then
            result not state
        end if
        result state
    end checkBox
end UIE