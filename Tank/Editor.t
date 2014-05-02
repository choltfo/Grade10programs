% Map editor for the Tank Core

include "Core.t"

procedure save (fileName:string)
    % generate map from walls and vector points
    var stream : int
    open : stream, fileName, get
    
    put : stream, "500"
    put : stream, "500"
    for i : 1.. upper (walls)
        put : stream, "Wall:"
        put : stream, round(walls(i)->getP1().x)
        put : stream, round(walls(i)->getP1().y)
        put : stream, round(walls(i)->getP2().x)
        put : stream, round(walls(i)->getP2().y)
    end for
    
    cls
    put "Loading map..."

end save

var camX, camY : int := 0

loop
    % Show a 500x500 frame of the map, with arrow-key scrolling
    
    
    
    Time.DelaySinceLast(frameMillis)
end loop