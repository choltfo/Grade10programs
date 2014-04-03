

type character:record
    name:   string
    age:    int
    alive:  boolean
    gender: string
end record

var thisChar : character

thisChar.name   := "Michael Fenrirson"
thisChar.age    := 38
thisChar.alive  := false
thisChar.gender := "male"

put thisChar.name, " is a " , thisChar.age," year-old ",thisChar.gender, ". "..
if (thisChar.alive) then
    put "He is still alive."
else
    put "He is dead."
end if