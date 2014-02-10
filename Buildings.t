


proc drawBuilding(winWidth,winHeight,Width,Height,x,y,c,wc: int)
    Draw.FillBox(x,y,x+Width,y+Height,c)
    
    var winX := x+10
    var winY := y+10
    
    loop
        exit when winX > Width+x-10 
        loop
            exit when winY > Height+y-10 
            Draw.FillBox(winX,winY,winWidth,winHeight,wc)
            winY := winY + winHeight + 10
        end loop
        winX := winX + winWidth + 10
    end loop
    
end drawBuilding

drawBuilding (10,10,175,100,100,100,black,blue)
