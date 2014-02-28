% Okay, so we want some physics.... What could possibly go wrong?


var font1 := Font.New ("sans serif:18:bold")
assert font1 > 0
View.Set("offscreenonly")

var frameMillis := 10
var accel : real := 0.1


class ball
    import frameMillis
    export x,y,xspeed,yspeed,setPos,setVel,modVel,update,setColour,r
    
    var r:=0
    var friction : real := 0.1
    
    var yspeed : real := (Rand.Real-0.5)*200
    var xspeed : real := (Rand.Real-0.5)*200
    
    var col := Rand.Int(0,255)
    
    var x,y := 100
    
    x := Rand.Int(0,maxx)
    y := Rand.Int(0,maxy)
    
    r := 5
    
    procedure update(HL : boolean)
        
        x := floor( x+(xspeed*(frameMillis/100)) )
        y := floor( y+(yspeed*(frameMillis/100)) )
        
        yspeed := yspeed * (1-(friction*(frameMillis/100)))
        xspeed := xspeed * (1-(friction*(frameMillis/100)))
        
        if y > maxy then
            yspeed := -yspeed
            y := maxy - 1
        end if
        if x > maxx then
            xspeed := -xspeed
            x := maxx - 1 
        end if
        
        if y < 0 then
            yspeed := -yspeed
            y := 1
        end if
        if x < 0 then
            xspeed := -xspeed
            x := 1
        end if
        
        
        
        if (HL) then
            Draw.FillOval(x,y, 5,5, col)
            Draw.Oval(x,y, 5,5, black)
        else
            Draw.Oval(x,y, 5,5, col)
        end if
        
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

var PLR : pointer to ball
new ball, PLR

proc CheckCollision (ball1, ball2 : pointer to ball)
    
    if ((ball (ball1).r + ball (ball2).r) * (ball (ball1).r + ball (ball2).r)) >=
        ( ((ball (ball1).x - ball (ball2).x)*(ball (ball1).x - ball (ball2).x)) + ( (ball (ball1).y - ball (ball2).y) * (ball (ball1).y - ball (ball2).y)) ) then
        
        %Draw.FillBox(0,0,maxx,maxy,Rand.Int(0,255))
        
        var x : real := ball(ball1).xspeed
        var y : real := ball(ball1).yspeed
        var x2 : real := ball(ball2).xspeed
        var y2 : real := ball(ball2).yspeed
        
        /*
        % slope A is the incoming vector representing the balls velocity. As radians
        var slopeA : real := 90
        if ball(ball1).xspeed not= 0 then
        slopeA := arctan(ball(ball2).yspeed/ball(ball1).xspeed)
        end if
        
        % slope B is the slope of the line between the two balls. As degrees
        var slopeB : real := 90
        if (ball(ball2).x-ball(ball1).x) not= 0 then
        slopeB := arctand((ball(ball2).y-ball(ball1).y)/(ball(ball2).x-ball(ball1).x))
        end if
        
        % slope C is the slopeA reflected across slopeB as radians
        var slopeC : real := slopeB - (slopeA - slopeB)
        
        var mag :real := sqrt((x*x)*(y*y))
        
        ball1 -> setVel(-cosd(slopeC)*mag,-sind(slopeC)*mag)
        ball2 -> setVel(cosd(slopeC)*mag,sind(slopeC)*mag)
        */
        
        ball2 -> setVel(x,y)
        ball1 -> setVel(x2,y2)
    end if
    
end CheckCollision


for i : 1..10
    new ball, balls(i)
end for
    
loop
    var chars : array char of boolean
    
    var x,y : real := 0
    
    for i : 1..10
        if i not= 10 then
            for o : (i+1)..10
                CheckCollision(balls(i), balls(o))
            end for
        end if
        CheckCollision(balls(i), PLR)
    end for
        
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) then
        %  put "Up Arrow Pressed  " ..
        y := 1
    end if
    if chars (KEY_RIGHT_ARROW) then
        % put "Right Arrow Pressed  " .
        x := 1
    end if
    if chars (KEY_LEFT_ARROW) then
        %   put "Left Arrow Pressed  " ..
        x := -1
    end if
    if chars (KEY_DOWN_ARROW) then
        %   put "Down Arrow Pressed  " ..
        y := -1
    end if
    if (x not= 0) then
        var tannedX := abs(cos(arctan(y/x)))*(accel*frameMillis)*x
        var tannedY := abs(sin(arctan(y/x)))*(accel*frameMillis)*y
        
        
        PLR -> modVel (tannedX, tannedY)
    else
        PLR -> modVel (x,y)
    end if
    
    
    
    Draw.FillBox(0,0,maxx,maxy, 0)
    
    %Draw.Text("Hello World!", 0,maxy-18, font1 ,black)
    %var a := sqrt(1000)
    
    
    PLR -> update(true)
    
    for i : 1..10
        balls(i) -> update(false)
    end for
        
    Time.Delay(frameMillis)
    View.Update()
end loop
