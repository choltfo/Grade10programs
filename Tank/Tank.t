% The tank game
% Charles Holtforster, 2014
% Programming Summative, 2014 Sem. 2 for Mr. Reid's class.

% The map editor extension.
% This includes "Core.t", which contains all of the cool code.
include "Editor.t"

% The cutscene display controller.
include "cutscenes.t"

var levels : flexible array 1..0 of string

% Loads into "levels" all of the map file locations, and the cutscene data.
proc loadCampaign
    var stream : int
    var campaignData : flexible array 1..0 of string
    
    open : stream, "Campaign/Campaign.map", get
    
    put "Loading campaign..."
    
    new levels, 0
    
    loop
        exit when eof(stream)
        new campaignData, upper(campaignData) + 1
        get : stream, campaignData(upper(campaignData)) : *
    end loop
    
    for i : 1..upper(campaignData)
        if (campaignData(i)="Map:") then
            new levels, upper(levels)+1
            levels(upper(levels)) := campaignData(i+1)
            put levels(upper(levels))
        end if
        if (campaignData(i)="CS:") then
            cutscene.addLine(campaignData(i+1),strint(campaignData(i+2)),campaignData(i+3)="true",campaignData(i+4)="true")
        end if
    end for
    
    View.Update()
    
    close : stream
    
end loadCampaign

% Plays all maps loaded into "levels" by sequentially loading them into 'core'
proc playCampaign
    loadCampaign
    for i : 1..upper(levels)
        cutscene.displayLines
        loop
            clearLevel
            loadMap("Campaign/"+levels(i))
            if playLoadedLevel() then
                put "VICTORY BIATCH!"
                View.Update()
                exit
            else
                put "YOU IDIOT!"
                View.Update()
            end if
        end loop
    end for
    
    put "VICTORY!"
end playCampaign

% The only actual code outside of modules, procs, classes, and functions
var hasWaited := false
var logo : int := Pic.FileNew("logo.bmp")
loop    % Title screen loop
    mLB := mB
    Mouse.Where(mX, mY, mB)
    %Font.Draw("The Tank Game",round((maxx/2)-(Font.Width("The Tank Game",Font1)/2)),maxy-100,Font1,black)
    Pic.Draw(logo,round(maxx/2)-round(Pic.Width(logo)/2),maxy-Pic.Height(logo),0)
    
    Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),maxy-200,Font2,black)
    Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),maxy-220,Font2,black)
    Font.Draw("R tdo reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),maxy-240,Font2,black)
    Font.Draw("Space to fire laser",round((maxx/2)-(Font.Width("Space to fire laser",Font2)/2)),maxy-260,Font2,black)
    
    
    if (not hasWaited) then
        View.Update()
        delay(2000)
        hasWaited := true
    end if
    
    if (ButtonBox (mX,mY,mB,mLB,round((maxx/2)-110),maxy-400,round((maxx/2)+110),maxy-370,black,((round(Time.Elapsed() / 200)) mod 2)*green)) then
        
        playCampaign
    end if
    Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",Font2)/2)),maxy-395,Font2,black)
    
    if (ButtonBox (mX,mY,mB,mLB,round((maxx/2)-110),maxy-440,round((maxx/2)+110),maxy-410,black,green)) then
        
        EditLoadedMap
    end if
    Font.Draw("Map editor",round((maxx/2)-(Font.Width("Map editor",Font2)/2)),maxy-435,Font2,black)
    
    var US := 0
    if (useSound) then
        US := 1
    end if
    if (ButtonBox (mX,mY,mB,mLB,round((maxx/2)-110),maxy-480,round((maxx/2)+110),maxy-450,black,red+((green-red)*US))) then
        useSound := not useSound
        if useSound then
            cls
            Font.Draw("WARNING: Sound will dramatically reduce framerates, unless your computer",100,maxy-240,Font2,black)
            Font.Draw("has an SSD RAID whose output exceeds the input speed of your RAM.",100,maxy-270,Font2,black)
            View.Update()
            delay(3000)
        end if
    end if
    if (useSound) then
        Font.Draw("Sound on",round((maxx/2)-(Font.Width("Sound on",Font2)/2)),maxy-475,Font2,black)
    else
        Font.Draw("Sound off",round((maxx/2)-(Font.Width("Sound off",Font2)/2)),maxy-475,Font2,black)
    end if
    
    var UM := 0
    if (useMusic) then
        UM := 1
    end if
    if (ButtonBox (mX,mY,mB,mLB,round((maxx/2)-110),maxy-520,round((maxx/2)+110),maxy-490,black,red+((green-red)*UM))) then
        useMusic := not useMusic
    end if
    if (useMusic) then
        Font.Draw("Music on",round((maxx/2)-(Font.Width("Music on",Font2)/2)),maxy-515,Font2,black)
    else
        Font.Draw("Music off",round((maxx/2)-(Font.Width("Music off",Font2)/2)),maxy-515,Font2,black)
    end if
    
    
    
    %((round(Time.Elapsed() / 200)) mod 2)*green
    
    mLB := mB
    View.Update()
    cls()
    delay(10)
end loop

