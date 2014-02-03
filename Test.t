var font1 := Font.New ("sans serif:18:bold")
assert font1 > 0
View.Set("Graphics:500:500")

var i := 1;

var frameMillis := 50
var accel :real := 0.1

class ball
    import frameMillis
    export x,y,xspeed,yspeed,setPos,setVel,modVel,update,setColour
    
    var r:=0
    var friction : real := 0.1
    
    var xspeed, yspeed : real := 0
    
    var col := 1
    
    var x,y := 100
    
    r := 5
    
    procedure update()
	
	x := round(x+(xspeed*(frameMillis/100)))
	y := round(y+(yspeed*(frameMillis/100)))
	
	yspeed := yspeed * (1-(friction*(frameMillis/100)))
	xspeed := xspeed * (1-(friction*(frameMillis/100)))
	
	if y > maxy then
	    yspeed := -yspeed
	end if
	if x > maxx then
	    xspeed := -xspeed
	end if
	
	if y < 0 then
	    yspeed := -yspeed
	end if
	if x < 0 then
	    xspeed := -xspeed
	end if
	
	Draw.Oval(x,y, 5,5, red)
	
	
	
    end update
    
    procedure setPos(var X,Y : int)
	x := X
	y := Y
    end setPos
    
    procedure setVel(var X,Y : int)
	xspeed := X
	yspeed := Y
    end setVel
    
    procedure modVel(var X,Y : real)
	xspeed := xspeed + X
	yspeed := yspeed + Y
    end modVel
    
    procedure setColour (var c : int)
	col := c
    end setColour
    
end ball

var PLR : pointer to ball
new ball, PLR

loop
    var chars : array char of boolean
    
    var x,y : real := 0
    
    
    Input.KeyDown (chars)
	    if chars (KEY_UP_ARROW) then
	      %  put "Up Arrow Pressed  " ..
	      y := y+(accel*frameMillis)
	    end if
	    if chars (KEY_RIGHT_ARROW) then
	       % put "Right Arrow Pressed  " .
	       x := x+(accel*frameMillis)
	    end if
	    if chars (KEY_LEFT_ARROW) then
	     %   put "Left Arrow Pressed  " ..
	     x := x-(accel*frameMillis)
	    end if
	    if chars (KEY_DOWN_ARROW) then
	     %   put "Down Arrow Pressed  " ..
	     y := y-(accel*frameMillis)
	    end if
    PLR -> modVel (x,y)
    
    Draw.FillBox(0,0,maxx,maxy, 0)
    %Draw.Text("Hello World!", 0,maxy-18, font1 ,black)
    %var a := sqrt(1000)
    
    PLR -> update()
    Time.Delay(frameMillis)
    i := (i+1) mod 255
end loop
