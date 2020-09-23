const GROUND_HEIGHT := 272
const WALKING_SPEED := 3
const SPRINT_SPEED := 4
const GRAVITY := 0.25
const JUMP_SPEED := 3
const FALL_SPEED := -30

var vely : real
var chars : array char of boolean
var mouse_x, mouse_y, mouseClick, reachTimer, inventorySelect : int
var steve_x, steve_y, steveHead_x, steveHead_y : int
var steveHitbox_x1, steveHitbox_x2, steveHitbox_y1, steveHitbox_y2 : int
var steveFutureHitbox_x1, steveFutureHitbox_x2, steveFutureHitbox_y1, steveFutureHitbox_y2 : int
var steveFutureFallingHitbox_x1, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y1, steveFutureFallingHitbox_y2 : int
var steveFuture_x, steveFuture_y : int
var steveAllowMove, steveOnGround, allowBlockPlace, allowBlockDestroy, steveAllowJump : boolean
var loopExitGround, loopExitx, loopExitJump : boolean
var mouseLeftClick, mouseMiddleClick, mouseRightClick : boolean
var blockCellType : array 1 .. 7378 of string
var blockCell_x1 : array 1 .. 7378 of int
var blockCell_x2 : array 1 .. 7378 of int
var blockCell_y1 : array 1 .. 7378 of int
var blockCell_y2 : array 1 .. 7378 of int

var win := Window.Open ("graphics:1900;998,offscreenonly")
var logo : int := Pic.FileNew ("Turing Edition Logo.jpg")
var hotbarSlot : int := Pic.FileNew ("Hotbar_Slot.jpg")
var steveRight : int := Pic.FileNew ("SteveRight.jpg")
var grass : int := Pic.FileNew ("Grass.jpg")
var dirt : int := Pic.FileNew ("Dirt.jpg")
var stone : int := Pic.FileNew ("Stone.jpg")
var bedrock : int := Pic.FileNew ("Bedrock.jpg")
var oakLog : int := Pic.FileNew ("Oak_Log.jpg")
var oakPlanks : int := Pic.FileNew ("Oak_Planks.jpg")
var largeGrass : int := Pic.FileNew ("Large_Grass.jpg")
var restartButton : int := Pic.FileNew ("Restart_Button.jpg")

steve_x := 1200
steve_y := 272
steveFuture_x := steve_x
steveFuture_y := steve_y
vely := 0
reachTimer := 0
allowBlockPlace := false
allowBlockDestroy := false

Mouse.ButtonChoose ("multibutton")

%Map = 119 x 62 'blocks'

%Block's Coordinates
for count : 1 .. 7378
    blockCell_x1 (count) := (count mod 119) * 16 - 16
    blockCell_x2 (count) := (count mod 119) * 16
    blockCell_y1 (count) := (count div 119) + (count div 119) * 16
    blockCell_y2 (count) := (count div 119) + (count div 119) * 16 + 16
end for

loop
    %Making entire world air
    for count : 1 .. 7378
	blockCellType (count) := "air"
    end for

    %Bedrock Ground
    for count : 1 .. 119
	blockCellType (count) := "bedrock"
    end for

    %Stone Ground
    for count : 120 .. 238
	blockCellType (count) := "stone"
    end for

    %Dirt Ground
    for count : 239 .. 356
	blockCellType (count) := "dirt"
    end for

    %Grass Floor
    for count : 357 .. 476
	blockCellType (count) := "grass"
    end for

    %Tree 1
    blockCellType (500) := "oakLog"
    blockCellType (619) := "oakLog"
    blockCellType (738) := "oakLog"
    blockCellType (857) := "oakLog"
    blockCellType (976) := "oakLog"
    blockCellType (1095) := "oakLog"

    loop

	steveHead_x := steve_x + 4
	steveHead_y := steve_y + 25
	steveHitbox_x1 := steve_x
	steveHitbox_x2 := steve_x + 7
	steveHitbox_y1 := steve_y - 9
	steveHitbox_y2 := steve_y + 21
	steveFuture_x := steveHitbox_x1
	steveFuture_y := steveHitbox_y1
	steveFutureFallingHitbox_x1 := steveHitbox_x1
	steveFutureFallingHitbox_x2 := steveHitbox_x2
	steveFutureFallingHitbox_y1 := steveHitbox_y1 - JUMP_SPEED
	steveFutureFallingHitbox_y2 := steveHitbox_y2 - JUMP_SPEED

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
	if mouseClick > 0 then
	    reachTimer := 50
	end if

	if mouseClick = 1 then
	    mouseLeftClick := true
	end if
	if mouseClick = 10 then
	    mouseMiddleClick := true
	end if
	if mouseClick = 100 then
	    mouseRightClick := true
	end if

	if reachTimer > 0 then
	    reachTimer -= 1
	    Draw.Box (steveHead_x - 150, steveHead_y - 150, steveHead_x + 150, steveHead_y + 150, 11)
	end if

	%Future-Hitboxes
	steveFutureHitbox_x1 := steveFuture_x
	steveFutureHitbox_x2 := steveFuture_x + 7
	steveFutureHitbox_y1 := steveFuture_y
	steveFutureHitbox_y2 := steveFuture_y + 28

	%Move-Allow & Loop Reset
	steveAllowMove := true
	steveAllowJump := true
	steveOnGround := false
	loopExitx := false
	loopExitGround := false
	loopExitJump := false

	%Hitbox Overlap Test
	for count : 1 .. 7378
	    %X-Axis Test
	    for x : steveFutureHitbox_x1 .. steveFutureHitbox_x2
		exit when loopExitx = true
		if x >= blockCell_x1 (count) and x <= blockCell_x2 (count) and blockCellType (count) ~= "air" then
		    for y : steveFutureHitbox_y1 .. steveFutureHitbox_y2
			if y >= blockCell_y1 (count) and y <= blockCell_y2 (count) and blockCellType (count) ~= "air" or x <= 0 or x >= 1888 then
			    steveAllowMove := false
			    loopExitx := true
			    exit
			end if
		    end for
		end if
	    end for
	    %Fall Test
	    for x : steveFutureFallingHitbox_x1 .. steveFutureFallingHitbox_x1
		exit when loopExitGround = true and loopExitJump = true
		if x >= blockCell_x1 (count) and x <= blockCell_x2 (count) and blockCellType (count) ~= "air" then
		    for y : steveFutureFallingHitbox_y1 .. steveFutureFallingHitbox_y2 - 15
			if y >= blockCell_y1 (count) and y <= blockCell_y2 (count) and blockCellType (count) ~= "air" then
			    steveOnGround := true
			    loopExitGround := true
			    %steve_y := blockCell_y2 (count) + 8
			    exit
			end if
		    end for
		    for y : steveFutureFallingHitbox_y1 + 15 .. steveFutureFallingHitbox_y2
			if y >= blockCell_y1 (count) and y <= blockCell_y2 (count) and blockCellType (count) ~= "air" then
			    steveAllowJump := false
			    loopExitJump := true
			    exit
			end if
		    end for
		end if
	    end for
	end for

	/*Character movement*/

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

	/*Block Place Cursor*/

	%Tests to see if mouse cursor is located near enough to, but not on top of, Steve (character) to allow the user to place blocks
	if mouse_x >= steveFutureHitbox_x1 - 8 and mouse_x <= steveFutureHitbox_x2 + 8 and mouse_y >= steveFutureHitbox_y1 - 8 and mouse_y <= steveFutureHitbox_y2 + 8 or mouse_x >= steveHitbox_x1 - 8
		and mouse_x <= steveHitbox_x2 + 8 and mouse_y >= steveHitbox_y1 - 8 and mouse_y <= steveHitbox_y2 + 8 then
	    allowBlockPlace := false
	elsif mouse_x >= steveHead_x - 150 and mouse_x <= steveHead_x + 150 and mouse_y >= steveHead_y - 150 and mouse_y <= steveHead_y + 150 then
	    allowBlockPlace := true
	else
	    allowBlockPlace := false
	end if

	/*Block Place Cursor*/

	%Tests to see if mouse cursor is located near enough to Steve (character) to allow the user to destroy blocks
	if mouse_x >= steveHead_x - 150 and mouse_x <= steveHead_x + 150 and mouse_y >= steveHead_y - 150 and mouse_y <= steveHead_y + 150 then
	    allowBlockDestroy := true
	else
	    allowBlockDestroy := false
	end if

	/*Jumping*/

	%Changes y-axis velocity when spacebar or 'w' is pressed
	if chars (' ') and steveAllowJump = true and steveOnGround = true or chars ('w') and steveAllowJump = true and steveOnGround = true then
	    vely := JUMP_SPEED
	    steveOnGround := false
	end if

	%Resets Steve's (character) y-axis velocity when standing on ground
	if vely ~= 0 and steveOnGround = true then
	    vely := 0
	end if

	steve_y += round (vely)

	/*Gravity*/

	%Causes Steve (character) to fall when not standing on ground
	if steveOnGround = false then
	    vely -= GRAVITY
	end if

	if steveAllowJump = false and steveOnGround = false and vely > 0 then
	    vely := 0
	end if

	%Limits Steve's (character) fall speed limit
	if vely < FALL_SPEED then
	    vely := FALL_SPEED
	end if

	/*Block Placing*/

	%Places block at cursor if button is clicked and allowBlockPlace is true
	if mouseClick > 0 and allowBlockPlace = true then
	    for count : 1 .. 7378
		if mouse_x >= blockCell_x1 (count) and mouse_x <= blockCell_x2 (count) and mouse_y >= blockCell_y1 (count) and mouse_y <= blockCell_y2 (count) and blockCellType (count) = "air" and
			mouseClick = 100 then
		    blockCellType (count) := "grass"
		end if
	    end for
	end if
	if mouseClick > 0 and allowBlockDestroy = true then
	    for count : 1 .. 7378
		if mouse_x >= blockCell_x1 (count) and mouse_x <= blockCell_x2 (count) and mouse_y >= blockCell_y1 (count) and mouse_y <= blockCell_y2 (count) and blockCellType (count) ~= "air"
			and
			blockCellType (count) ~= "bedrock" and mouseClick = 1 then
		    blockCellType (count) := "air"
		end if
	    end for
	end if

	%Debug
	locate (38, 40)
	put "DEBUG"
	locate (39, 40)
	put skip
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
	locate (46, 40)
	put "mouseClick: ", mouseClick
	locate (47, 40)
	put "steveAllowJump: ", steveAllowJump

	%Steve Draw
	Pic.Draw (steveRight, steve_x, steve_y - 12, picMerge)

	%Steve Hitbox
	Draw.Box (steveHitbox_x1, steveHitbox_y1, steveHitbox_x2, steveHitbox_y2, 1)

	%Future Steve Hitbox
	%Draw.Box (steveFutureHitbox_x1, steveFutureHitbox_y1, steveFutureHitbox_x2, steveFutureHitbox_y2, 1)

	%Future Falling Hitbox
	%Draw.Box (steveFutureFallingHitbox_x1, steveFutureFallingHitbox_y1 + 15, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y2, 10)

	%Every Cell Hitbox
	/*for count : 1 .. 7378
	 Draw.Box (blockCell_x1 (count), blockCell_y1 (count), blockCell_x2 (count), blockCell_y2 (count), 4)
	 end for*/

	%Boundary Hitbox
	Draw.FillBox (-1, 0, 0, 1019, 1)
	Draw.FillBox (1888, 0, 1889, 1019, 1)

	%Blocks Draw
	for count : 1 .. 7378
	    if blockCellType (count) = "grass" then
		Pic.Draw (grass, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "dirt" then
		Pic.Draw (dirt, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "bedrock" then
		Pic.Draw (bedrock, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "oakLog" then
		Pic.Draw (oakLog, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "stone" then
		Pic.Draw (stone, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	end for

	/*Inventory*/
	Pic.Draw (hotbarSlot, 491, 940, picMerge)
	Pic.Draw (largeGrass, 500, 950, picMerge)

	%Restart Button
	Pic.Draw (restartButton, 10, 960, picMerge)

	%Reachability in Circle
	%Draw.Oval (steveHead_x, steveHead_y, 150, 150, 11)

	%Reachability in Box
	%Draw.Box (steveHead_x - 150, steveHead_y - 150, steveHead_x + 150, steveHead_y + 150, 11)

	View.Update

	delay (1)

	cls

    end loop
end loop
/*
 Prevent placing blocks inside of Steve
 */
