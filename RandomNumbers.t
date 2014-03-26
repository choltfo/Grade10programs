Draw.FillBox(0,0,maxx,maxy,white)
var frameMillis : int := 100
var LastFrame : int := 0

var keys, formerKeys : array char of boolean

const size : int := 40

class Cell
    export Alive, alive
    var alive : boolean := false %cheat(boolean, Rand.Int(0,1))
    
    proc Alive (a : boolean)
        alive := a
    end Alive
    
    
    
end Cell

var NewCells,CurrentCells : array 0..size,0..size of pointer to Cell

var width  :int := ceil(maxx/size)
var height :int := ceil(maxy/size)

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
    if (keys(KEY_ESC) and not formerKeys(KEY_ESC)) then
        paused := not paused
    end if
    
    for x : 1..size
        for y : 1..size
            
            % Allows you to click in a cell
            if (PtInRect    ((x)*width,(y)*height,(x+1)*width,(y+1)*height,  Mx,My) and Mb=1) then
                CurrentCells(x,y) -> Alive (true)
            end if
            
            % Draw the cell
            if (CurrentCells(x,y) -> alive) then
                Draw.FillBox((x)*width,(y)*height,(x+1)*width,(y+1)*height,blue)
            end if
            
            if not paused then
                var neighbours : int := 0
                
                for cX : -1..1  % count neighbours.
                    for cY : -1..1
                        if (CurrentCells((x+cX) mod size,(y+cY) mod size) -> alive) then
                            if not(cX = cY and cX=0) then
                                
                                neighbours += 1
                                
                            end if
                        end if
                    end for
                end for
                    
                if (neighbours < 2)then
                    NewCells(x,y) -> Alive (false)  % Dies of loneliness
                elsif ((neighbours = 2 or neighbours = 3) and CurrentCells(x,y) -> alive) then
                    NewCells(x,y) -> Alive (true)   % Continues existing
                elsif (neighbours > 3) then
                    NewCells(x,y) -> Alive (false)  % Dies of overpopulation
                elsif (neighbours = 3 and not CurrentCells(x,y) -> alive) then
                    NewCells(x,y) -> Alive (true)   % Born
                else
                    NewCells(x,y) -> Alive (false)  % Otherwise, die. Not reachable.
                end if
                
            end if % Pause checking
            
        end for
    end for
        
    for x : 1..size+1
        Draw.Line(x*width,0,x*width,maxy,black)
    end for
        for y : 1..size+1
        Draw.Line(0,y*height,maxx,y*height,black)
    end for
        
    CurrentCells := NewCells
    put (LastFrame + frameMillis) - Time.Elapsed
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



