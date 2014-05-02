% Map editor for the Tank Core

include "Core.t"

procedure save (fileName:string)
    % generate map from walls and vector points
    var stream : int
    open : stream, fileName, put
    
    var width : string := "500"
    put : stream, "500"
    put : stream, "500"
    for i : 1.. upper (walls)
        put : stream, "Wall:"
        put : stream, round(walls(i)->getP1().x)
        put : stream, round(walls(i)->getP1().y)
        put : stream, round(walls(i)->getP2().x)
        put : stream, round(walls(i)->getP2().y)
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

loadMap("map1.txt")
save ("map2.txt")
loadMap("map2.txt")
if playLoadedLevel() then
    put "YAY!"
end if

loop
    % Show a 500x500 frame of the map, with arrow-key scrolling
    
    
    
    Time.DelaySinceLast(frameMillis)
end loop