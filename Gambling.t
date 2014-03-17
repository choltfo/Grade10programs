% Array storage

%View.Set("offscreenonly")

var font1 := Font.New ("Arial:10")

var Rands : array 1..6 of int
var Choices : array 1..6 of int

var Max : int := 10
var Min : int := 1


put "Welcome to the casino!"
put "Your guesses must be between ", Max, " and ", Min, "."

loop
    for i : 1..upper(Choices)
        put "Pleas enter guess #", i,"."
        get Choices(i)
        var Valid : boolean := true
        loop
            Valid := true
            for o : 1..i
                if (o not= i) then
                    if (Choices(i) = Choices(o)) then
                        Valid := false
                        put "You have already selected that number, try again."
                        get Choices(i)
                    end if
                end if
            end for
                
            if (i = 1) then
                Valid := true
            end if
            
            exit when Valid
        end loop
        
        loop
            Valid := true
            if (Choices(i) < Min) then
                put "That number is lower than the minimum of ", Min,". Please enter another number."
                Valid := false
                get Choices(i)
            end if
            if (Choices(i) > Max) then
                put "That number is higher than the maaximum of ", Max,". Please enter another number."
                Valid := false
                get Choices(i)
            end if
            
            exit when Valid
        end loop
    end for
    
    % Okay, we have all of the choices now. So, now to generate some other stuff.
    
    cls()
    put "Your choices are"
    
    for i : 1..upper(Choices)
        put Choices(i)
    end for
    
    put "And the random picks are..."
    
    for i : 1..upper(Rands)
        var INT := 0
        var Valid := true
        loop
            Valid := true
            for o : 1..i
                if (o not= i) then
                    if (Rands(i) = Rands(o)) then
                        Valid := false
                        INT := Rand.Int(Min,Max)
                    end if % THIS IS BROKEN, IT HANGS FREOM HRER.
                end if
            end for
        end loop
        
        Rands(i) := INT
    end for
    
    for i : 1..upper(Rands)
        put Rands(i)
        put "asdf"
    end for
    
    
    
    exit when true
end loop


