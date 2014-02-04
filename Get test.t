put "Hello gentleman"
put "welcome to poker"

var name : string
var sure : boolean := false
var coins : real

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
    put "How many coins do you have? (1-1000)"..
    get coins
    put "You have ", coins, " coins? Are you sure about that? (true/false) "..
    get sure
end loop

for i : 1..round(coins)
    Draw.Dot(round(i/(maxy/2)), round(i mod (maxy/2)), yellow)
end for