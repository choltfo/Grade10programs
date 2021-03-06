% Weapon Consts

type Gun : record
    SFO5 : int      % Shots fired over 5 seconds.
    damage  : int   % Damage per hit.
    range  : real   % Range at which the bullet does no damage.
    magSize : int   % Max shots.
end record

var SDAP,Buzzsaw,Hammer : Gun

SDAP.SF05 := 100
SDAP.damage := 1
SDAP.range := 500
SDAP.magSize := 50

Buzzsaw.SF05 := 50
Buzzsaw.damage := 3
Buzzsaw.range := 500
Buzzsaw.magSize := 50

Spitter.SF05 := 67
Spitter.damage := 3
Spitter.range := 1500
Spitter.magSize := 35