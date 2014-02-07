% Draw a line by y=mX+b

proc drawLine (m,b :real,lX,rX,c:int)
    Draw.Line(lX,round((m*lX)+b),rX,round((m*rX)+b),c)
end drawLine

drawLine(-0.05,round(maxy/2),0,400,red)