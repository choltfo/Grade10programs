Okay, so, brief intro to map files:

-----------
2000	<- The width of the map
5000	<- The height of the map

Colour:	<- Starts a coloured area declaration
0	<- x1
0	<- y1
2000	<- x2
5000	<- y2
41	<- Colour number, in this case orange.

Wall:	<- Starts a wall declaration
0	<- x1
200	<- y1
100	<- x2
500	<- y2	

Enemy:	<- Enemy declaration
500	<- X
400	<- Y
4	<- Colour number

Weapon:
            1 UID
            Missile Launcher name
            50 damage
            100 speed
            2 magazine size
            4000 shotDelay in milliseconds
            4000 reloadDelay in milliseconds
            true automatic
            Trail: particleBurst
            2 maxXSpeed
            2 maxYSpeed
            5 numOfP
            41 colour
            5 size
            10  TTILMin
            15  TTLMax
            Hit: particleBurst
            2 maxXSpeed
            2 maxYSpeed
            5 numOfP
            41 colour
            5 size
            10  TTILMin
            15  TTLMax
	    Trail: particleBurst
            2 maxXSpeed
            2 maxYSpeed
            5 numOfP
            41 colour
            5 size
            10  TTILMin
            15  TTLMax
            X
            Y
            10000 Respawn Delay
	    10 Ammo