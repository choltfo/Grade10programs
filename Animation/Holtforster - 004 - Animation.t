View.Set("offscreenonly")
%Pic.SetTransparentColour(white)

var Semi0 := Pic.FileNew("Semi-0.bmp")

var SemiFrames : array 1..3 of int := init (0,0,0)

function moonSunArc (x : int) : int
    result round((x-(maxx/2))*(x-(maxx/2))/-1000)+maxy
end moonSunArc

Pic.SetTransparentColour(Semi0,white)
for i : 1..upper(SemiFrames)
    SemiFrames(i) := Pic.FileNew("Semi-"+intstr(i)+".bmp")
    Pic.SetTransparentColour(SemiFrames(i),white)
end for
    
var t,SemiX := 0
var x, y, button :int

function PtInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        result PtInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        result PtInRect(x,y,x1,y2,x2,y1)
    end if
    result (x > x1) and (x < x2) and (y > y1) and (y < y2)
end PtInRect

var frameMillis : int := 100

var LastFrame:int:=0

var moving : boolean := false
var semiFrame : int := 1
var semiMaxFrame : int := 3


loop
    Mouse.Where (x, y, button)
    
    if t > maxx then
        % Sky
        Draw.FillBox(0,0,maxx,maxy,black)
        Draw.FillOval(round((t mod maxx)),moonSunArc(round((t mod maxx))), 10,10,white)
    else
        % Sun
        Draw.FillBox(0,0,maxx,maxy,blue)
        Draw.FillOval(round(t),moonSunArc(round(t)), 20,20,yellow)
    end if
    
    moving := PtInRect(x,y,0,0,150,100) and button = 1
    
    if (moving) then
        SemiX+=5
        Pic.Draw(SemiFrames(semiFrame), 0,0, picMerge)
        semiFrame := ((semiFrame)mod(semiMaxFrame)) +1
    else
        Pic.Draw(Semi0, 0,0, picMerge)
    end if
    
    Draw.FillBox(0,0,maxx,19,gray)
    
    View.Update
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
    t := (t+1) mod (maxx*2)
end loop
