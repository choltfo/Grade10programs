% The second attampt at a Tank game, this time, no leaks!

% Let's drive a Tank!


include "Core.t"

var hasWaited := false
loop    % Title screen loop
    mLB := mB
    Mouse.Where(mX, mY, mB)
    Font.Draw("The Tank Game",round((maxx/2)-(Font.Width("The Tank Game",Font1)/2)),maxy-100,Font1,black)
    Font.Draw("WASD to move",round((maxx/2)-(Font.Width("WASD to move",Font2)/2)),maxy-200,Font2,black)
    Font.Draw("Mouse to shoot",round((maxx/2)-(Font.Width("Mouse to shoot",Font2)/2)),maxy-220,Font2,black)
    Font.Draw("R to reload",round((maxx/2)-(Font.Width("R to reload",Font2)/2)),maxy-240,Font2,black)
    Font.Draw("Space to fire laser",round((maxx/2)-(Font.Width("Space to fire laser",Font2)/2)),maxy-260,Font2,black)
    
    
    if (not hasWaited) then
        View.Update()
        delay(2000)
    else
        Font.Draw("Click to start!",round((maxx/2)-(Font.Width("Click to start!",Font2)/2)),maxy-400,Font2,black*(round(Time.Elapsed() / 200)) mod 2)
    end if
    
    hasWaited := true
    
    exit when mB = 1 and mLB not=1
    mLB := mB
    View.Update()
    cls()
    delay(10)
    
    

end loop

        % IMPORTANT: NUMBER OF LEVELS HERE
for i : 1..2
loop
    loadMap("map"+intstr(i)+".txt")
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


loop
    loadMap("map1.txt")
    if playLoadedLevel() then
        put "VICTORY BIATCH!"
        View.Update()
        exit
    else
        put "YOU IDIOT!"
        View.Update()
    end if
end loop




