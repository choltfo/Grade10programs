put "Sphere calculator"

var name : string
var sure : boolean := false
var r : real

sure := false
loop
    exit when sure
    put "What is your name? "..
    get name
    put "Your name is ", name, "? Are you sure about that? (true/false) "..
    get sure
end loop

sure := false
loop
    exit when sure
    put "Okay ", name, ". What is the radius of the sphere? "..
    get r
    put "The radius is ", r, "? Are you sure about that? (true/false) "..
    get sure
end loop

procedure sphereCalc
    put "Okay then ", name, ", the radius of the circle is ", r, "."
    put "The diameter is ", 2*r, "."
    var volume : real := ((4/3)*Math.PI*r*r*r)
    put "And the volume is ", volume:3, "."
end sphereCalc



sphereCalc
