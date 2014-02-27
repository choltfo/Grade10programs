% Usage of the "index" function
% Also the ord and chr functions

View.Set("graphics:1000;400")

var FOC := Font.New ("Arial:10")

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

var AvailableTries, startTries := 5
var points := 0

var maxPossiblePoints := 0

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
        if (toLowerCase(answer) = toLowerCase(attempt)) then
            Hits := 3
        end if
    end if
    
    result round(Hits/3)*maximum
    
end correct

function askQuestion (prompt, correctAnswer : string, difficulty : int, hint : string) : int
    loop
        exit when AvailableTries = 0
        
        var answer : string := ""
        
        put prompt
        get answer:*
        
        if toLowerCase(answer) = "hint" then
            put hint
            get answer:*
        end if
        
        var thesePoints := correct(answer, correctAnswer,difficulty)
        
        if thesePoints = 0 then
            AvailableTries -= 1
            cls
            put "Uh, no, see, you're wrong. You have ", AvailableTries, " attempts remaining."
            put "Do you want to try again? (y/n) "..
            var ans: string := ""
            get ans:*
            if (toLowerCase(ans) = "n") then
                result 0
            else
                if (toLowerCase(ans) not= "n") then
                 put "presumably you meant Y"
                end if
            end if
            put "Hint: ", hint
        else
            if thesePoints = difficulty then
                cls
                
                put "Correct!"
                result thesePoints
            else
                cls
                
                put "Close enough!"
                result thesePoints
            end if
        end if
    end loop
    
    if (AvailableTries = 0) then
        put "Sorry, you're out of tries. Goodbye."
        result -1
    else
        result 0
    end if
end askQuestion

function handleQuestion (prompt, correctAnswer : string, difficulty : int, hint : string) : boolean
    maxPossiblePoints += difficulty
    var ansScore : int :=0
    ansScore := askQuestion (prompt,correctAnswer,difficulty,hint)
    if (ansScore >= 0) then
        points += ansScore
        
        put "Your current score is ",points, ", and you have ", AvailableTries," attempts remaining."
        result false
    end if
    put "Game over, you failed the quiz. Your score is "..
    put points..
    put (", out of a maximum of ")..
    put maxPossiblePoints
    result true
end handleQuestion


put "Welcome to the James Bond quiz!"
put "For an extra hint, you can put 'hint' as an answer. This will not reduce your remaining tries."

if handleQuestion ("What brand of car does James Bond drive in the movie Skyfall?","Aston Mar tin",5,"It's a ____ DB5") then

elsif handleQuestion ("The name of the key 'Bond girl' in Live and Let Die.","Sol it aire",10,"Also a card game, spider _________") then

elsif handleQuestion ("The James Bond movie in which Bond engages in a fistfight with the villain while atop the Golden Gate bridge, after falling out of a blimp.","View to kill",7, "Also notable for having a large conspiracy to trigger a massive earthquake beneath Silicon Valley, as well as a visit to a horse auction.") then

elsif handleQuestion ("'Remeber Bond, in the time I have known you, I've only tried to teach you two things. One, never let them see you bleed. Two, always have _________'","a escape plan",10, "Three words, an _________ plan") then % An escape plan.

elsif handleQuestion ("The brand of weapon that Bond had at the begginning of Dr. No, before M takes it away and replaces it with his new signature weapon.","Ber et ta",10,"A nine millimeter pistol, not made by Walther.") then

elsif handleQuestion ("The model of James Bond's Walther pistol in almost every movie ","PPK",5,"Sorry, there is truly no hint for this.") then

elsif handleQuestion ("This villain shares a name with a Steven Spielberg film","jaws",3,"Think sharks") then

elsif handleQuestion ("A genuine Felix _________","lighter",3,"Incendiary tool, used to ignite a drug lord at the end of 'The Living Daylights'. Also to light cigarettes.") then


/*
put "Welcome to the Star Wars quiz!"
put "For an extra hint, you can put 'hint' as an answer. This will not reduce your remaining tries."

   if handleQuestion ("'No, I am your _________'","fa th er",2,"dad") then

elsif handleQuestion ("The Milllenium _________","falcon",2,"It made the Kessel Run in twelve parsecs!") then

elsif handleQuestion ("These aren't the _________ your looking for.","droids",2,"a smart robot.") then

elsif handleQuestion ("","fa th er",2,"dad") then
*/
else
put ("Congratulations! You completed the quiz! Your score is ")..
put points..
put (", out of a maximum of ")..
put maxPossiblePoints
put ("And you used ")..
put startTries-AvailableTries..
put (" of your ")..
put startTries..
put (" tries.")

end if
