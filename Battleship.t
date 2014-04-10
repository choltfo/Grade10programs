% Battleship!

% We want to create 2 grids of 20*20 gridPoints, and populate them with 10 ships of lengths 5, 4, 3, and 3

View.Set("offscreenonly")

type gridPoint :
record
    firedOn : boolean
    containsShip : boolean
end record

type ship :
record
    x1 : int
    y1 : int
    x2 : int
    y2 : int
end record

var player1grid : array 1..20,1..20 of gridPoint

for x : 1..20
    for y : 1..20
        player1grid(x,y).firedOn := false
        player1grid(x,y).containsShip := false
    end for
end for
    
proc addShip(x1,y1,x2,y2:int)
    
    if (x1 < x2) then
        if (y1 < y2) then
            for x : x1..x2
                for y : y1..y2
                    player1grid (x,y).containsShip := true
                end for
            end for
            else
            addShip(x1,y2,x2,y1)
        end if
    else
        addShip(x2,y1,x1,y2)
    end if
    
end addShip

proc drawGrid()
    for x : 1..20
        for y : 1..20
            Draw.FillBox(x*15,y*15,(x+1)*15,(y+1)*15,blue)
            if (player1grid(x,y).containsShip) then
                Draw.FillBox(x*15,y*15,(x+1)*15,(y+1)*15,black)
            end if
            if (player1grid(x,y).firedOn) then
                Draw.FillBox(x*15,y*15,(x+1)*15,(y+1)*15,red)
            end if
        end for
    end for
        
    for x : 1..20
        for y : 1..20
            Draw.Box (x*15,y*15,(x+1)*15,(y+1)*15,green)
        end for
    end for
end drawGrid

var mX,mY,mB,mL : int := 0
var shipsLeft : int := 3

loop    % placement loop
    mL := mB
    Mouse.Where(mX,mY,mB)
    
    if (mX > 15 and mX < 20*15 and mY > 15 and mY < 20*15) then
        var x1,y1,x2,y2 : int := 0
        
        drawGrid()
        
        if (mB = 1 and mL = 0) then
            x1 := floor(mX/15)
            y1 := floor(mY/15)
            loop
                mL := mB
                Mouse.Where(mX,mY,mB)
                if (mB = 1 and mL = 0) then
                    x2 := floor(mX/15)
                    y2 := floor(mY/15)
                    addShip(x1,y1,x2,y2)
                    shipsLeft -= 1
                end if
                Draw.ThickLine(mX,mY,x1*15,y1*15,5,black)
                drawGrid()
                View.Update()
                cls()
                exit when mB = 1 and mL = 0
            end loop
        end if
        
    end if
    
    Time.DelaySinceLast(10)
    View.Update()
    exit when shipsLeft = 0
end loop

loop    % Firing loop
    mL := mB
    Mouse.Where(mX,mY,mB)
    
    if (mX > 15 and mX < 21*15 and mY > 15 and mY < 21*15) then
        var x1,y1 : int := 0
        
        drawGrid()
        
        if (mB = 1 and mL = 0) then
            x1 := floor(mX/15)
            y1 := floor(mY/15)
            player1grid(x1,y1).firedOn := true
        end if
        
    end if
    
    Time.DelaySinceLast(10)
    View.Update()
end loop


