
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
    Time.Delay(10) % Slow it down a tad.
    
    yRot := yRot + x
    
    Draw.FillOval(CPX, CPY, 10,10, red)
    Draw.Line(CPX+10, CPY+10, CPX-10, CPY-10, black)
    
    % Spin that box!
    
end loop