var asdf : string :="asdf"

var x,y,button,lmb := 0
Mouse.Where(x,y,button)

Rand.Set(669899503)

loop
    put Rand.Int(1,20)
    loop
        lmb := button
        Mouse.Where(x,y,button)
        exit when button not= 0 and lmb = 0
    end loop
end loop