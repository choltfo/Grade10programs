% A system for showing information between levels

module cutscene

export line,lines,displayLines,addLine

type line : record
    text : string
    del: int % in Millis
    clear: boolean
    endCS: boolean
end record

var lines : flexible array 1..0 of line

proc addLine (text : string,del : int, clear, ECS : boolean)
    new lines, upper(lines) + 1
    lines(upper(lines)).text := text
    lines(upper(lines)).del := del
    lines(upper(lines)).clear := clear
    lines(upper(lines)).endCS := ECS
end addLine

var CSLoop := 0

proc displayLines
    cls
    View.Update
    var font : int
    font := Font.New("Arial:24")
    var y := 100
    loop
        exit when CSLoop >= upper(lines)
        CSLoop += 1
        Draw.FillBox(0,0,maxx,maxy,white)
        Draw.Text(lines(CSLoop).text,40,maxy-y,font,black)
        View.Update
        delay(lines(CSLoop).del)
        
        if (lines(CSLoop).clear) then
            cls
            y := 100
        end if
        y := y-24
        exit when lines(CSLoop).endCS
        exit when CSLoop = upper(lines)
    end loop
end displayLines
end cutscene