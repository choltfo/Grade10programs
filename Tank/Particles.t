% Splatter by Holtforster particles library

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
export Init, update, draw,InitAngular, setOffset,InitPreset, InitPresetAngular

var particles : flexible array 1..0 of Particle
var ox, oy : int := 0

proc setOffset(x,y : int)
    ox := x
    oy := y
end setOffset

procedure Init (x,y,maxXSpeed,maxYSpeed : real, numOfP,Colour,size,TTLMin,TTLMax : int)
    for i : 1 .. numOfP
        if (upper(particles) < 1200) then
            new particles, upper (particles)+1
            particles(upper(particles)).col := Colour
            particles(upper(particles)).size := size
            particles(upper(particles)).x := x
            particles(upper(particles)).y := y
            particles(upper(particles)).xVel :=2*(Rand.Real-0.5) * maxXSpeed
            particles(upper(particles)).yVel := 2*(Rand.Real-0.5) * maxYSpeed
            particles(upper(particles)).TTL := Rand.Int (TTLMin,TTLMax)
            particles(upper(particles)).maxTTL:=particles(upper(particles)).TTL
        else
            particles(i).col := Colour
            particles(i).size := size
            particles(i).x := x
            particles(i).y := y
            particles(i).xVel :=2*(Rand.Real-0.5) * maxXSpeed
            particles(i).yVel := 2*(Rand.Real-0.5) * maxYSpeed
            particles(i).TTL := Rand.Int (TTLMin,TTLMax)
            particles(i).maxTTL:=particles(i).TTL
        end if
    end for
end Init

procedure InitPreset (x,y : real, a:particleBurst)
    Init (x,y,a.maxXSpeed,a.maxYSpeed, a.numOfP,a.Colour,a.size,a.TTLMin,a.TTLMax)
end InitPreset

procedure InitAngular (x,y,maxSpeedX,maxSpeedY:real, numOfP,Colour,size,TTLMin,TTLMax : int)
    for i : 1 .. numOfP       % A guesstimate 
        if (upper(particles) < 1200) then
            new particles, upper (particles)+1
            particles(upper(particles)).col := Colour
            particles(upper(particles)).size := size
            particles(upper(particles)).x := x
            particles(upper(particles)).y := y
            particles(upper(particles)).xVel := maxSpeedX + 2*(Rand.Real-0.5)*2
            particles(upper(particles)).yVel := maxSpeedY + 2*(Rand.Real-0.5)*2
            particles(upper(particles)).TTL := Rand.Int (TTLMin,TTLMax)
            particles(upper(particles)).maxTTL:=particles(upper(particles)).TTL
        else
            particles(i).col := Colour
            particles(i).size := size
            particles(i).x := x
            particles(i).y := y
            particles(i).xVel := maxSpeedX + 2*(Rand.Real-0.5)*2
            particles(i).yVel := maxSpeedY + 2*(Rand.Real-0.5)*2
            particles(i).TTL := Rand.Int (TTLMin,TTLMax)
            particles(i).maxTTL:=particles(i).TTL
        end if
    end for
end InitAngular

procedure InitPresetAngular (x,y,mxs,mys: real, a:particleBurst)
    InitAngular (x,y,mxs,mys, a.numOfP,a.Colour,a.size,a.TTLMin,a.TTLMax)
end InitPresetAngular

procedure update
    var StartTime := Time.Elapsed
    
    if (upper(particles) > 0) then
        var i : int := 1
        loop
            particles(i).TTL -= 1
            particles(i).x += particles(i).xVel
            particles(i).y += particles(i).yVel
            
            if (particles(i).TTL <= 0) then
                particles(i) := particles(upper(particles))
                new particles, upper(particles)-1
            else
                i += 1
            end if
            exit when i > upper(particles)
        end loop
    end if
    
    put "PS update time: ", Time.Elapsed - StartTime
end update

procedure draw
    var StartTime := Time.Elapsed
    for i : 1 .. upper(particles)
        if (particles(i).x+ox < maxx and particles(i).x+ox > 0 and particles(i).y+oy < maxy and particles(i).y+oy > 0) then
            Draw.FillOval(round(particles(i).x)+ox,round(particles(i).y)+oy,
                ceil((particles(i).size/2)*(particles(i).TTL/particles(i).maxTTL)),
                ceil((particles(i).size/2)*(particles(i).TTL/particles(i).maxTTL)),
                particles(i).col)
        end if
    end for
    put "PS draw time: ", Time.Elapsed - StartTime
    put upper(particles)/((Time.Elapsed - StartTime)+1)
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