const GROUND_HEIGHT := 272
const WALKING_SPEED := 5
const SPRINT_SPEED := 7
const GRAVITY := 1
const JUMP_SPEED := 6
const FALL_SPEED := -30

var vely : int
var chars : array char of boolean
var mouse_x, mouse_y, mouseClick, reachTimer : int
var steve_x, steve_y, steveHead_x, steveHead_y : int
var steveHitbox_x1, steveHitbox_x2, steveHitbox_y1, steveHitbox_y2 : int
var steveFutureHitbox_x1, steveFutureHitbox_x2, steveFutureHitbox_y1, steveFutureHitbox_y2 : int
var steveFutureFallingHitbox_x1, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y1, steveFutureFallingHitbox_y2 : int
var steveFuture_x, steveFuture_y : int
var steveAllowMove, steveOnGround, allowBlockPlace : boolean
var loopExitJump, loopExitFall, loopExitx : boolean
var blockCellType : array 1 .. 7378 of string
var blockCell_x1 : array 1 .. 7378 of int
var blockCell_x2 : array 1 .. 7378 of int
var blockCell_y1 : array 1 .. 7378 of int
var blockCell_y2 : array 1 .. 7378 of int

var win := Window.Open ("graphics:1900;998,offscreenonly")
var logo : int := Pic.FileNew ("Turing Edition Logo.jpg")
var steveRight : int := Pic.FileNew ("SteveRight.jpg")
var grass : int := Pic.FileNew ("Grass.jpg")
var dirt : int := Pic.FileNew ("Dirt.jpg")
var stone : int := Pic.FileNew ("Stone.jpg")
var bedrock : int := Pic.FileNew ("Bedrock.jpg")
var oakLog : int := Pic.FileNew ("Oak_Log.jpg")
var oakPlanks : int := Pic.FileNew ("Oak_Planks.jpg")

steve_x := 1200
steve_y := 272
steveFuture_x := steve_x
steveFuture_y := steve_y
vely := 0
reachTimer := 0
allowBlockPlace := false

%Map = 119 x 62 'blocks'

%Making entire world air
for count : 1 .. 7378
    blockCellType (count) := "air"
end for

for count : 1 .. 119
    blockCellType (count) := "bedrock"
end for

%Left Wall Grass
var acc : int
for count : 0 .. 25
    acc := 120 + count * 119
    blockCellType (acc) := "grass"
end for

for count : 1 .. 7378
    blockCell_x1 (count) := (count mod 119) * 16 - 16
    blockCell_x2 (count) := (count mod 119) * 16
    blockCell_y1 (count) := (count div 119) + (count div 119) * 16
    blockCell_y2 (count) := (count div 119) + (count div 119) * 16 + 16
end for

loop

    steveHead_x := steve_x + 4
    steveHead_y := steve_y + 25
    steveHitbox_x1 := steve_x
    steveHitbox_x2 := steve_x + 7
    steveHitbox_y1 := steve_y - 5
    steveHitbox_y2 := steve_y + 27
    steveFuture_x := steve_x
    steveFuture_y := steve_y
    steveFutureFallingHitbox_x1 := steveHitbox_x1
    steveFutureFallingHitbox_x2 := steveHitbox_x2
    steveFutureFallingHitbox_y1 := steveHitbox_y1 - JUMP_SPEED
    steveFutureFallingHitbox_y2 := steveHitbox_y2 - JUMP_SPEED

    /*for count : 0 .. 118
     Pic.Draw (grass, count * 16, 256, picMerge)
     end for
     for count : 1 .. 7378
     Draw.FillBox (blockCell_x1 (count), blockCell_y1 (count), blockCell_x2 (count), blockCell_y2 (count), black)
     View.Update
     end for

     Bottom Left
     Pic.Draw (grass, 1,1,picMerge)

     for count : 0..61
     Pic.Draw (grass, 0,count*16,picMerge)
     end for
     */

    %Keyboard Input
    Input.KeyDown (chars)

    %Mouse Input
    Mouse.Where (mouse_x, mouse_y, mouseClick)

    %Jump Movement Key
    if (chars (' ') and steveOnGround = true or chars ('w') and steveOnGround = true) then
	steveFuture_y := steve_y + JUMP_SPEED
    end if

    %Left Movement Key
    if (chars ('a') and chars (KEY_CTRL)) then
	steveFuture_x := steve_x - SPRINT_SPEED
    elsif chars ('a') then
	steveFuture_x := steve_x - WALKING_SPEED
    end if

    %Right Movement Key
    if (chars ('d') and chars (KEY_CTRL)) then
	steveFuture_x := steve_x + SPRINT_SPEED
    elsif chars ('d') then
	steveFuture_x := steve_x + WALKING_SPEED
    end if

    %Click Button
    if mouseClick = 1 then
	reachTimer := 50
    end if

    if reachTimer > 0 then
	reachTimer -= 1
	Draw.Box (steveHead_x - 150, steveHead_y - 150, steveHead_x + 150, steveHead_y + 150, 11)
    end if

    %Future-Hitboxes
    steveFutureHitbox_x1 := steveFuture_x
    steveFutureHitbox_x2 := steveFuture_x + 7
    steveFutureHitbox_y1 := steveFuture_y
    steveFutureHitbox_y2 := steveFuture_y + 32

    %Move-Allow & Loop Reset
    steveAllowMove := true
    steveOnGround := false
    loopExitx := false

    %Hitbox Overlap Test
    for count : 1 .. 7378
	%X-Axis Test
	for x : steveFutureHitbox_x1 .. steveFutureHitbox_x2
	    exit when loopExitx = true
	    if x >= blockCell_x1 (count) and x <= blockCell_x2 (count) and blockCellType (count) ~= "air" then
		for y : steveFutureHitbox_y1 .. steveFutureHitbox_y2
		    if y >= blockCell_y1 (count) and x <= blockCell_y2 (count) and blockCellType (count) ~= "air" then
			steveAllowMove := false
			loopExitx := true
			exit
		    end if
		end for
	    end if
	end for
	%Fall Test
	for x : steveFutureFallingHitbox_x1 .. steveFutureFallingHitbox_x1
	    if x >= blockCell_x1 (count) and x <= blockCell_x2 (count) and blockCellType (count) ~= "air" then
		for y : steveFutureFallingHitbox_y1 .. steveFutureFallingHitbox_y2
		    if y >= blockCell_y1 (count) and y <= blockCell_y2 (count) and blockCellType (count) ~= "air" then
			steveOnGround := true
		    end if
		end for
	    end if
	end for
    end for

    %Left Movement
    if (chars ('a') and chars (KEY_CTRL)) and steveAllowMove = true then
	steve_x -= SPRINT_SPEED
    elsif chars ('a') and steveAllowMove = true then
	steve_x -= WALKING_SPEED
    end if

    %Right Movement
    if (chars ('d') and chars (KEY_CTRL)) and steveAllowMove = true then
	steve_x += SPRINT_SPEED
    elsif chars ('d') and steveAllowMove = true then
	steve_x += WALKING_SPEED
    end if

    %Block Place
    if mouse_x >= steveHead_x - 150 and mouse_x <= steveHead_x + 150 and mouse_y >= steveHead_y - 150 and mouse_y <= steveHead_y + 150 then
	allowBlockPlace := true
    else
	allowBlockPlace := false
    end if

    %Jumping
    if chars (' ') and steveOnGround = true or chars ('w') and steveOnGround = true then
	vely := JUMP_SPEED
    end if

    if vely ~= 0 and steveOnGround = true then
	vely := 0
    end if

    %Gravity
    if steveOnGround = false then
	vely -= GRAVITY
    end if
    if vely < FALL_SPEED then
	vely := FALL_SPEED
    end if
    if steveOnGround = true and vely ~= 0 then
	vely := 0
    end if

    %Debug
    locate (40, 40)
    put "steveOnGround: ", steveOnGround
    locate (41, 40)
    put "steveAllowMove: ", steveAllowMove
    locate (42, 40)
    put "vely: ", vely
    locate (43, 40)
    put "steve_x: ", steve_x
    locate (44, 40)
    put "steve_y: ", steve_y
    locate (45, 40)
    put "allowBlockPlace: ", allowBlockPlace

    steve_y += round (vely)

    %Steve Draw
    Pic.Draw (steveRight, steve_x, steve_y - 3, picMerge)

    %Steve Hitbox
    %Draw.Box (steveHitbox_x1, steveHitbox_y1, steveHitbox_x2, steveHitbox_y2, 11)

    %Future Steve Hitbox
    %Draw.Box (steveFutureHitbox_x1, steveFutureHitbox_y1, steveFutureHitbox_x2, steveFutureHitbox_y2, 1)

    %Future Falling Hitbox
    %Draw.Box (steveFutureFallingHitbox_x1, steveFutureFallingHitbox_y1, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y2, 10)

    %Every Cell Hitbox
    /*for count : 1 .. 7378
     Draw.Box (blockCell_x1 (count), blockCell_y1 (count), blockCell_x2 (count), blockCell_y2 (count), 4)
     end for*/

    %Boundary Hitbox
    Draw.FillBox (-10, 0, 0, 119, 1)

    %Blocks Draw
    for count : 1 .. 7378
	if blockCellType (count) = "grass" then
	    Pic.Draw (grass, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	end if
	if blockCellType (count) = "bedrock" then
	    Pic.Draw (bedrock, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	end if
    end for

    %Reachability in Circle
    %Draw.Oval (steveHead_x, steveHead_y, 150, 150, 11)

    %Reachability in Box
    %Draw.Box (steveHead_x - 150, steveHead_y - 150, steveHead_x + 150, steveHead_y + 150, 11)

    View.Update

    delay (1)

    cls

end loop

%Steve cannot jump if on ground



