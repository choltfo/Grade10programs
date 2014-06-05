% The particles library

type particleBurst : record
    maxXSpeed : real
    maxYSpeed : real
    numOfP : int
    Colour : int
    size : int
    TTLMin : int
    TTLMax : int
end record

type Particle : record
col : int
TTL : int
maxTTL:int
size: int

x : real
y : real

xVel : real
yVel : real
end record

class ParticleSystem
import Particle, particleBurst
export Init, update, draw,InitAngular, setOffset,InitPreset

var particles : flexible array 1..0 of Particle
var ox, oy : int := 0

proc setOffset(x,y : int)
    ox := x
    oy := y
end setOffset

procedure Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
    for i : 1 .. numOfP
        new particles, upper (particles)+1
        particles(upper(particles)).col := Colour
        particles(upper(particles)).size := size
        particles(upper(particles)).x := x
        particles(upper(particles)).y := y
        particles(upper(particles)).xVel :=2*(Rand.Real-0.5) * maxXSpeed
        particles(upper(particles)).yVel := 2*(Rand.Real-0.5) * maxYSpeed
        particles(upper(particles)).TTL := Rand.Int (TTLMin,TTLMax)
        particles(upper(particles)).maxTTL:=particles(upper(particles)).TTL
    end for
end Init

procedure InitPreset (x,y : real, a:particleBurst)
    Init (x,y,a.maxXSpeed,a.maxYSpeed, a.numOfP,a.Colour,a.size,a.TTLMin,a.TTLMax)
end InitPreset

procedure InitAngular (x,y,maxSpeedX,maxSpeedY:real, numOfP,Colour,size,TTLMin,TTLMax : int)
    for i : 1 .. numOfP
        new particles, upper (particles)+1
        particles(upper(particles)).col := Colour
        particles(upper(particles)).size := size
        particles(upper(particles)).x := x
        particles(upper(particles)).y := y
        particles(upper(particles)).xVel := maxSpeedX + 2*(Rand.Real-0.5)*2
        particles(upper(particles)).yVel := maxSpeedY + 2*(Rand.Real-0.5)*2
        particles(upper(particles)).TTL := Rand.Int (TTLMin,TTLMax)
        particles(upper(particles)).maxTTL:=particles(upper(particles)).TTL
    end for
end InitAngular

procedure update
    var removeThese : flexible array 1..0 of int
    for i : 1..upper(particles)
        particles(i).TTL -= 1
        particles(i).x += particles(i).xVel
        particles(i).y += particles(i).yVel
        
        if (particles(i).TTL <= 0) then
            new removeThese, upper(removeThese) + 1
            removeThese(upper(removeThese)) := i
        end if
    end for
    
    % These will be ordered ascending, with (1) := 1, and (6) := 100
    
    for decreasing i : upper(removeThese) .. 1
        var temp : Particle := particles(upper(particles) - i+1)
        particles(upper(particles)-1+1) := particles(removeThese(i))
        particles(removeThese(i)) := temp
    end for
    
    new particles, upper(particles) - upper(removeThese)
    %put upper(particles)
    free removeThese
end update

procedure draw
    for i : 1 .. upper(particles)
        if (particles(i).TTL > 0) then
            Draw.FillOval(round(particles(i).x)+ox,round(particles(i).y)+oy,ceil(((particles(i).size/2)*particles(i).TTL)/particles(i).maxTTL),ceil(((particles(i).size/2)*particles(i).TTL)/particles(i).maxTTL),particles(i).col)
        end if
    end for
end draw

end ParticleSystem

/*
var PS : pointer to ParticleSystem
new ParticleSystem, PS

PS -> Init (300,200,20,20,100,yellow,5,5,40)

View.Set("offscreenonly")

loop
PS -> update()
PS -> draw()

delay (10)
View.Update()
cls()
end loop*/