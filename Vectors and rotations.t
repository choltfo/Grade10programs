
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

proc drawVectorLine (a,b : pointer to Vector2, c : int)
    Draw.Line(round(a->getX()),round(a->getY()),round(b->getX()),round(b->getY()),c)
end drawVectorLine

proc drawVectorThickLine (a,b : pointer to Vector2, w, c : int)
    Draw.ThickLine(round(a->getX())+round(maxx/2),round(a->getY())+round(maxy/2),
    round(b->getX())+round(maxx/2),round(b->getY())+round(maxy/2),w,c)
end drawVectorThickLine

var LineTip, ArrowTip, ArrowLeft, ArrowRight : pointer to Vector2

new Vector2, LineTip
new Vector2, ArrowTip
new Vector2, ArrowLeft
new Vector2, ArrowRight

LineTip      -> Set(100,100)
ArrowTip     -> Set(120,80)
ArrowLeft    -> Set(120,90)
ArrowRight   -> Set(110,80)


var zRot : real := 0

loop
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) then
        %  put "Up Arrow Pressed  " ..
        zRot += 1
    end if
     if chars (KEY_DOWN_ARROW) then
        %  put "Up Arrow Pressed  " ..
        zRot -= 1
    end if
    
    var LineEndRt       : pointer to Vector2  := LineTip       -> RotateD(zRot,0,0)
    var ArrowTipRt      : pointer to Vector2  := ArrowTip      -> RotateD(zRot,0,0)
    var ArrowLeftRt     : pointer to Vector2  := ArrowLeft     -> RotateD(zRot,0,0)
    var ArrowRightRt    : pointer to Vector2  := ArrowRight    -> RotateD(zRot,0,0)
    
    
    Draw.FillBox(0,0,maxx,maxy,white)
    Draw.ThickLine(round(LineEndRt->getX())+round(maxx/2),round(LineEndRt->getY())+round(maxy/2),round(maxx/2),round(maxy/2),5,red)
    drawVectorThickLine(ArrowTipRt,LineEndRt,5,red)
    drawVectorThickLine(ArrowTipRt,ArrowLeftRt,5,red)
    drawVectorThickLine(ArrowTipRt,ArrowRightRt,5,red)
    
    
    
    delay(10)
end loop