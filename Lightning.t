View.Set("graphics:800;600")
View.Set("offscreenonly")

Draw.FillBox(0,0,maxx,maxy,black)

var curDotsX : flexible array 0..-1 of int
var curDotsY : flexible array 0..-1 of int

var dotsX : flexible array 0..-1 of int
var dotsY : flexible array 0..-1 of int

var mX, mY, mB : int := 0

proc Add (x,y : int)
    new dotsX, upper (dotsX) + 1 
    dotsX (upper (dotsX)) := x
    new dotsY, upper (dotsY) + 1 
    dotsY (upper (dotsY)) := y
end Add

proc AddCur (x,y : int)
    new curDotsX, upper (curDotsX) + 1 
    curDotsX (upper (curDotsX)) := x
    new curDotsY, upper (curDotsY) + 1 
    curDotsY (upper (curDotsY)) := y
end AddCur

proc Switch ()
    for decreasing i : upper(curDotsX) .. 1
        new curDotsX, upper (curDotsX) - 1
        new curDotsY, upper (curDotsY) - 1
    end for
        for decreasing i : upper(dotsX) .. 1
        AddCur(dotsX(i),dotsY(i))
        new dotsX, upper (dotsX) - 1
        new dotsY, upper (dotsY) - 1
    end for
end Switch

proc DRAW (x,y,i,c:int)
    %var aRand : int := Rand.Int(1,20)
    for a : 1 .. i
        var xA : int := Rand.Int(-10,10) + sign(mX-x)*5
        var yA : int := Rand.Int(-10,10) + sign(mY-y)*5
        Draw.Line(x,y,x+xA,y+yA,yellow)%(c mod 6)+9)
        Add(x+xA,y+yA)
        View.Update()
    end for
end DRAW

var metaLayer : int := 1
loop
    if (mB = 1) then
        DRAW(floor(maxx/2),floor(maxy/2),1,red)
        var layer := 1
        loop
            Mouse.Where(mX, mY, mB)
            for i : 1.. upper(curDotsX)
                DRAW(curDotsX(i),curDotsY(i),1,layer+metaLayer)
            end for
                
            layer += 1
            Switch()
            %put upper(curDotsY) , ", ", layer
            View.Update()
            exit when layer > 50 or mB = 0
        end loop
    end if
    for decreasing i : upper(curDotsX) .. 1
        new curDotsX, upper (curDotsX) - 1
        new curDotsY, upper (curDotsY) - 1
    end for
        for decreasing i : upper(dotsX) .. 1
        new dotsX, upper (dotsX) - 1
        new dotsY, upper (dotsY) - 1
    end for
        
    cls
    Draw.FillBox(0,0,maxx,maxy,black)
    metaLayer+=1
    View.Update
    Mouse.Where(mX, mY, mB)
end loop



