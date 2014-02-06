put "Hello gentleman"
put "welcome to dice roller 2014"

var sure : boolean := false
var coins : real

var name : string
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
    put "Okay ",name,", how many coins do you have? (1-1000)"..
    get coins
    put "You have ", coins, " coins? Are you sure about that? (true/false) "..
    get sure
end loop

var diceSize : int := 0
sure := false
loop
    exit when sure
    put name," how many sides do you want on a die? "..
    get diceSize
    put "Want to have a ", diceSize, " sided die. Are you sure about that? (true/false) "..
    get sure
end loop

loop
    var bet : int := 0
    sure := false
    loop
        exit when sure
        put "How many coins do you want to bet? (1-",coins,")"..
        get bet
        put "You have ", coins, " coins, and you want to bet ",bet,". Are you sure about that? (true/false) "..
        get sure
    end loop
    coins := coins - bet
    
    var guess : int := 0
    sure := false
    loop
        exit when sure
        put "What do you think the dice is going to turn up as? (1-",diceSize,")"..
        get guess
        sure := true
    end loop
    
    var r := Rand.Int(1,diceSize)
    
    if (guess = r) then
        coins := coins + (bet*diceSize)
        put "Success! The die came up as ", guess, ", just like you expected! You win ", (bet*diceSize), ". You now have ", coins
    else
        put "You were wrong. The correct answer was ", r,". You now only have ",coins," coins."
    end if
    
end loop