import joystick

type joypad : % create a joypad type
    record
        button : array 1 .. 32 of boolean %create 32 instances of buttons
        pos : joystick.PosRecord /*used to find all joypad intake with
         the exception of buttons*/
        caps : joystick.CapsRecord %used to find the max on joypad analog
    end record

var joy : array 1 .. 2 of joypad %create an array of joypad

/*set default joypad varibles*/
for i : 1 .. upper (joy)
    for ii : 1 .. upper (joy (i).button)
        joy (i).button (ii) := false
    end for
    joy (i).pos.POV := 66535
    joystick.Capabilities (i - 1, joy (i).caps)
end for

loop
    Draw.Cls()
    put (joystick.GetInfo (joystick[1], joy ([1/2]).button))
    
end loop