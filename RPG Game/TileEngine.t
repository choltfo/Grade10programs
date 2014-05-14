% A tile engine for RPG games.

type Texture : record
    file : string
    pic : int
end record

type Tile : record
    passable : boolean
    texture : int
end record

var textures : flexible array 1..0 of Texture
var tiles : flexible array 1..0,1..0 of Tile

proc loadMap (map : string)
    var fileNum : int
    open : fileNum, map, get
    
    var mapFile : flexible array 1..0 of string
    
    loop
        new mapFile, upper(mapFile)+1
        get : fileNum, mapFile(upper(mapFile)) : *
        exit when eof(fileNum)
    end loop
    
    var i := 1
    loop
        put i
        if (mapFile(i) = "Map:") then
            new tiles, strint(mapFile(i+1)), strint(mapFile(i+2))
            i+=3
        elsif (mapFile(i) = "Textures {") then
            var o := 1
            loop
                new textures, upper(textures)+1
                textures(upper(textures)).file := mapFile(i+o)(5..length(mapFile(i+o)))
                textures(upper(textures)).pic := Pic.FileNew(textures(upper(textures)).file)
                o+=1
                exit when mapFile(i+o) = "}"
            end loop
            i += o
        elsif (mapFile(i) = "Tiles {") then
            for y : 1..upper(tiles,2)
                for x : 1..upper(tiles,1)
                    tiles(x,y).passable := mapFile(i+y)(7*(x-1)+5) = '1'
                    tiles(x,y).texture := strint(mapFile(i+y)(7*(x-1)+1..7*(x-1)+3))
                end for
            end for
            i+=upper(tiles,2)
        else
            i += 1
        end if
        exit when i = upper(mapFile)+1
    end loop
    
end loadMap

proc drawMap
    for y : 1..upper(tiles,2)
        for x : 1..upper(tiles,1)
            Pic.Draw(textures(tiles(x,y).texture).pic,(x-1)*20,maxy-((y-1)*20),0)
        end for
    end for
end drawMap

loadMap("Map.txt")
drawMap
