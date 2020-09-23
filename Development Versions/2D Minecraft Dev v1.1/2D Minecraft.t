const GROUND_HEIGHT := 272
const WALKING_SPEED := 5
const SPRINT_SPEED := 7
const GRAVITY := 1
const JUMP_SPEED := 6

var win := Window.Open ("graphics:1900;998,offscreenonly")

var vely : int
var chars : array char of boolean
var steve_x, steve_y : int
var steveHitbox_x1, steveHitbox_x2, steveHitbox_y1, steveHitbox_y2 : int
var steveFutureHitbox_x1, steveFutureHitbox_x2, steveFutureHitbox_y1, steveFutureHitbox_y2 : int
var steveFuture_x, steveFuture_y : int
var steveAllowMove_x, steveAllowMove_y : boolean
var blockCellType : array 1 .. 7378 of int
var blockCell_x1 : array 1 .. 7378 of int
var blockCell_x2 : array 1 .. 7378 of int
var blockCell_y1 : array 1 .. 7378 of int
var blockCell_y2 : array 1 .. 7378 of int

var logo : int := Pic.FileNew ("Turing Edition Logo.jpg")
var steveRight : int := Pic.FileNew ("SteveRight.jpg")
var grass : int := Pic.FileNew ("Grass.jpg")

steve_x := 1200
steve_y := 272
steveFuture_x := steve_x
steveFuture_y := steve_y
vely := 0

%Map = 119 x 62 'blocks'

for count : 1 .. 7378
    blockCellType (count) := 0
end for

for count : 1 .. 7378
    blockCell_x1 (count) := (count mod 119) * 16 - 16
    blockCell_x2 (count) := (count mod 119) * 16
    blockCell_y1 (count) := (count div 119) + (count div 119) * 16
    blockCell_y2 (count) := (count div 119) + (count div 119) * 16 + 16
end for

loop

    steveHitbox_x1 := steve_x
    steveHitbox_x2 := steve_x + 10
    steveHitbox_y1 := steve_y
    steveHitbox_y2 := steve_y + 10

    for count : 0 .. 118
	Pic.Draw (grass, count * 16, 256, picMerge)
    end for
    %for count : 1 .. 7378
    %    Draw.FillBox (blockCell_x1 (count), blockCell_y1 (count), blockCell_x2 (count), blockCell_y2 (count), black)
    %    View.Update
    %end for

    %Bottom Left
    %Pic.Draw (grass, 1,1,picMerge)

    %for count : 0..61
    %Pic.Draw (grass, 0,count*16,picMerge)
    %end for

    %Keyboard Input
    Input.KeyDown (chars)

    %Jump Movement Key
    if (chars (' ') and steve_y = GROUND_HEIGHT or chars ('w') and steve_y = GROUND_HEIGHT) then
	steveFuture_y += JUMP_SPEED
    end if

    if (chars (' ') and steve_y = GROUND_HEIGHT or chars ('w') and steve_y = GROUND_HEIGHT) then
	vely := JUMP_SPEED
    end if

    %Left Movement Key
    if (chars ('a') and chars (KEY_CTRL)) then
	steveFuture_x := steve_x - SPRINT_SPEED
    elsif chars ('a') then
	steveFuture_x := steve_x - WALKING_SPEED
    end if

    %Right Movement Key
    if (chars ('d') and chars (KEY_CTRL)) then
	steveFuture_x += SPRINT_SPEED
    elsif chars ('d') then
	steveFuture_x += WALKING_SPEED
    end if

    %Future-Hitboxes
    steveFutureHitbox_x1 := steveFuture_x
    steveFutureHitbox_x2 := steveFuture_x + 10
    steveFutureHitbox_y1 := steveFuture_y
    steveFutureHitbox_y2 := steveFuture_y + 10

    %Move-Allow Reset
    steveAllowMove_x := true
    steveAllowMove_y := true

    %Hitbox Overlap Test
    for count : 1 .. 7378
	%X-Axis Test
	for x : steveFutureHitbox_x1 .. steveFutureHitbox_x2
	    if x >= blockCell_x1 (count) and x <= blockCell_x2 (count) then
		steveAllowMove_x := false
	    end if
	end for
	%Y-Axis Test
	for y : steveFutureHitbox_y1 .. steveFutureHitbox_y2
	    if y >= blockCell_y1 (count) and y <= blockCell_y2 (count) then
		steveAllowMove_y := false
	    end if
	end for
    end for

    if (chars ('a') and chars (KEY_CTRL)) and steveAllowMove_x = true then
	steve_x -= SPRINT_SPEED
    elsif chars ('a') and steveAllowMove_x = true then
	steve_x -= WALKING_SPEED
    end if

    if (chars ('d') and chars (KEY_CTRL)) and steveAllowMove_x = true then
	steve_x += SPRINT_SPEED
    elsif chars ('d') and steveAllowMove_x = true then
	steve_x += WALKING_SPEED
    end if

    if (chars ('w') or chars (' ')) and steveAllowMove_y = true then
	steve_y += SPRINT_SPEED
    elsif chars ('d') and steveAllowMove_y = true then
	steve_y += round (vely)
    end if

    if vely > 0 then
	vely -= GRAVITY
    end if

    Pic.Draw (steveRight, steve_x, steve_y, picMerge)

    Pic.Draw (grass, 1150, 272, picMerge)

    View.Update
    delay (25)
    cls

end loop
