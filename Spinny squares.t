
View.Set("offscreenonly")

var CPX := round(maxx/2)
var CPY := round(maxy/2)

var yRot : real := 0

loop
    
    var chars : array char of boolean
    var x,y : real := 0
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
    
    yRot := yRot - (x/4)
    
    Draw.FillBox(0,0,maxx,maxy,black)
    Draw.FillOval(CPX, CPY, 50,50, red)

    
    Draw.Line(CPX+round(50*cosd(yRot+270)),CPY+round(50*sind(yRot+270)),
                CPX+round(50*cosd(yRot)),CPY+round(50*sind(yRot)),black)
    Draw.Line(CPX+round(50*cosd(yRot+180)),CPY+round(50*sind(yRot+180)),
                CPX+round(50*cosd(yRot)),CPY+round(50*sind(yRot)),black)
    Draw.Line(CPX+round(50*cosd(yRot+90)),CPY+round(50*sind(yRot+90)),
                CPX+round(50*cosd(yRot)),CPY+round(50*sind(yRot)),black)
    Draw.Line(CPX+round(50*cosd(yRot+270)),CPY+round(50*sind(yRot+270)),
                CPX+round(50*cosd(yRot+180)),CPY+round(50*sind(yRot+180)),black)
    Draw.Line(CPX+round(50*cosd(yRot+270)),CPY+round(50*sind(yRot+270)),
                CPX+round(50*cosd(yRot+90)),CPY+round(50*sind(yRot+90)),black)
    Draw.Line(CPX+round(50*cosd(yRot+180)),CPY+round(50*sind(yRot+180)),
                CPX+round(50*cosd(yRot+90)),CPY+round(50*sind(yRot+90)),black)
    
    Draw.Dot(CPX+round(50*cosd(yRot)),CPY+round(50*sind(yRot)),green)
    Draw.Dot(CPX+round(50*cosd(yRot+90)),CPY+round(50*sind(yRot+90)),green)
    Draw.Dot(CPX+round(50*cosd(yRot+180)),CPY+round(50*sind(yRot+180)),green)
    Draw.Dot(CPX+round(50*cosd(yRot+270)),CPY+round(50*sind(yRot+270)),green)
    
    % Spin that box!
    View.Update()
    delay(5)
end loop