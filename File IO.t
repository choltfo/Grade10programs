% File Read and Write

type HockeyPlayer : record
    name : string
    number : int
end record

var player : array 1..10 of HockeyPlayer

var fileNum : int
for i : 1..upper(player)
    player(i).name := "Holtforster"+chr(i)
    player(i).number := i
end for

open : fileNum, "HockeyFile.txt", write

for i : 1..upper(player)
    write : fileNum, player (i)
end for
close : fileNum

open : fileNum, "HockeyFile.txt", read

for i : 1..upper(player)
    read : fileNum,player (i)
    put player(i).name+ ", "+intstr(player(i).number)
end for
close : fileNum