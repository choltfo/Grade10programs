var chars : array char of boolean

loop
    Input.KeyDown (chars)
    for i : 1..upper(chars)
        if (chars(chr(i))) then
            put i
            put chr(i)
        end if
    end for
end loop