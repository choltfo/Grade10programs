% Map editor for the Tank Core

include "Core.t"


procedure save (fileName:string)
    % generate map from walls and vector points
    var stream : int
    open : stream, fileName, put

    put : stream, maxx
    put : stream, maxy
    for i : 1.. upper (walls)
        put : stream, "Wall:"
        put : stream, round(walls(i)->getP1().x)
        put : stream, round(walls(i)->getP1().y)
        put : stream, round(walls(i)->getP2().x)
        put : stream, round(walls(i)->getP2().y)
    end for
    for i : 1.. upper (enemies)
        put : stream, "Enemy:"
        put : stream, round(enemies(i)->getLoc().x)
        put : stream, round(enemies(i)->getLoc().y)
        put : stream, red
    end for
    
    close( stream)
    cls
    put "Loading map..."

end save

function PTInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        %put "x1 > x2, retrying"
        result PTInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        %put "y1 > y2, retrying"
        result PTInRect(x,y,x1,y2,x2,y1)
    end if
    result x > x1 and x < x2 and y > y1 and y < y2
end PTInRect

function ButtonBox (x,y,button,x1,y1,x2,y2,c1,c2:int):boolean
    Draw.Box(x1,y1,x2,y2,c1)
    if button = 1 then
        if PTInRect (x,y,x1,y1,x2,y2) then
            Draw.FillBox(x1,y1,x2,y2,c2)
            Draw.Box(x1,y1,x2,y2,c1)
            result true
        end if
    end if
    result false
end ButtonBox

var camX, camY : int := 0

var editMode : int := 0

var firstPoint : Vector2
%var mX, mY, mB, mLB
Input.KeyDown(chars)

proc draw()
    for i : 1..upper(enemies)
        enemies(i)->render()
    end for
    
    for i : 1..upper(walls)
        walls(i)->draw()
    end for
end draw

loop
    % Show a 500x500 frame of the map, with arrow-key scrolling
    formerChars := chars
    Input.KeyDown(chars)
    mLB := mB
    Mouse.Where(mX,mY,mB)
    
    if chars('1') and not formerChars('1') then
        editMode := 1   % Wall
    end if
    if chars('2') and not formerChars('2') then
        editMode := 2   % Enemy
    end if
    if chars('3') and not formerChars('3') then
        editMode := 3   % Colour area
    end if
    
    if chars('s') and not formerChars('s') then
        save("map2.txt")
    end if
    
    if (mB=1 and mLB=0) then
        if (mX > 0 and mX < maxx and mY < maxy and mY > 0) then
            firstPoint.x := mX
            firstPoint.y := mY
            
            loop
                mLB := mB
                Mouse.Where(mX,mY,mB)
                formerChars := chars
                Input.KeyDown(chars)
                
                if chars(KEY_ESC) and not formerChars(KEY_ESC) then
                    editMode := 0
                    exit
                end if
                if (mB=1 and mLB=0) then
                    if (mX > 0 and mX < maxx and mY < maxy and mY > 0) then
                        
                        var secondPoint : Vector2
                        secondPoint.x := mX
                        secondPoint.y := mY
                        
                        new walls, upper(walls)+1
                        new Wall, walls(upper(walls))
                        walls(upper(walls))->Init(firstPoint,secondPoint)
                        exit
                    end if
                end if
            end loop
        end if
    end if
    
    Time.DelaySinceLast(frameMillis)
    
    draw
    View.Update()
    cls
    
end loop