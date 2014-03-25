Draw.FillBox(0,0,maxx,maxy,white)
Draw.Dot(round(maxx/2),round(maxy/2),red)
var frameMillis : int := 10
var LastFrame : int := 0

var keys, formerKeys : array char of boolean

const size : int := 40

class Cell
    export Alive, alive
    var alive : boolean := cheat(boolean, Rand.Int(0,1))
    
    proc Alive (a : boolean)
        alive := a
    end Alive
    
    
    
end Cell

var NewCells,CurrentCells : array 0..size,0..size of pointer to Cell

var width  :int := floor(maxx/size)
var height :int := floor(maxy/size)

View.Set("offscreenonly")

for x : 0..size
    for y : 0..size
        new Cell, CurrentCells(x,y)
    end for
end for
    
NewCells:= CurrentCells

function PtInRect (x1,y1,x2,y2,x,y:int):boolean
    if x1 > x2 then
        result PtInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        result PtInRect(x,y,x1,y2,x2,y1)
    end if
    result (x > x1) and (x < x2) and (y > y1) and (y < y2)
end PtInRect

var paused : boolean := false

var Mx,My,Mb,left, middle, right := 0
var Px,Py,Pb := 0

Input.KeyDown(keys)
formerKeys := keys

loop
    Input.KeyDown(keys)
    Mouse.Where(Mx,My,Mb)
    if (right = 100) then
        paused := not paused
    end if
    for x : 0..size
        for y : 0..size
            
            if not paused then
            var neighbours : int := 0
            
            for cX : -1..1
                for cY : -1..1
                    if (cX ~= 0 and cY ~= 0 and CurrentCells((x+cX) mod size,(y+cY) mod size) -> alive) then
                        neighbours += 1
                    end if
                end for
            end for
            
            if (neighbours < 2) then
                NewCells(x,y) -> Alive (false)
            elsif ((neighbours = 2 or neighbours = 3) and NewCells(x,y) -> alive) then
                NewCells(x,y) -> Alive (true)
            elsif (neighbours > 3 and NewCells(x,y) -> alive) then
                NewCells(x,y) -> Alive (false)
            elsif (neighbours = 3 and not NewCells(x,y) -> alive) then
                NewCells(x,y) -> Alive (true)
            end if
            end if
            
            if (PtInRect    ((x)*width,(y)*height,(x+1)*width,(y+1)*height,  Mx,My) and Mb=1) then
                NewCells(x,y) -> Alive (true)
            end if
            
            if (CurrentCells(x,y) -> alive) then
                Draw.FillBox((x)*width,(y)*height,(x+1)*width,(y+1)*height,red)%(x xor y)mod 255)
            end if
            
        end for
    end for
    CurrentCells := NewCells
    %put (LastFrame + frameMillis) - Time.Elapsed
    View.Update()
    cls()
    Draw.FillBox(0,0,maxx,maxy,white)
    
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
    Draw.FillBox(0,0,maxx,maxy,white)
    Pb := Mb
    formerKeys := keys
end loop



