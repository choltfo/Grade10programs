/*
    An A* pathfinder, written by Charles Holtforster
*/


type point : record
    wall : boolean
    fScore : real   % The distance from this point to the end
    gScore : int   % The cost to reach this point
    closed : boolean
end record

type coord : record
    x : int
    y : int
end record

function PtInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        result PtInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        result PtInRect(x,y,x1,y2,x2,y1)
    end if
    result (x > x1) and (x < x2) and (y > y1) and (y < y2)
end PtInRect

var font : int := Font.New("arial:24")
var font2 : int := Font.New("arial:6")

var start, finish : point


var grid : array 0..21, 0..21 of point



for x : 1..20
    for y : 1..20
        grid(x,y).wall := false
        grid(x,y).gScore := 1000000
        grid(x,y).fScore := Math.sqrt((20-x)*(20-x)+(20-y)*(20-y))
        grid(x,y).closed := false
    end for
end for

grid(1,1).wall := false
grid(1,1).gScore := 0

grid(20,20).wall := false
grid(20,20).fScore := 0

for i : 0..21
    grid(i,0).wall := true
    grid(0,i).wall := true
    grid(i,21).wall := true
    grid(21,i).wall := true
end for

View.Set("offscreenonly")
var pX,pY,lMB : int := 0

const CELL_WIDTH := 15
const CELL_HEIGHT:= 15

loop    % Allow map creation.
    var mX,mY,mB : int := 0
    Mouse.Where(mX,mY,mB)

    Draw.Text("Draw a maze starting at the green,", 20,maxy-26,font,black)
    Draw.Text("ending at the red.", 20,maxy-52,font,black)

    for i : 0..21
        Draw.FillBox(i*CELL_WIDTH,0*CELL_HEIGHT,(i+1)*CELL_WIDTH,(0+1)*CELL_HEIGHT,black)
        Draw.FillBox(0*CELL_WIDTH,i*CELL_HEIGHT,(0+1)*CELL_WIDTH,(i+1)*CELL_HEIGHT,black)
        Draw.FillBox(i*CELL_WIDTH,21*CELL_HEIGHT,(i+1)*CELL_WIDTH,(21+1)*CELL_HEIGHT,black)
        Draw.FillBox(21*CELL_WIDTH,i*CELL_HEIGHT,(21+1)*CELL_WIDTH,(i+1)*CELL_HEIGHT,black)
    end for
    
    for x : 1..20
        for y : 1..20
            if (PtInRect(mX,mY,x*CELL_WIDTH,y*CELL_HEIGHT,(x+1)*CELL_WIDTH,(y+1)*CELL_HEIGHT) and (mB = 1) and (((pX not= x) or (pY not= y)) or lMB not= mB)) then
                grid(x,y).wall := not grid(x,y).wall
                pX := x
                pY := y
            end if
            if (grid(x,y).wall) then
                Draw.FillBox(x*CELL_WIDTH,y*CELL_HEIGHT,(x+1)*CELL_WIDTH,(y+1)*CELL_HEIGHT,black)
            end if
            Draw.Box(x*CELL_WIDTH,y*CELL_HEIGHT,(x+1)*CELL_WIDTH,(y+1)*CELL_HEIGHT,black)
        end for
    end for

    Draw.FillBox(20*CELL_WIDTH,20*CELL_HEIGHT,(20+1)*CELL_WIDTH,(20+1)*CELL_HEIGHT,red)
    Draw.FillBox(1*CELL_WIDTH,1*CELL_HEIGHT,(1+1)*CELL_WIDTH,(1+1)*CELL_HEIGHT,green)
    
    Draw.FillBox(maxx-Font.Width("Done", font),0,maxx,50,red)
    Draw.Text("Done",maxx-Font.Width("Done", font),0,font,black)
    exit when PtInRect(mX,mY, maxx-Font.Width("Done", font),0,maxx,50) and mB = 1

    %put "X: ",pX,", Y: ",pY
    lMB := mB
    View.Update()
    cls()
    delay(10)
end loop

const ENDX : int := 20
const ENDY : int := 20

var openSet : flexible array 0..0 of coord

openSet(0).x := 1
openSet(0).y := 1

%Draw.FillBox(x*CELL_WIDTH,y*CELL_HEIGHT,(x+1)*CELL_WIDTH,(y+1)*CELL_HEIGHT,cyan)

var done : boolean := false
var a : int := 0

loop
    exit when done
    
    var lowestF : real := 1000000
    var bestX,bestY,bestI:int:= 0
    Draw.FillBox(openSet(a).x*CELL_WIDTH,openSet(a).y*CELL_HEIGHT,(openSet(a).x+1)*CELL_WIDTH,(openSet(a).y+1)*CELL_HEIGHT,blue)
    Draw.Text(intstr(grid(openSet(a).x,openSet(a).y).gScore),openSet(a).x*CELL_WIDTH+2,openSet(a).y*CELL_HEIGHT+2,font2,white)
    grid(openSet(a).x,openSet(a).y).closed := true
    for addX : -1..1
        for addY : -1..1
            var x : int := openSet(a).x+addX
            var y : int := openSet(a).y+addY
            if (not grid(x,y).wall and not grid(x,y).closed) then
                new openSet, upper(openSet)+1
                openSet(upper(openSet)).x := x
                openSet(upper(openSet)).y := y
                Draw.FillBox(x*CELL_WIDTH,y*CELL_HEIGHT,(x+1)*CELL_WIDTH,(y+1)*CELL_HEIGHT,red)
                Draw.Text(intstr(grid(x,y).gScore),x*CELL_WIDTH+2,y*CELL_HEIGHT+2,font2,white)
                grid(x,y).fScore := grid(openSet(a).x,openSet(a).y).gScore +1
            end if
        end for
    end for
    
    for i : 0..upper(openSet)
            if (not grid(openSet(i).x,openSet(i).y).wall and not grid(openSet(i).x,openSet(i).y).closed) then
                if (grid(openSet(i).x,openSet(i).y).fScore < lowestF) then
                    bestX := openSet(i).x
                    bestY := openSet(i).y
                    bestI := i
                    lowestF:=grid(openSet(i).x,openSet(i).y).fScore
                    if (openSet(i).x = ENDX and openSet(i).y = ENDY) then
                        done:=true
                    end if
                end if
            end if
    end for
    
    %grid(openSet(bestI).x,openSet(bestI).y).gScore := grid(openSet(a).x,openSet(a).y).gScore +1
    a := bestI
    put openSet(a).x,", ",openSet(a).y
    Text.Locate(1,1)
    View.Update()
end loop

var cur:coord

cur.x := ENDX
cur.y := ENDY

var Directions : flexible array 0..0 of coord

var lowestG : int := grid(cur.x,cur.y).gScore
delay(10000)
loop
    Draw.FillBox(cur.x*CELL_WIDTH,cur.y*CELL_HEIGHT,(cur.x+1)*CELL_WIDTH,(cur.y+1)*CELL_HEIGHT,yellow)
    Draw.Text(intstr(grid(cur.x,cur.y).gScore),cur.x*CELL_WIDTH+2,cur.y*CELL_HEIGHT+2,font2,black)
    new Directions, upper(Directions)+1
    Directions(upper(Directions)) := cur
    for addX : -1..1
        for addY : -1..1
            var x : int := cur.x+addX
            var y : int := cur.y+addY
            if (not grid(x,y).wall) then
                if (grid(x,y).gScore < lowestG) then
                    cur.x := x
                    cur.y := y
                    lowestG := grid(x,y).gScore
                end if
            end if
        end for
    end for
    View.Update()
end loop






