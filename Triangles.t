Draw.FillBox(0,0,maxx,maxy,255)

procedure DrawTriangle (x1,y1,x2,y2,x3,y3,c,cf : int)
    Draw.Line(x1,y1,x2,y1,c)
    Draw.Line(x1,y1,x3,y3,c)
    Draw.Line(x2,y2,x3,y3,c)
    
    var xM := round((x1+x2+x3)/3)
    var yM := round((y1+y2+y3)/3)
    
    Draw.Fill(xM,yM,cf,c)
    Draw.Line(xM-10,yM,xM+10,yM, red)
    Draw.Line(xM,yM-10,xM,yM+10, red)
    
end DrawTriangle

DrawTriangle(0,0,100,0,maxx,maxy,red,red)