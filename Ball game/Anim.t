View.Set("Graphics:600;400,offscreenonly")
var frameMillis := 1

var x,y,button : int := 0



function PtInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        result PtInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        result PtInRect(x,y,x1,y2,x2,y1)
    end if
    result (x > x1) and (x < x2) and (y > y1) and (y < y2)
end PtInRect

/*function ptinrect(h,v,x1,v1,x2,v2:int):boolean
result  (h > x1) and (h < x2) and (v > v1) and (v < v2)
end ptinrect*/

class Platform
    import frameMillis, PtInRect
    export (x1,x2,y,r,c,Setup,Update,mouseClickedOn)
    
    var x1,x2,y,r,c : int := red
    
    procedure Update ()
        Draw.FillBox(x1,y-5,x2,y+5,c)
    end Update
    
    
    function mouseClickedOn(x,y,button : int): boolean
        result PtInRect(x,y,x1,y-5,x2,y+5) and button not= 0
    end mouseClickedOn
    
    proc Setup(X1,X2,Y,C : int)
        x1 := X1
        x2 := X2
        y  := Y
        c  := c
    end Setup
    
end Platform

class ball
    import frameMillis, Platform
    export (x,y,xspeed,yspeed,setPos,setVel,modVel,update,setColour,r,handlePlatCol)
    
    var r:=0
    var friction : real := 0.1
    
    var yspeed : real := (Rand.Real-0.5)*2000
    var xspeed : real := (Rand.Real-0.5)*2000
    
    var col := Rand.Int(0,255)
    
    var x,y : real := 100
    
    x := Rand.Real()*maxx
    y := Rand.Real()*maxy
    
    r := 5
    
    proc handlePlatCol (Wall : pointer to Platform)
        if (x+r > Platform(Wall).x1 and x-r < Platform(Wall).x2
            and y-5 < Platform(Wall).y+5 and y+5 > Platform(Wall).y-5) then
            yspeed := -yspeed
            %xspeed := -xspeed
        end if
        
    end handlePlatCol
    
    var selected : boolean := false
    var LastX, LastY : real := 0
    var DeltaX, DeltaY :real:= 0
    var LastB := false
    
    procedure update(MX, MY, MB : int)
        
        if (selected) then
            LastX := x
            LastY := y
            
            x := MX
            y := MY
            
            xspeed := LastX - x
            yspeed := LastY - y
            
            LastB := selected
        else
            x := x+(xspeed*(frameMillis/1000))
            y := y+(yspeed*(frameMillis/1000))
            
            yspeed := (yspeed * (1-(friction*(frameMillis/100)))) - 9.8
            xspeed := xspeed * (1-(friction*(frameMillis/100)))
            
            if y > maxy then
                yspeed := -yspeed * 0.9
                y := maxy
            end if
            if x > maxx then
                xspeed := -xspeed
                x := maxx
            end if
            
            if y < 0 then
                yspeed := -yspeed * 0.9
                y := 0
            end if
            if x < 0 then
                xspeed := -xspeed
                x := 0
            end if
            
            LastB := selected
            
        end if
        
        selected := ((MX-x)*(MX-x))+((MY-y)*(MY-y)) < r*r and MB = 1
        
        
        Draw.FillOval(round(x),round(y), 5,5, col)
        Draw.Oval(round(x),round(y), 5,5, black)
            
        
    end update
    
    procedure setPos(X,Y : int)
        x := X
        y := Y
    end setPos
    
    procedure setVel(X,Y : real)
        xspeed := X
        yspeed := Y
    end setVel
    
    procedure modVel(X,Y : real)
        xspeed := xspeed + X
        yspeed := yspeed + Y
    end modVel
    
    procedure setColour (c : int)
        col := c
    end setColour
    
end ball




var balls : array 1..10 of pointer to ball

for i : 1..10
    new ball, balls(i)
end for
    
var p : pointer to Platform
new Platform, p

p -> Setup(100,maxx-100,round(maxy/2),red)

% Fake loading bar

for i : 1..100
    var filename : string := ("Loading screen " + intstr(i)+ ".bmp")
    %Draw.FillBox(0,0,maxx,maxy,black)
    Pic.ScreenLoad(filename,0,0,0)
    Draw.FillBox(100,0,100+round(((maxx-200)*(i/100))),100,green)
    View.Update()
    delay(10)
end for
    
var LastFrame := Time.Elapsed

loop
    Mouse.Where(x,y,button)
    var TitleText : string := "This is a program."
    
    var boxClicked : boolean := not p -> mouseClickedOn(x,y,button)
    
    Draw.FillBox(0,0,maxx,maxy,white)
    for i : 1..10
        if (boxClicked) then
            balls(i) -> handlePlatCol(p)
        end if
        balls(i) -> update(x,y,button)
    end for
        
    if (boxClicked) then
        p -> Update()
    end if
    
    %Draw.FillBox(0,0,10,10,red)
    View.Update()
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
end loop

