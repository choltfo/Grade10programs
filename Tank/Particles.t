% The particles library

type Particle : record
    col : int
    TTL : int
    size: int
    
    x : real
    y : real
    
    xVel : real
    yVel : real
end record

class ParticleSystem
    import Particle
    export Init, update, draw
    
    var particles : flexible array 1..0 of Particle
    
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
        end for
    end Init
    
    procedure update
        for decreasing i : upper(particles)..1
            particles(i).TTL -= 1
            
            particles(i).x += particles(i).xVel
            particles(i).y += particles(i).yVel
            
            if (particles(i).TTL < 1) then
                new particles, upper(particles) - 1
            end if
        end for
    end update
    
    procedure draw
        for i : 1 .. upper(particles)
            Draw.FillOval(round(particles(i).x),round(particles(i).y),round(particles(i).size/2),round(particles(i).size/2),particles(i).col)
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