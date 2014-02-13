% So, I want to make an A* pathfinder through a grid.

View.Set("offscreenonly")
var font1 := Font.New ("sans serif:10:bold")

% grid states
% 0 -> Blank
% 1 -> Wall

% handlingSet states
% 0 -> nothing
% 1 -> inaccessible/closed
% 2 -> open
% 3 -> done

% NOTE: all access is via x,-y.... DAMMIT!

Draw.FillBox(0,0,maxx,maxy,brown)

var sourceX : int := 2
var sourceY : int := 2

var targetX : int := 19
var targetY : int := 19

var grid : array 1 .. 20, 1 .. 20 of int := init(
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,1,0,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,1,
    1,0,1,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,1,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,1,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,1,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,
    1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,
    1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,1,0,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,1,
    1,0,1,1,0,1,0,0,0,1,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,1,1,0,1,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,0,1,0,1,1,0,1,0,0,0,0,0,0,1,
    1,0,0,0,0,1,0,1,1,1,1,0,1,0,0,0,0,0,0,1,
    1,0,1,0,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,
    1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1, % This is the top.
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
                                    %   /\
                                    %    |

var handlingSet : array 1 .. 20, 1 .. 20 of int := init(
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0)

% Arbitrarily high - F is distance to target
var fSet : array 1 .. 20, 1 .. 20 of int := init(
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000)

% Arbitrarily high - G is cost to reach
var gSet : array 1 .. 20, 1 .. 20 of int := init(
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,
    1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000)



handlingSet := grid

handlingSet (sourceX,sourceY) := 2
gSet (sourceX,sourceY) := 0 % The cost of inaction is nothing

%put "Drawing grid."

for x : 1 .. 20
    for y : 1 .. 20
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

% put "Starting search."

loop
    % Show stuff
    
    var lowestF,xpos,ypos : int := 99999999
    
    for x : 1 .. 20
        for y : 1 .. 20
            if handlingSet (x,y) = 2 then       % Open set
                
                if getF(x,y) < lowestF then
                    lowestF := getF(x,y)
                    xpos := x
                    ypos := y
                end if
                
                var lowestG := 1000
                
                if gSet (x,y) < lowestG then
                    lowestG := gSet(x,y)
                end if
                if gSet (x+1,y+1) < lowestG and handlingSet(x+1,y+1) not= 1 then
                    lowestG := gSet (x+1,y+1) 
                end if
                if gSet (x+1,y) < lowestG and handlingSet(x+1,y) not= 1 then
                    lowestG := gSet (x+1,y)
                end if
                if gSet (x+1,y-1) < lowestG and handlingSet(x+1,y-1) not= 1 then
                    lowestG := gSet (x+1,y-1)
                end if
                if gSet (x,y-1) < lowestG and handlingSet(x,y-1) not= 1 then
                    lowestG := gSet (x,y-1)
                end if
                if gSet (x-1,y-1) < lowestG and handlingSet(x-1,y-1) not= 1 then
                    lowestG := gSet (x-1,y-1)
                end if
                if gSet (x-1,y) < lowestG and handlingSet(x-1,y) not= 1 then
                    lowestG := gSet (x-1,y)
                end if
                if gSet (x-1,y+1) < lowestG and handlingSet(x-1,y+1) not= 1 then
                    lowestG := gSet (x-1,y+1)
                end if
                if gSet (x,y+1) < lowestG and handlingSet(x,y+1) not= 1 then
                    lowestG := gSet (x,y+1)
                end if
                
                
                gSet (x,y) := lowestG + 1
                
                
                
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

% Okay, so now we need to start at the end, and backtrack, finding the nearest one with the lowest G scoreh

var xpos := targetX
var ypos := targetY

var lowestG := 1000000
var bestX := xpos
var bestY := ypos
    
View.Update()

loop
    if gSet (xpos+1,ypos-1) <= lowestG then
        lowestG := gSet (xpos+1,ypos-1)
        bestX := xpos+1
        bestY := ypos-1
    end if
    if gSet (xpos-1,ypos-1) <= lowestG then
        lowestG := gSet (xpos-1,ypos-1)
        bestX := xpos-1
        bestY := ypos-1
    end if
    if gSet (xpos+1,ypos+1) <= lowestG then
        lowestG := gSet (xpos+1,ypos+1)
        bestX := xpos+1
        bestY := ypos+1
    end if
    if gSet (xpos+1,ypos+1) <= lowestG then
        lowestG :=  gSet (xpos+1,ypos+1)
        bestX := xpos+1
        bestY := ypos+1
    end if
    if gSet (xpos,ypos-1) <= lowestG then
        lowestG := gSet (xpos,ypos-1)
        bestX := xpos
        bestY := ypos-1
    end if
    if gSet (xpos,ypos+1) <= lowestG then
        lowestG := gSet (xpos,ypos+1)
        bestX := xpos
        bestY := ypos+1
    end if
    if gSet (xpos+1,ypos) <= lowestG then
        lowestG := gSet (xpos+1,ypos)
        bestX := xpos+1
        bestY := ypos
    end if
    if gSet (xpos-1,ypos) <= lowestG then
        lowestG := gSet (xpos-1,ypos)
        bestX := xpos-1
        bestY := ypos
    end if
    
    % Now for the lesser than
    
    if gSet (xpos+1,ypos-1) < lowestG then
        lowestG := gSet (xpos+1,ypos-1)
        bestX := xpos+1
        bestY := ypos-1
    end if
    if gSet (xpos-1,ypos-1) < lowestG then
        lowestG := gSet (xpos-1,ypos-1)
        bestX := xpos-1
        bestY := ypos-1
    end if
    if gSet (xpos+1,ypos+1) < lowestG then
        lowestG := gSet (xpos+1,ypos+1)
        bestX := xpos+1
        bestY := ypos+1
    end if
    if gSet (xpos+1,ypos+1) < lowestG then
        lowestG :=  gSet (xpos+1,ypos+1)
        bestX := xpos+1
        bestY := ypos+1
    end if
    if gSet (xpos,ypos-1) < lowestG then
        lowestG := gSet (xpos,ypos-1)
        bestX := xpos
        bestY := ypos-1
    end if
    if gSet (xpos,ypos+1) < lowestG then
        lowestG := gSet (xpos,ypos+1)
        bestX := xpos
        bestY := ypos+1
    end if
    if gSet (xpos+1,ypos) < lowestG then
        lowestG := gSet (xpos+1,ypos)
        bestX := xpos+1
        bestY := ypos
    end if
    if gSet (xpos-1,ypos) < lowestG then
        lowestG := gSet (xpos-1,ypos)
        bestX := xpos-1
        bestY := ypos
    end if
    
    xpos := bestX
    ypos := bestY
    
    Draw.FillOval(10+(xpos-1)*20,10+(ypos-1)*20,10,10,yellow)
    View.Update()
    exit when lowestG = 1
end loop

for x : 1 .. 20
    for y : 1 .. 20
        Draw.Text(intstr(gSet(x,y)), 200+(x-1)*30,1000+(y-1)*30,font1,white)
    end for
end for





