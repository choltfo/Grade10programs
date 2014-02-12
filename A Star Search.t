% So, I want to make an A* pathfinder through a grid.

View.Set("offscreenonly")

% grid states
% 0 -> Blank
% 1 -> Wall

% handlingSet states
% 0 -> nothing
% 1 -> inaccessible/closed
% 2 -> open
% 3 -> done

% NOTE: all access is via y,x.... DAMMIT!

var grid : array 1 .. 10, 1 .. 10 of int := init(
    1,1,1,1,1,1,1,1,1,1,
    1,0,0,0,0,0,0,0,1,1,
    1,1,1,1,1,1,1,1,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,1,1,1,1,1,1,1,1,
    1,0,0,0,0,0,0,0,0,1,
    1,1,1,1,1,1,1,1,1,1)

var handlingSet : array 1 .. 10, 1 .. 10 of int := init(
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1)

var sourceX : int := 2
var sourceY : int := 2

var targetX : int := 9
var targetY : int := 9

handlingSet := grid

handlingSet (sourceX,sourceY) := 2

put grid (1,1)

for x : 1 .. 10
    for y : 1 .. 10
        Draw.FillBox ((x-1)*20,(y-1)*20,20+(x-1)*20,20+(y-1)*20,255*grid (x,y))
        View.Update()
    end for
end for
    
Draw.FillOval(10+(sourceX-1)*20,10+(sourceY-1)*20,10,10,green)
View.Update()
Draw.FillOval(10+(targetX-1)*20,10+(targetY-1)*20,10,10,yellow)
View.Update()

function getF (x,y:int) : int
    
            % Major BS here, g isn't actually 1....
    %result (1 + targetX-x + targetY-y)
    result (sourceX-x + sourceY-y + targetX-x + targetY-y)
end getF

loop
    % Show stuff
    
    var lowestF,xpos,ypos : int := 99999999
    
    for x : 1 .. 10
        for y : 1 .. 10
            if handlingSet (x,y) = 2 then       % Open set
                
                if getF(x,y) < lowestF then
                    lowestF := getF(x,y)
                    xpos := x
                    ypos := y
                end if
                Draw.Oval (10+(x-1)*20,10+(y-1)*20,10,10,blue)
            elsif handlingSet (x,y) = 1 then  % Inaccessible/closed set
                Draw.FillOval (10+(x-1)*20,10+(y-1)*20,10,10,red)
            elsif handlingSet (x,y) = 3 then  % Inaccessible/closed set
                Draw.FillOval (10+(x-1)*20,10+(y-1)*20,10,10,blue)
            end if
            View.Update()
        end for
    end for
    
    handlingSet(xpos,ypos) := 3
    
    if handlingSet (xpos+1,ypos-1) = 0 then
       handlingSet (xpos+1,ypos-1) := 2 
    end if
    if handlingSet (xpos-1,ypos-1) = 0 then
       handlingSet (xpos-1,ypos-1) := 2 
    end if
    if handlingSet (xpos+1,ypos+1) = 0 then
       handlingSet (xpos+1,ypos+1) := 2 
    end if
    if handlingSet (xpos+1,ypos+1) = 0 then
       handlingSet (xpos+1,ypos+1) := 2 
    end if
    if handlingSet (xpos,ypos-1) = 0 then
       handlingSet (xpos,ypos-1) := 2 
    end if
    if handlingSet (xpos,ypos+1) = 0 then
       handlingSet (xpos,ypos+1) := 2 
    end if
    if handlingSet (xpos+1,ypos) = 0 then
       handlingSet (xpos+1,ypos) := 2 
    end if
    if handlingSet (xpos-1,ypos) = 0 then
       handlingSet (xpos-1,ypos) := 2 
    end if
    
    
    
    View.Update()
    exit when handlingSet(targetX,targetY) = 3
end loop

put "YES! Now to do the actual pathfinding!"

loop
    % Show stuff
    
    var lowestF,xpos,ypos : int := 99999999
    
    for x : 1 .. 10
        for y : 1 .. 10
            if handlingSet (x,y) = 2 then       % Open set
                
                if getF(x,y) < lowestF then
                    lowestF := getF(x,y)
                    xpos := x
                    ypos := y
                end if
                Draw.Oval (10+(x-1)*20,10+(y-1)*20,10,10,blue)
            elsif handlingSet (x,y) = 1 then  % Inaccessible/closed set
                Draw.FillOval (10+(x-1)*20,10+(y-1)*20,10,10,red)
            elsif handlingSet (x,y) = 3 then  % Done
                Draw.FillOval (10+(x-1)*20,10+(y-1)*20,10,10,blue)
            end if
            View.Update()
        end for
    end for
    
    handlingSet(xpos,ypos) := 3
    
    if handlingSet (xpos+1,ypos-1) = 0 then
       handlingSet (xpos+1,ypos-1) := 2 
    end if
    if handlingSet (xpos-1,ypos-1) = 0 then
       handlingSet (xpos-1,ypos-1) := 2 
    end if
    if handlingSet (xpos+1,ypos+1) = 0 then
       handlingSet (xpos+1,ypos+1) := 2 
    end if
    if handlingSet (xpos+1,ypos+1) = 0 then
       handlingSet (xpos+1,ypos+1) := 2 
    end if
    if handlingSet (xpos,ypos-1) = 0 then
       handlingSet (xpos,ypos-1) := 2 
    end if
    if handlingSet (xpos,ypos+1) = 0 then
       handlingSet (xpos,ypos+1) := 2 
    end if
    if handlingSet (xpos+1,ypos) = 0 then
       handlingSet (xpos+1,ypos) := 2 
    end if
    if handlingSet (xpos-1,ypos) = 0 then
       handlingSet (xpos-1,ypos) := 2 
    end if
    
    
    
    View.Update()
    exit when handlingSet(targetX,targetY) = 3
end loop



