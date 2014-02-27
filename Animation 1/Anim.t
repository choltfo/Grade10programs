View.Set("Graphics:600;400,offscreenonly")
var frameMillis := 1

class Platform
    import frameMillis
    export (x1,x2,y,r,c,Setup,Update)
    
    var x1,x2,y,r,c : int := red
    
    procedure Update ()
        Draw.FillBox(x1,y+5,x2,y-5,c)
    end Update
    
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
    procedure update()
        
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
    var TitleText : string := "This is a program."
    
    Draw.FillBox(0,0,maxx,maxy,white)
    for i : 1..10
        balls(i) -> handlePlatCol(p)
        balls(i) -> update()
    end for
    p -> Update()
    View.Update()
    loop
        exit when (LastFrame + frameMillis) < Time.Elapsed
    end loop
    LastFrame := Time.Elapsed
end loop

