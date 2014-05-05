% Map editor for the Tank Core

include "Core.t"


procedure save (fileName:string)
    % generate map from walls and vector points
    var stream : int
    open : stream, fileName, put
    
    put : stream, maxx
    put : stream, maxy
    for i : 1.. upper (walls)
        put : stream, "Wall:"
        put : stream, round(walls(i)->getP1().x)
        put : stream, round(walls(i)->getP1().y)
        put : stream, round(walls(i)->getP2().x)
        put : stream, round(walls(i)->getP2().y)
    end for
    
    for i : 1.. upper (enemies)
        put : stream, "Enemy:"
        put : stream, round(enemies(i)->getLoc().x)
        put : stream, round(enemies(i)->getLoc().y)
        put : stream, round(enemies(i)->getCol())
    end for
    
    for i : 1.. upper (cas)
        put : stream, "Colour:"
        put : stream, round(cas(i).TRcorner.x)
        put : stream, round(cas(i).TRcorner.y)
        put : stream, round(cas(i).BLcorner.x)
        put : stream, round(cas(i).BLcorner.y)
        put : stream, round(cas(i).col)
    end for
        
    close( stream)
    cls
    put "Loading map..."
    
end save

function PTInRect (x,y,x1,y1,x2,y2:int):boolean
    if x1 > x2 then
        %put "x1 > x2, retrying"
        result PTInRect(x,y,x2,y2,x1,y1)
    end if
    if y1 > y2 then
        %put "y1 > y2, retrying"
        result PTInRect(x,y,x1,y2,x2,y1)
    end if
    result x > x1 and x < x2 and y > y1 and y < y2
end PTInRect

function ButtonBox (x,y,button,lb,x1,y1,x2,y2,c1,c2:int):boolean
    Draw.FillBox(x1,y1,x2,y2,c2)
    Draw.Box(x1,y1,x2,y2,c1)
    if button = 1 and lb = 0 then
        if PTInRect (x,y,x1,y1,x2,y2) then
            Draw.FillBox(x1,y1,x2,y2,c2)
            Draw.Box(x1,y1,x2,y2,c1)
            result true
        end if
    end if
    result false
end ButtonBox

var camX, camY : int := 0

var editMode : int := 0

var selectedColour : int := black

var firstPoint : Vector2
%var mX, mY, mB, mLB
Input.KeyDown(chars)

proc draw()
    for i : 1..upper(cas)
        drawVectorFillBox(cas(i).TRcorner,cas(i).BLcorner,cas(i).col)
    end for
        
    for i : 1..upper(enemies)
        enemies(i)->render()
    end for
        
    for i : 1..upper(walls)
        walls(i)->draw()
    end for
end draw

proc editorPauseScreen()
    var mX,mY,mB,lMB : int := 0
    loop
        formerChars := chars
        Input.KeyDown (chars)
        Mouse.Where(mX,mY,mB)
        
        Pic.Draw(bgImg,0,0,0)
        
        Font.Draw("Paused",round((maxx/2)-(Font.Width("Paused",Font1)/2)),maxy-100,Font1,black)
        Font.Draw("Controls:",200,maxy-200,Font2,black)
        Font.Draw("1 : select wall tool",220-Font.Width("1",Font2),maxy-220,Font2,black)
        Font.Draw("2 : select colour tool",220-Font.Width("2",Font2),maxy-240,Font2,black)
        Font.Draw("3 : select enemy tool",220-Font.Width("3",Font2),maxy-260,Font2,black)
        Font.Draw("S : save map as map2.txt",220-Font.Width("S",Font2),maxy-280,Font2,black)
        Font.Draw("R : increase colour value by 1",220-Font.Width("R",Font2),maxy-300,Font2,black)
        Font.Draw("F : decrease colour value by 1",220-Font.Width("F",Font2),maxy-320,Font2,black)
        Font.Draw("T : increase colour value by 10",220-Font.Width("T",Font2),maxy-340,Font2,black)
        Font.Draw("G : decrease colour value by 10",220-Font.Width("G",Font2),maxy-360,Font2,black)
        
        
        exit when chars(KEY_ESC) and not formerChars(KEY_ESC)
        View.Update()
        cls()
        delay (10)
        lMB := mB
    end loop
end editorPauseScreen


var paused : boolean := false

proc EditLoadedMap()
    loop
        % Show a 500x500 frame of the map, with arrow-key scrolling
        formerChars := chars
        Input.KeyDown(chars)
        mLB := mB
        Mouse.Where(mX,mY,mB)
        
        if chars('1') and not formerChars('1') then
            editMode := 1   % Wall
        end if
        if chars('2') and not formerChars('2') then
            editMode := 2   % Enemy
        end if
        if chars('3') and not formerChars('3') then
            editMode := 3   % Colour area
        end if
        if chars('s') and not formerChars('s') then
            save("map2.txt")
        end if
        if chars('r') and not formerChars('r') then
            selectedColour := (selectedColour+1) mod 255
        end if
        if chars('t') and not formerChars('t') then
            selectedColour := (selectedColour+10) mod 255
        end if
        if chars('f') and not formerChars('f') then
            selectedColour := (selectedColour-1) mod 255
        end if
        if chars('g') and not formerChars('g') then
            selectedColour := (selectedColour-10) mod 255
        end if
        
        if chars(KEY_ESC) and not formerChars(KEY_ESC) then
            paused := true
        end if
        
        if (mB=1 and mLB=0) then
            if (mX > 0 and mX < maxx and mY < maxy and mY > 0) then
                firstPoint.x := mX
                firstPoint.y := mY
                
                if (editMode not= 2) then
                    
                    loop
                        mLB := mB
                        Mouse.Where(mX,mY,mB)
                        formerChars := chars
                        Input.KeyDown(chars)
                        
                        if chars(KEY_ESC) and not formerChars(KEY_ESC) then
                            editMode := 0
                            exit
                        end if
                        if (mB=1 and mLB=0) then
                            if (mX > 0 and mX < maxx and mY < maxy and mY > 0) then
                                
                                var secondPoint : Vector2
                                secondPoint.x := mX
                                secondPoint.y := mY
                                
                                if (editMode = 1) then
                                    new walls, upper(walls)+1
                                    new Wall, walls(upper(walls))
                                    walls(upper(walls))->Init(firstPoint,secondPoint)
                                end if
                                if (editMode = 3) then
                                    new cas, upper(cas)+1
                                    cas(upper(cas)).BLcorner := firstPoint
                                    cas(upper(cas)).TRcorner := secondPoint
                                    cas(upper(cas)).col := selectedColour
                                end if
                                exit
                            end if
                        end if
                    end loop
                else
                    new enemies, upper (enemies)+1
                    new Tank, enemies(upper(enemies))
                    enemies(upper(enemies))->Init(vel,firstPoint,fric,45,selectedColour)
                end if
            end if
        end if
        
        Time.DelaySinceLast(frameMillis)
        
        Draw.FillBox(0,0,100,100,selectedColour)
        put editMode
        
        if (paused) then
            bgImg := Pic.New(0,0,maxx,maxy)
            editorPauseScreen()
            paused := false
        end if
        
        offsetX := 0
        offsetY := 0
        
        draw
        View.Update()
        cls
        
    end loop
end EditLoadedMap