View.Set("graphics:1366;768")

Draw.Line(0,0, round(maxx/2), round(maxy/2), black)
Draw.Line(0,maxy, round(maxx/2), round(maxy/2), black)
Draw.Line(maxx,0, round(maxx/2), round(maxy/2), black)
Draw.Line(maxx,maxy, round(maxx/2), round(maxy/2), black)

var r := 500

for i : 1..r
    var o := r-i
    Draw.FillOval(round(maxx/2), round(maxy/2), o, o, (o|o) mod 255)
end for

%Draw.FillMapleLeaf(0,0,maxx,maxy,red)