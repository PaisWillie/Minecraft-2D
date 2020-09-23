const GROUND_HEIGHT := 272
const WALKING_SPEED := 5
const SPRINT_SPEED := 7
const GRAVITY := 1
const JUMP_SPEED := 6

var win := Window.Open ("graphics:1900;998,offscreenonly")

var vely : int
var chars : array char of boolean
var blockCellType : array 1 .. 7378 of int
var blockCell_x1 : array 1 .. 7378 of int
var blockCell_x2 : array 1 .. 7378 of int
var blockCell_y1 : array 1 .. 7378 of int
var blockCell_y2 : array 1 .. 7378 of int
var steve_x, steve_y : int
var steveHitbox_x1, steveHitbox_x2, steveHitbox_y1, steveHitbox_y2 : int

var steveRight : int := Pic.FileNew ("SteveRight.jpg")
var grass : int := Pic.FileNew ("Grass.jpg")

steve_x := 1200
steve_y := 272
vely := 0

for count : 1 .. 7378
    blockCell_x1 (count) := 0
end for


loop

    for count : 0 .. 118
	Pic.Draw (grass, count * 16, 256, picMerge)
    end for

    %for count : 0..61
    %Pic.Draw (grass, 0,count*16,picMerge)
    %end for

    %Keyboard Input
    Input.KeyDown (chars)

    %Jumping
    if (chars (' ') and steve_y = GROUND_HEIGHT or chars ('w') and steve_y = GROUND_HEIGHT) then
	vely := JUMP_SPEED
    end if

    steve_y += round (vely)

    vely -= GRAVITY

    if chars ('a') then
	steve_x -= WALKING_SPEED
    end if

    if chars ('d') then
	steve_x += WALKING_SPEED
    end if

    if steve_y < GROUND_HEIGHT then
	steve_y := GROUND_HEIGHT
	vely := 0
    end if

    Pic.Draw (steveRight, steve_x, steve_y, picMerge)

    Pic.Draw (grass, 1150, 272, picMerge)

    View.Update
    delay (25)
    cls

end loop
