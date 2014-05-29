% RPG club calculator for random stuff

include "Types.t"



%View.Set("offscreenonly")

%var a := createNewPlayer


% Accuracy is from 100 (dead on) to 0 (anywhere in front)
% Mit is the percentage provided by armour or skin,
function shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound : real, enemyFinesse, Mitigation : int) : int
    
    var roundsFired := round(RPM/60) * 5
    var strength := Bstrength + Rand.Int(1,20)
    var finesse := Bfinesse + Rand.Int(1,20)
    var accuracy := min(Baccuracy + Rand.Int(1,20),100)
    
    %put "Fired ", roundsFired, " rounds."
    %put "STR: ",strength
    %put "FIN: ",finesse
    %put "ACC: ",accuracy
    %put "DEF: ",defense
    
    % Yes, it's a real number. Not an Int. Makes sense later.
    %* min((Dist/Range),1)
    
    if (Dist > Range) then
        result 0
    end if
    
    var roundsHit : int := ceil(roundsFired * (accuracy/100) * ((strength+finesse+Rand.Int(1,20)) / 100) * ((Range-Dist)/Range))
    
    %put "HITS: ",roundsHit
    
    var damageDealt : real := roundsHit*damagePerRound * ((40-enemyFinesse) / 40) * ((100-Mitigation)/100)
    
    result max(floor(damageDealt),1)
    
end shootAuto

/*
% Accuracy is from 100 (dead on) to 0 (anywhere in front)
% Mit is the percentage provided by armour or skin,
function shootAutoAsEntity (gun : Gun, shooter : player ) : int
    
    var roundsFired := gun.SFO5
    var defense := Bdefense + Rand.Int(1,20)
    var strength := Bstrength + Rand.Int(1,20)
    var finesse := Bfinesse + Rand.Int(1,20)
    var accuracy := min(Baccuracy + Rand.Int(1,20),100)
    
    %put "Fired ", roundsFired, " rounds."
    %put "STR: ",strength
    %put "FIN: ",finesse
    %put "ACC: ",accuracy
    %put "DEF: ",defense
    
    % Yes, it's a real number. Not an Int. Makes sense later.
    %* min((Dist/Range),1)
    var roundsHit : real := roundsFired * (accuracy/100) * ((strength+finesse+Rand.Int(1,20)) / 100)
    
    %put "HITS: ",roundsHit
    
    var damageDealt : real := roundsHit*damagePerRound * ((60-defense-enemyFinesse) / 60) * ((100-Mitigation)/100)
    
    result max(floor(damageDealt),1)
    
end shootAutoAsEntity
*/
proc manInputDMG
    var Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound : real
    var Bdefense,enemyFinesse, Mitigation : int
    
    Baccuracy := 10
    Baccuracy := 10
    Bdefense := 10
    Bstrength := 10
    Bfinesse  := 10
    enemyFinesse:=10
    Mitigation:= 0
    Dist := 50
    
    put "Enter distance:"
    %get Dist
    put "Enter weapon range:"
    get Range
    put "Enter weapon RPM:"
    get RPM
    put "Enter weapon accuracy:"
    get Baccuracy
    put "Enter strength:"
    %get Bstrength
    put "Enter finesse:"
    %get Bfinesse
    put "Enter damage per hit:"
    get damagePerRound
    put "Enter defense of enemy:"
    %get Bdefense
    put "Enter finesse of enemy:"
    %get enemyFinesse
    put "Enter mitigation level of enemy armour:"
    %get Mitigation
        
        cls
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))
        put "DMG: "+intstr(shootAuto (Dist, Range, RPM, Baccuracy, Bstrength, Bfinesse, damagePerRound, enemyFinesse, Mitigation))

        
end manInputDMG



loop
    manInputDMG
end loop

