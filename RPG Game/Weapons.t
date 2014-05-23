% Weapon Consts

type Gun : record
    SFO5 : int      % Shots fired over 5 seconds.
    damage  : int   % Damage per hit.
    range  : real   % Range at which the bullet does no damage.
    magSize : int   % Max shots.
end record

var SDAP,Buzzsaw,Spitter,