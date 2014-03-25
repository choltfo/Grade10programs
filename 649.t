
View.Set("offscreenonly")

var Font1 := Font.New ("Arial:10")
var Font2 := Font.New ("Arial:18")

var Cash : int := 100

var Toggle : string := "yes"

function getNumber (prompt:string,x,y,font,c,bgc : int) : int
    var chars : array char of boolean
    var formerChars : array char of boolean
    var output : int := 0
    Draw.FillBox(x-2,y-2,maxx,y+45,bgc)
    Font.Draw("-> " + intstr(output),x,y,font,c)
    Font.Draw(prompt,x,y+25,font,c)
    Input.KeyDown (chars)
    formerChars := chars
    View.Update()
    loop
        Input.KeyDown (chars)
        for i : 48 .. 57
            if (chars(cheat(char,i)) and not formerChars(cheat(char,i)) ) then
                output := (output*10)+(i-48)
                Draw.FillBox(x,y-1,maxx,y+22,bgc)
                Font.Draw("-> " + intstr(output),x,y,font,c)
                View.Update()
            end if
        end for
            
        if (chars(cheat(char,8)) and not formerChars(cheat(char,8)) ) then
            output := floor(output/10)
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + intstr(output),x,y,font,c)
            View.Update()
        end if
        if (chars(cheat(char,10)) and not formerChars(cheat(char,10)) ) then
            View.Update()
            result output
        end if
        formerChars := chars
        View.Update()
    end loop
end getNumber

loop
    
    var Rands : array 1..6 of int
    var SortedRands : array 1..6 of int
    var Choices : array 1..6 of int
    var SortedChoices : array 1..6 of int
    
    var Min : int := 1
    var Max : int := 49
    
    Cash -= 3
    
    for i : 1..upper(SortedRands)
        SortedRands(i) := 0
        Choices(i) := 0
    end for
        
    Draw.FillBox(0,0,maxx,maxy,white)
    %put "You are now playing ", upper(Rands) , "-", Max,"."
    Draw.Text("You are now playing "+ intstr(upper(Rands)) + "-"+intstr(Max)+".",50,maxy-25,Font2,black)
    %put "Your guesses must be between ", Max, " and ", Min, "."
    Draw.Text("Your guesses must be between "+ intstr(Min) + " and "+intstr(Max)+".",50,maxy-50,Font2,black)
    Draw.Text("Cash: $" + intstr(Cash),maxx-100,maxy-50,Font1,black)
    View.Update()
    delay(1000)
    Toggle := "yes"
    for i : 1..upper(Choices)
        Choices(i) := getNumber("Please enter guess #"+ intstr(i)+".",50,maxy-200,Font1,black,white)
        var Valid : boolean := true
        loop
            Valid := true
            for o : 1..i
                if (o not= i) then
                    if (Choices(i) = Choices(o)) then
                        Valid := false
                        Choices(i) := getNumber("You have already selected that number, try again.",50,maxy-200,Font1,black,white)
                    end if
                end if
            end for
                
            if (i = 1) then
                Valid := true
            end if
            
            if (Choices(i) < Min) then
                Valid := false
                Choices(i) := getNumber("That number is lower than the minimum of "+intstr(Min)+". Please enter another number.",50,maxy-200,Font1,black,white)
            end if
            if (Choices(i) > Max) then
                Valid := false
                Choices(i) := getNumber("That number is higher than the maximum of "+intstr(Max)+". Please enter another number.",50,maxy-200,Font1,black,white)
            end if
            
            exit when Valid
        end loop
        Draw.FillBox(50,maxy-200,maxx,maxy-155,white)
        View.Update
    end for
    
    for i : 1..upper(Choices)
        
        var highest, ind : int := 0
        
        for o : 1..upper(Choices)
            if (Choices(o) > highest) then
                highest := Choices(o)
                ind := o
            end if
        end for
            
        Choices(ind) := 0
        SortedChoices (i) := highest
        
    end for
    
    for i : 1..upper(SortedChoices)
        Draw.Text("#"+intstr(i) + ": " + intstr(SortedChoices(i)),50,maxy-50-(15*i),Font1,black)
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
                    end if
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
        
    
    
    % Okay, so here is where we need to draw all of the cool stuff
    Draw.Text("The winning numbers:",50,maxy-160,Font1,black)
    
    for i : 1..upper(SortedRands)
        Draw.Text("#"+intstr(i) + ": " + intstr(SortedRands(i)),50,maxy-160-(15*i),Font1,black)
    end for
        View.Update()
    
    var matches : int := 0
    
    for i : 1..upper(Choices)
        for o : 1..upper(SortedRands)
            if (Choices(i) = SortedRands(o)) then
                matches += 1
            end if
        end for
    end for
        delay (1000)
    Draw.Text("You got "+ intstr(matches) + " matches!",50,maxy-270,Font1,black)
    if    (matches > -1 and matches <= 0) then
        Cash += 0
    elsif (matches > 0 and matches <= 1) then
        Cash += 5
        Draw.Text("You have won $5!",50,maxy-285,Font1,black)
    elsif (matches > 1 and matches <= 2) then
        Cash += 10
        Draw.Text("You have won $10!",50,maxy-285,Font1,black)
    elsif (matches > 2 and matches <= 3) then
        Cash += 15
        Draw.Text("You have won $15!",50,maxy-285,Font1,black)
    elsif (matches > 3 and matches <= 4) then
        Cash += 200
        Draw.Text("You have won $200!",50,maxy-285,Font1,black)
    elsif (matches > 4 and matches <= 5) then
        Cash += 1000
        Draw.Text("You have won $1000!",50,maxy-285,Font1,black)
    elsif (matches > 5 and matches <= 6) then
        Cash += 100000000
        Draw.Text("You have won $100,000,000! Congratulations!",50,maxy-285,Font1,black)
    end if
    Draw.FillBox(maxx-105,maxy-55,maxx,maxy,white)
    Draw.Text("Cash: $" + intstr(Cash),maxx-100,maxy-50,Font1,black)
    View.Update
    
    Draw.Text("Would you like to continue?",50,maxy-300,Font1,black)
    Draw.Text("Costs $3, you have $"+intstr(Cash)+". (y/n)",50,maxy-315,Font1,black)
    View.Update
    
    var chars : array char of boolean
    Input.KeyDown (chars)
    var continue : boolean := false
    
    loop
        Input.KeyDown (chars)
        if (chars('y')) then
            continue := true
        end if
        if (chars('n')) then
            continue := false
        end if
                        % Y               N
        exit when chars ('y') or chars  ('n')
    end loop
    cls
    exit when continue = false
end loop

cls
put "Thank you for playing, and forking over gobloads of cash!"
put "You made $", Cash-100
