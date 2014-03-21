
var Font24 := Font.New ("Arial:24")

function getNumber (x,y,font,c,bgc : int) : int
    var chars : array char of boolean
    var formerChars : array char of boolean
    var output : int := 0
    Font.Draw("-> " + intstr(output),x,y,font,c)
    Font.Draw("Please enter a number",x,y+25,font,c)
    
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

put getNumber(50,maxy-50,Font24,red,white)
