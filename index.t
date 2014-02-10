% Usage of the "index" function

function endsWith (x,a : string) : boolean
    result index (x,a) = length(x)
end endsWith

function toUpperCase (x : string) : string
    var lowerCaseString : string := ""
    for i : 1 .. length (x)
        if ord (x (i)) > 96 then
            lowerCaseString += chr ( ord (x (i)) - 32)
        else
            lowerCaseString += x(i)
        end if
    end for
    result lowerCaseString
end toUpperCase

function toLowerCase (x : string) : string
    var lowerCaseString : string := ""
    for i : 1 .. length (x)
        if ord (x (i)) < 96 then
            lowerCaseString += chr ( ord (x (i)) + 32)
        else
            lowerCaseString += x(i)
        end if
    end for
    result lowerCaseString
end toLowerCase

put endsWith("asdf","F")
put "asdf"
put endsWith(toUpperCase("asdf"),"F")
put toUpperCase("asdf")
put endsWith(toLowerCase("ASDF"),"f")
put toUpperCase("ASDF")
