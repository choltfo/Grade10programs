

function sum(n : real) : real
    if (n > 0) then
        result sum (n-1)+n
    else
        result 0
    end if
end sum

function mSum (n : real) : real
    result (n+n**2)/2
end mSum

var x := 10.5

put (x+x**2)/2
%put sum(x)
put mSum (x)