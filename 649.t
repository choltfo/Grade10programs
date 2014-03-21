
var Font1 := Font.New ("Arial:10")
var Font24 := Font.New ("Arial:24")

var Cash : int := 100

var Toggle : string := "yes"

function getNumber (x,y,font,c,bgc : int) : int
    var chars : array char of boolean
    var formerChars : array char of boolean
    var output : int := 0
    Draw.FillBox(x-2,y-2,maxx,y+45,bgc)
    Font.Draw("-> " + intstr(output),x,y,font,c)
    Font.Draw("Please enter a number",x,y+25,font,c)
    Input.KeyDown (chars)
    formerChars := chars
    
    loop
        Input.KeyDown (chars)
        for i : 48 .. 57
            if (chars(cheat(char,i)) and not formerChars(cheat(char,i)) ) then
                output := (output*10)+(i-48)
                Draw.FillBox(x,y-1,maxx,y+22,bgc)
                Font.Draw("-> " + intstr(output),x,y,font,c)
                
            end if
        end for
            
        if (chars(cheat(char,8)) and not formerChars(cheat(char,8)) ) then
            output := floor(output/10)
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + intstr(output),x,y,font,c)
        end if
        if (chars(cheat(char,10)) and not formerChars(cheat(char,10)) ) then
            result output
        end if
        formerChars := chars
    end loop
end getNumber

loop
    
    var Rands : array 1..6 of int
    var SortedRands : array 1..6 of int
    var Choices : array 1..6 of int
    
    var Min : int := 1
    var Max : int := 49
    
    
    for i : 1..upper(SortedRands)
        SortedRands(i) := 0
        Choices(i) := 0
    end for
    
    Draw.FillBox(0,0,maxx,maxy,green)
    %put "You are now playing ", upper(Rands) , "-", Max,"."
    Draw.Text("You are now playing "+ intstr(upper(Rands)) + "-"+intstr(Max)+".",50,maxy-50,Font1,black)
    %put "Your guesses must be between ", Max, " and ", Min, "."
    Draw.Text("Your guesses must be between "+ intstr(Min) + " and "+intstr(Max)+".",50,maxy-70,Font1,black)
    delay(1000)
    Toggle := "yes"
    Cash -= 3
    for i : 1..upper(Choices)
        Font.Draw("Pleas enter guess #"+ intstr(i)+".",50,maxy-15,Font1,black)
        Choices(i) := getNumber(50,maxy-150,Font1,black,green)
        var Valid : boolean := true
        loop
            Valid := true
            for o : 1..i
                if (o not= i) then
                    if (Choices(i) = Choices(o)) then
                        Valid := false
                        %Draw.FillBox(0,0,maxx,maxy,green)
                        put "You have already selected that number, try again."
                        Choices(i) := getNumber(50,maxy-150,Font1,black,green)
                    end if
                end if
            end for
                
            if (i = 1) then
                Valid := true
            end if
            
            if (Choices(i) < Min) then
                %Draw.FillBox(0,0,maxx,maxy,green)
                put "That number is lower than the minimum of ", Min,". Please enter another number."
                Valid := false
                Choices(i) := getNumber(50,maxy-150,Font1,black,green)
            end if
            if (Choices(i) > Max) then
                %Draw.FillBox(0,0,maxx,maxy,green)
                put "That number is higher than the maaximum of ", Max,". Please enter another number."
                Valid := false
                Choices(i) := getNumber(50,maxy-150,Font1,black,green)
            end if
            %Draw.FillBox(0,0,maxx,maxy,green)
            exit when Valid
        end loop
    end for
        
    % Okay, we have all of the choices now. So, now to generate some other stuff.
    
    Draw.FillBox(0,0,maxx,maxy,green)
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


put "Thank you for playing, and forking over gobloads of cash!"
