% Charles Holtforster's DiceChecker - Test 1
var font := Font.New ("Arial:12")
var BiggerFont := Font.New ("Arial:13")
var rolls : array 1..10 of int := init (0,0,0,0,0,0,0,0,0,0)

proc anotherRand(i : int)
    cls
    var num := Rand.Int(1,10)
    Font.Draw("You rolled a: "+intstr(num),  50, 200, BiggerFont, blue)
    Font.Draw("Number of rolls: "+intstr(i), 50, 180, BiggerFont, green)
    rolls(num) += 1
    for o : 1..upper(rolls)
        Font.Draw(intstr(o)+"'s", 50+(35*o), 130, font, blue)
        Font.Draw(intstr(rolls(o)), 55+(35*o), 100, font, black)
    end for
    delay (1000)
end anotherRand

for i : 1..100
    anotherRand (i)
end for

put "done"