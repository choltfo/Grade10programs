
type image : record
    picId : int
    picSrc : string
    offsetX : int   % In pixel space
    offsetY : int
end record

type animType : enum (walkUpwards,walkDownwards,walkLeft,walkRight,attack1,attack2,attack3)

type mobType : record
    animations : array 1..7,1..4 of image
end record

type mob : record
    name : string
    anims : mobType
    currentAnim : animType
    animFrame : int
end record

module anim
    import image, mob, animType
    
    var offsetX, offsetY : int := 0 % The offset from 0,0 at which to draw stuff. In World Space.
    
    var gridSize : int := 20
    
    View.SetTransparentColor(white)
    
    proc setOffset(x,y : int)
        offsetX := x
        offsetY := y
    end setOffset
    
    proc drawChar (M : mob, x,y : int)
        var img : image := M.anims.animations(cheat(int,M.currentAnim),M.animFrame)
        Pic.Draw(img.picId,((x-offsetX)*gridSize)+img.offsetX,((y-offsetY)*gridSize)+img.offsetY,0)
    end drawChar
    
    proc setAnim (M : mob, A : animType)
        
    end setAnim
        
    proc loadAnim (var A : mobType)
        for i : 1..upper(A.animations,1)
            var Title : string := "Sprites/"+A.name
            if    (i = 1) then
                Title += "_WU_"
            elsif (i = 2) then
                Title += "_WD_"
            elsif (i = 3) then
                Title += "_WL_"
            elsif (i = 4) then
                Title += "_WR_"
            elsif (i = 5) then
                Title += "_A1_"
            elsif (i = 6) then
                Title += "_A2_"
            elsif (i = 7) then
                Title += "_A3_"
            end if
            
            for o : 1..upper(A.animations,2)
                A.animations(i,o).picId := Pic.FileNew(Title+intstr(o))
            end for
        end for
    end loadAnim
    
end anim





