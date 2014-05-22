

function getString (prompt:string,x,y,font,c,bgc : int) : string
    var chars : array char of boolean
    var formerChars : array char of boolean
    var output : string := ""
    Draw.FillBox(x-2,y-2,maxx,y+45,bgc)
    Font.Draw("-> " + output,x,y,font,c)
    Font.Draw(prompt,x,y+25,font,c)
    Input.KeyDown (chars)
    formerChars := chars
    View.Update()
    loop
        Input.KeyDown (chars)
        for i : 97 .. 122
            if (chars(chr(i)) and not formerChars(chr(i)) ) then
                if chars(cheat(char,180)) then
                    output += chr(i-32)
                else
                    output += chr(i)
                end if
                Draw.FillBox(x,y-1,maxx,y+22,bgc)
                Font.Draw("-> " + output,x,y,font,c)
                View.Update()
            end if
        end for
        if (chars(chr(32)) and not formerChars(chr(32)) ) then
            output += ' '
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + output,x,y,font,c)
            View.Update()
        end if
        
        
        if (chars(cheat(char,8)) and not formerChars(cheat(char,8)) ) then
            var newLine : string := ""
            for i : 1..length(output)-1
                newLine += output(i)
            end for
            output := newLine
            
            Draw.FillBox(x,y-1,maxx,y+22,bgc)
            Font.Draw("-> " + output,x,y,font,c)
            View.Update()
        end if
        
        if (chars(cheat(char,10)) and not formerChars(cheat(char,10)) ) then
            View.Update()
            result output
        end if
        formerChars := chars
        View.Update()
    end loop
end getString

var f : int := Font.New("TimesNewRoman:12")

put getString("Enter your name: ",100,100,f,black,white)