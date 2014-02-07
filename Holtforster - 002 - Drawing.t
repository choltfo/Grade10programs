% So apparantly I need to draw something.....

View.Set("offscreenonly")

var horizon:int:=150

procedure DrawFilledTriangle (x1,y1,x2,y2,x3,y3,c,cf : int)
    Draw.ThickLine(x1,y1,x2,y2,0,c)
    Draw.ThickLine(x1,y1,x3,y3,0,c)
    Draw.ThickLine(x2,y2,x3,y3,0,c)    
    var xM := round((x1+x2+x3)/3)
    var yM := round((y1+y2+y3)/3)
    if (xM > maxx) then
        xM := maxx
    end if
    if (yM > maxy) then
        yM := maxy
    end if
    if (xM < 0) then
        xM := 0
    end if
    if (yM < 0) then
        yM := 0
    end if
    
    Draw.Fill(xM,yM,cf,c)
    %Draw.Line(xM-10,yM,xM+10,yM, blue)
    %Draw.Line(xM,yM-10,xM,yM+10, blue)
end DrawFilledTriangle

procedure DrawQuad (x1,y1,x2,y2,x3,y3,x4,y4,c,cf : int)
    Draw.ThickLine(x1,y1,x2,y2,0,c)
    Draw.ThickLine(x2,y2,x3,y3,0,c)
    Draw.ThickLine(x3,y3,x4,y4,0,c)
    Draw.ThickLine(x1,y1,x4,y4,0,c)
    
    var xM := round((x1+x2+x3+x4)/4)
    var yM := round((y1+y2+y3+y4)/4)
    
    if (xM > maxx) then
        xM := maxx
    end if
    if (yM > maxy) then
        yM := maxy
    end if
    if (xM < 0) then
        xM := 0
    end if
    if (yM < 0) then
        yM := 0
    end if
    
    Draw.Fill(xM,yM,cf,c)
    %Draw.Line(xM-10,yM,xM+10,yM, blue)
    %Draw.Line(xM,yM-10,xM,yM+10, blue)
end DrawQuad

procedure drawBG ()
    Draw.FillBox(0,maxy,maxx,horizon,black)
    Draw.FillBox(0,0,maxx,horizon,grey)
    DrawQuad(0,0,maxx,0,round((maxx/2)+100),horizon,round((maxx/2)-100),horizon,darkgrey,darkgrey)
    
    DrawFilledTriangle(200,horizon,400,horizon,300,horizon+200,24,24)
    DrawFilledTriangle(275,horizon+150,325,horizon+150, 300,horizon+200,0,0)
    
end drawBG

procedure drawLines (t,r :int)
    DrawQuad(round((maxx/2)-50),0, round((maxx/2)+50),0, round((maxx/2)),horizon, round((maxx/2)),horizon,yellow,yellow)
    Draw.FillBox(round((maxx/2)-50),horizon-round(t/r),round((maxx/2)+50),horizon-10-round(t/r)-round(t/2),darkgrey)
    
   % Draw.FillBox(round((maxx/2)-50),horizon-round(t/r),round((maxx/2)+50),horizon-10-round(t/r)-round(t/2),black)
    
end drawLines


var i : int := 1
var rep :int:= 1

loop
    drawBG()
    drawLines(i,rep)
    delay(10)
    View.Update()
    i := (i+1) mod horizon
end loop


