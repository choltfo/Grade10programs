% An RPG game. Fairly basic.

var file : int

open : file, "Map.txt", get

var mapFile : flexible array 1..0 of string 

type Mob : record
    health : int
    name : string
end record

type Tile : record
    passable : boolean
    texture : string
    pic : int
end record

module Tiles
    import Tile
    export draw
    
    var width : int := 20
    var height : int := 20
    
    proc draw(t : Tile, x,y : int)
        Pic.Draw(t.pic, (x-1)*width,maxy-(y*height),0)
    end draw
end Tiles

loop
    exit when eof(file)
    new mapFile, upper(mapFile)+1
    get : file, mapFile(upper(mapFile)) : *
end loop

var width,height : int := 0
width := strint(mapFile(2))
height := strint(mapFile(3))

var tiles : array 1..width,1..height of Tile

var textures : flexible array 1..0 of string



for i : 3..uppper(mapFile)
    if (mapFile(i) = "Textures") then
        
    end if
end for

for u : 1..upper(tiles,1)
    for i : 1..upper(tiles,2)
        var line := ((i-1)*upper(tiles,1))+u+2
        %put ""
        %put mapFile(line)
        %put mapFile(i)(8..length(mapFile(i)))
        
        if (index (mapFile(line),"Tile:") = 1) then
            tiles(u,i).passable := mapFile(line)(6)='1'
            tiles(u,i).texture  := mapFile(line)(8..length(mapFile(line)))
            tiles(u,i).pic := 0
        end if
        
        %put tiles(u,i).texture
    end for
end for

for u : 1..upper(tiles,1)
    for i : 1..upper(tiles,2)
        var found : boolean := false
        for o : 1..u
            for p : 1..i
                if (o not= u and p not= i) then
                    if (tiles(o,p).texture = tiles(u,i).texture) then
                        found := true
                        tiles(u,i).pic := tiles(o,p).pic
                        exit
                    end if
                end if
            end for
        end for
        put "BP"
        if not found then
            tiles(u,i).pic := Pic.FileNew(tiles(u,i).texture)
            Pic.SetTransparentColor(tiles(u,i).pic,13)
        end if
        put ((i-1)*upper(tiles,1))+u
    end for
end for

for o : 1..upper(tiles,1)
    for p : 1..upper(tiles,2)
        %put tiles(o,p).texture
        Tiles.draw(tiles(o,p),o,p)
    end for
end for





