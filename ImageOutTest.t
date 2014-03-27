for i : 1 .. 100 
    Draw.FillOval (Rand.Int (0, maxx), Rand.Int (0, maxy), Rand.Int (3, 40), Rand.Int (3, 40), Rand.Int (0, maxcolour)) 
end for 
Pic.ScreenSave (0, 0, maxx, maxy, "File.bmp")

Pic
cls 
var pic : int := Pic.FileNew ("File.bmp") 
Pic.Draw (pic, 0, 0, picCopy)
