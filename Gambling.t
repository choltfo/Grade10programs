% Array storage

% YOur chances are 1 over (49!)/(6!(49-6)!) = 1 over 13 million 983 thousand 816

%View.Set("offscreenonly")

var font1 := Font.New ("Arial:10")

var Cash : int := 100

var Toggle : string := "yes"

var game : int := 0

put "Welcome to the casino!"
loop    % Main Menu loop
    
    if (game = 0) then
        loop
            cls
            put "Welcome to the casino!"
            put "Which game would you like to play?"
            put "1: 6-49        (Costs $3)"
            put "2: Dice-roll   (Cost varies)"
            get game
            exit when game not=0 and game < 3
            cls()
            put "Invalid selection."
        end loop
    end if
    
    if game = 1 then   % 6-49 loop, Game 1
        loop
            
            var Rands : array 1..6 of int
            var SortedRands : array 1..6 of int
            var Choices : array 1..6 of int
            
            var Min : int := 1
            var Max : int := 49
            
            
            for i : 1..upper(SortedRands)
                SortedRands(i) := 0
            end for
                
            cls()
            put "You are now playing ", upper(Rands) , "-", Max,"."
            put "Your guesses must be between ", Max, " and ", Min, "."
            Toggle := "yes"
            Cash -= 3
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
                    cls
                    exit when Valid
                end loop
            end for
                
            % Okay, we have all of the choices now. So, now to generate some other stuff.
            
            cls()
            put "Your choices are"
            
            for i : 1..upper(Choices)
                put Choices(i)
            end for
                
            for i : 1..upper(Rands)
                var INT := 0
                var Valid := true
                loop
                    INT := Rand.Int(Min,Max)
                    Rands(i) := INT
                    Valid := true
                    for o : 1..i
                        if (o not= i) then
                            if (Rands(i) = Rands(o)) then
                                Valid := false
                                INT := Rand.Int(Min,Max)
                            end if % THIS IS BROKEN, IT HANGS FREOM HRER.
                        end if
                    end for
                        exit when Valid
                end loop
                
                if (i = 1) then
                    Valid := true
                end if
                
                Rands(i) := INT
            end for
                
            for i : 1..upper(Rands)
                
                var highest, ind : int := 0
                
                for o : 1..upper(Rands)
                    if (Rands(o) > highest) then
                        highest := Rands(o)
                        ind := o
                    end if
                end for
                    
                Rands(ind) := 0
                SortedRands (i) := highest
                
            end for
                
            delay(1000)
            put "And the random picks are..."
            
            for i : 1..upper(SortedRands)
                put SortedRands(i)
            end for
                
            
            var matches : int := 0
            
            for i : 1..upper(Choices)
                for o : 1..upper(SortedRands)
                    if (Choices(i) = SortedRands(o)) then
                        matches += 1
                    end if
                end for
            end for
                delay (1000)
            put "You got ", matches, " matches!"
            
            if    (matches > 0 and matches <= 2) then
                Cash += 0
            elsif (matches > 2 and matches <= 4) then
                Cash += 10
                put "You won $10!"
            elsif (matches > 4 and matches <= 5) then
                Cash += 100
                put "You won $15!"
            elsif (matches > 5 and matches <= 6) then
                Cash += 1000000
                put "You won $20!"
            end if
            
            put "Would you like to continue?"
            put "Costs $3, you have $",Cash,". (yes/no)"
            get Toggle
            
            exit when Toggle = "no"
        end loop
        game := 0
    end if
    
    if game = 2 then   % Dice loop, Game 1
        loop
            var diceSize : int := 0
            var sure := false
            loop
                exit when sure
                put "Okay, so how many sides do you want on a die? "..
                get diceSize
                put "Want to have a ", diceSize, " sided die. Are you sure about that? (true/false) "..
                get sure
            end loop
            
            loop
                var bet : int := 0
                sure := false
                loop
                    exit when sure
                    put "How much Cash do you want to bet? ($1-$",Cash,")"..
                    get bet
                    put "You have $", Cash, ", and you want to bet $",bet,". Are you sure about that? (true/false) "..
                    get sure
                end loop
                Cash := Cash - bet
                
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
                    Cash := Cash + (bet*diceSize)
                    put "Success! The die came up as ", guess, ", just like you expected! You win ", (bet*diceSize), ". You now have $", Cash
                else
                    put "You were wrong. The correct answer was ", r,". You now only have $",Cash,"."
                end if
                
                put "Would you like to play again?"
                get 
                
            end loop
        end loop
    end if


    put "Goodbye, and thank you for playing!"

end loop