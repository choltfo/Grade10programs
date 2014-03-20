var asdf : string :="asdf"

var x,y,button := 0
Mouse.Where(x,y,button)

loop
    cls
    put Rand.Int(1,20)
    loop
        Mouse.Where(x,y,button)
        exit when button not= 0
    end loop
end loop