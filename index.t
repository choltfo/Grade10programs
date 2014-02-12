% Usage of the "index" function

function endsWith (x,a : string) : boolean
    result index (x,a) = length(x) - length(a) + 1
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

var AvailableTries := 5
var points := 0

function getThreeStrings (s : string) : array 1..3 of string
    var words : array 1..3 of string
    var firstSpace,secondSpace := 0
    
    for i : 1 .. length (s)
        if s (i) = " " and firstSpace not= 0 then
            secondSpace := i
        end if
        if s (i) = " " then
            firstSpace := i
        end if
    end for
        
    words (1) := s (1 .. firstSpace-1)
    words (2) := s (firstSpace+1 .. secondSpace+1)
    words (3) := s (secondSpace+1 .. length(s))
    
    result words
end getThreeStrings

function correct(attempt, answer : string, maximum : int) : int
    var Hits := 0
    if (index(answer," ") not= 0) then
        var syllables := getThreeStrings(answer)
        for i : 1 .. 3
            if (index(attempt, syllables (i)) not= 0) then
                Hits += 1
            end if
        end for
    else
        if (answer = attempt) then
            Hits := 1
        end if
    end if
    
    result Hits
    
end correct

function askQuestion (prompt, correctAnswer : string, difficulty : int) : int
    loop
        exit when AvailableTries = 0
        
        var answer : string := ""
        
        put prompt
        get answer
        
        var thesePoints := correct(answer, correctAnswer,difficulty)
        
        if thesePoints not= 0 then
            put "Correct!"
            result thesePoints
        else
            AvailableTries -= 1
            put "Uh, no, see, you're wrong. You have ", AvailableTries, " attempts remaining."
        end if
    end loop
    result 0
end askQuestion

points += askQuestion ("This is the square root of 100.","10", 1)
if (AvailableTries = 0) then
    put "Sorry, you're out of tries. Goodbye."
else
put "Your current score is ",points, ", and you have ", AvailableTries," attempts remaining. Moving on."

points += askQuestion ("Pi to the first 9.","3.14159",10)
if (AvailableTries = 0) then
    put "Sorry, you're out of tries. Goodbye."
else
put "Your current score is ",points, ", and you have ", AvailableTries," attempts remaining. Moving on."

points += askQuestion ("Having no distinct shape.","a mo rph",10) % Amorphus
if (AvailableTries = 0) then
    put "Sorry, you're out of tries. Goodbye."
else
put "Your current score is ",points, ", and you have ", AvailableTries," attempts remaining. Moving on."

points += askQuestion ("This is the square root of 100.","10",1)
if (AvailableTries = 0) then
    put "Sorry, you're out of tries. Goodbye."
else
put "Your current score is ",points, ", and you have ", AvailableTries," attempts remaining. Moving on."

put ("Congratulations! You have won!")

end if
end if
end if
end if


