Draw.FillBox(0,0,maxx,maxy,white)
var frameMillis : int := 10
var LastFrame : int := 0

var SavePath : string := "CGOLSave.bmp" 

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
    if (keys(KEY_ESC) and not formerKeys(KEY_ESC)) then
        paused := not paused
    end if
    
    
    if (paused) then
        Draw.FillBox(20,maxy-20,60,maxy-100,yellow)
        Draw.FillBox(80,maxy-20,120,maxy-100,yellow)
        
        if (keys(KEY_CTRL) and keys('s') and not formerKeys('s')) then
            cls()
            for x : 1..size
                for y : 1..size
                    if (CurrentCells(x,y) -> alive) then
                        Draw.Dot(x,y,black)
                    end if
                    % Add the saving code here.
                end for
            end for
                
            var SaveData := Pic.New(1,1,size,size)
            Pic.Save(SaveData, SavePath)
            Pic.Free(SaveData)
        end if
        
        if (keys(KEY_CTRL) and keys('o') and not formerKeys('o')) then
            cls()
            Pic.ScreenLoad(SavePath,1,1,0)
            for x : 1..size
                for y : 1..size
                    NewCells (x,y) -> Alive (whatdotcolour(x,y) = black)
                    % Add the saving code here.
                end for
            end for
        end if
    end if
    
    for x : 1..size
        for y : 1..size
            
            % Allows you to click in a cell
            if (PtInRect    ((x)*width,(y)*height,(x+1)*width,(y+1)*height,  Mx,My) and Mb=1) then
                CurrentCells(x,y) -> Alive (true)
            end if
            % Draw the cell
            if (CurrentCells(x,y) -> alive) then
                Draw.FillBox((x)*width,(y)*height,(x+1)*width,(y+1)*height,red)
            end if
            
            if not paused then
                new Cell, NewCells(x,y)
                var neighbours : int := 0
                
                for cX : -1..1  % count neighbours.
                    for cY : -1..1
                        
                        if not(cX = cY and cX=0) then
                            %if (cX + x <= size and cX + x > 0 and cY + y <= size and cY + y > 0) then
                            
                            if (CurrentCells((x+cX-1)mod size+1,(y+cY-1)mod size +1) -> alive) then
                                neighbours := neighbours + 1
                            end if
                            
                            %end if  
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
        Draw.Line(x*width,height,x*width,(size+1)*height,black)
    end for
        for y : 1..size+1
        Draw.Line(width,y*height,(size+1)*width,y*height,black)
    end for
        
    CurrentCells := NewCells
    %put (LastFrame + frameMillis) - Time.Elapsed
    put "Esc to pause. 'A' to reduce framerate, 'D' to increase."
    locate(1,60)
    put "Current F-Time: ",frameMillis
    View.Update()
    cls()
    Draw.FillBox(0,0,maxx,maxy,white)
    
    if (keys('a')) then
        cls()
        frameMillis += 1
    end if
    if (keys('d')) then
        cls()
        frameMillis += -1
        if (frameMillis < 0) then
            frameMillis := 0
        end if
    end if
    
    if (keys('r')) then
        for x : 0..size
            for y : 0..size
                CurrentCells(x,y)->Alive(cheat(boolean, Rand.Int(0,1)))
            end for
        end for
    end if
    
    if (not paused) then
        loop
            exit when (LastFrame + frameMillis) < Time.Elapsed
        end loop
    end if
    LastFrame := Time.Elapsed
    Draw.FillBox(0,0,maxx,maxy,white)
    Pb := Mb
    formerKeys := keys
end loop



