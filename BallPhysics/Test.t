
var stream : int
var mapFile : flexible array 1..0 of string

%open : stream, map, get
open : stream, "map1.map", get

cls
put "Loading map..."
put stream
loop
    exit when eof(stream)
    new mapFile, upper(mapFile) + 1
    get : stream, mapFile(upper(mapFile)) : *
end loop

for i : 1.. upper(mapFile)
    put mapFile(i)
end for
