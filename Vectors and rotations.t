
var chars : array char of boolean



class Vector2
    
    export (x,y,RotateD,getX,getY,Set)
    
    var x,y : real := 0
    
    procedure Set (X,Y : real)
        x := X
        y := Y
    end Set
    
    function getX () :real
        result x
    end getX
    
    function getY () :real
        result y
    end getY
    
    function RotateD (theta,Xc,Xy : real) : pointer to Vector2
        
        var NewVec : pointer to Vector2
        new Vector2, NewVec
        
        NewVec -> Set( (x*cosd(theta))-(y*(sind(theta))) , (x*sind(theta))+(y*cosd(theta)) )
        result NewVec
    end RotateD
    
end Vector2

var VecPoint : pointer to Vector2
new Vector2, VecPoint

VecPoint -> Set(100,100)

var zRot : real := 0

loop
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) then
        %  put "Up Arrow Pressed  " ..
        zRot += 1
    end if
    
    var RdPoint : pointer to Vector2 := VecPoint -> RotateD(zRot,0,0)
    Draw.FillBox(0,0,maxx,maxy,white)
    Draw.ThickLine(round(RdPoint->getX())+round(maxx/2),round(RdPoint->getY())+round(maxy/2),round(maxx/2),round(maxy/2),5,red)
    
    delay(10)
end loop