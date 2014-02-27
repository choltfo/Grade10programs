View.Set("offscreenonly")

var TIME :int:= 0


proc drawLine (m,b :real, lX,rX,ox,oy,c:int)
    Draw.ThickLine(lX+ox,round((m*(lX+ox))+b-oy),rX+ox,round((m*(rX+ox))+b-oy),3,c)
end drawLine

proc drawSecondHand (t,x,y,length:int)
    var angle : real := (t mod 60)*6 % in degrees. What could possibly go wrong?
    var slope : real := tand(angle)
    
    drawLine (slope,0,-100,100,round(maxx/2),round(maxy/2),red)
    Draw.Oval(round(maxx/2),round(maxy/2),10,10,red)
    
end drawSecondHand

loop
drawSecondHand(TIME,0,0,100)
delay(1000)
TIME := TIME +1
View.Update()
end loop