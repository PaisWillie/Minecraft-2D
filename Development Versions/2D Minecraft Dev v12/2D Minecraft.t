%  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
%  Minecraft Turing Edition
%  Willie Pai
%  November, 2017
%  Tuting 4.1, version 1.0.1
%
%  Completion List:
%    1.  Created Character (Steve) with movement (Left, right, jump, fall)
%    1.  Block hitbox detection (Preventing walking through blocks)
%    1.
%    1.  Placing/Destroying blocks
%       a.  Prevented getting stuck from placing blocks on character
%       b.  Only being able to destroy certain blocks (e.g. Bedrock)
%  To-Do List:
%    1.  Character getting stuck in ground
%    1.  Gaining resources into inventory
%    1.  Help Button
%    1.  Restart Button
%  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/* Constants */
%Character's walking speed
const WALKING_SPEED := 3

%Character's running speed
const SPRINT_SPEED := 4

%World's gravity strength
const GRAVITY := 0.25

%Character's jump speed
const JUMP_SPEED := 3

%Character's maximum falling velocity
const FALL_SPEED := -30

/* Variables */
%Character's velocity (Real/Decimal)
var vely : real

%Key input (Boolean/True or False)
var chars : array char of boolean

%Mouse x/y position, click, and click delay timer (Integer/Number)
var mouse_x, mouse_y, mouseClick, mouseClickTimer : int

%Timer for blue box around character (Integer/Number)
var reachTimer : int

%Block selection in inventory (Integer/Number)
var blockSelect : string

%Character's x/y position for body and head (Integer/Number)
var steve_x, steve_y, steveHead_x, steveHead_y : int

%Character's Animation
var steveAnimation : int

%Coordinates for character's hitbox/boundary (Integer/Number)
var steveHitbox_x1, steveHitbox_x2, steveHitbox_y1, steveHitbox_y2 : int

%Coordinates for character's future hitbox/boundary when character moves (Integer/Number)
var steveFutureHitbox_x1, steveFutureHitbox_x2, steveFutureHitbox_y1, steveFutureHitbox_y2 : int

%Coordinates for character's future hitbox (boundary) when character falls (Integer/Number)
var steveFutureFallingHitbox_x1, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y1, steveFutureFallingHitbox_y2 : int

%Character's future x/y position (Integer/Number)
var steveFuture_x, steveFuture_y : int

%Declares wether or not user is allowed to move, jump, place blocks, or destroy blocks (Boolean/True or False)
var steveAllowMove, allowBlockPlace, allowBlockDestroy, steveAllowJump : boolean

%Declares wether or not character is standing on the ground (Boolean/True or False)
var steveOnGround : boolean

%Declares wether or not character is alive (Boolean/True or False)
var steveAlive : boolean

%Declares wether or not the loop is required to run (Boolean/True or False)
var loopExitGround, loopExitx, loopExitJump : boolean

%Declares wether or not your mouse is clicked (Boolean/True or False)
var mouseLeftClick, mouseMiddleClick, mouseRightClick : boolean
var helpScreenEnable : boolean

%Variables for type of block in each cell (Area of the screen)
var blockCellType : array 1 .. 7378 of string

%Variables for making tnt explode
var blockCellTnt : array 1 .. 7378 of boolean

%Coordinates for each cell
var blockCell_x1 : array 1 .. 7378 of int
var blockCell_x2 : array 1 .. 7378 of int
var blockCell_y1 : array 1 .. 7378 of int
var blockCell_y2 : array 1 .. 7378 of int

%Screen resolution size
var win := Window.Open ("graphics:1900;998,offscreenonly")

%Images
var logo : int := Pic.FileNew ("Turing Edition Logo.jpg")
var hotbarSlot : int := Pic.FileNew ("Hotbar_Slot.jpg")
var steveRight : int := Pic.FileNew ("SteveRight.jpg")
var steveWalkRight : int := Pic.FileNew ("SteveWalkRight.jpg")
var grass : int := Pic.FileNew ("Grass.jpg")
var dirt : int := Pic.FileNew ("Dirt.jpg")
var stone : int := Pic.FileNew ("Stone.jpg")
var bedrock : int := Pic.FileNew ("Bedrock.jpg")
var oakLog : int := Pic.FileNew ("Oak_Log.jpg")
var oakPlanks : int := Pic.FileNew ("Oak_Planks.jpg")
var oakLeaves : int := Pic.FileNew ("Oak_Leaves.jpg")
var bookshelves : int := Pic.FileNew ("Bookshelves.jpg")
var cobblestone : int := Pic.FileNew ("Cobblestone.jpg")
var tnt : int := Pic.FileNew ("TNT.jpg")
var diamondBlock : int := Pic.FileNew ("Diamond_Block.jpg")

var largeGrass : int := Pic.FileNew ("Large_Grass.jpg")
var largeDirt : int := Pic.FileNew ("Large_Dirt.jpg")
var largeOakLog : int := Pic.FileNew ("Large_Oak_Log.jpg")
var largeOakPlanks : int := Pic.FileNew ("Large_Oak_Planks.jpg")
var largeOakLeaves : int := Pic.FileNew ("Large_Oak_Leaves.jpg")
var largeBookshelves : int := Pic.FileNew ("Large_Bookshelves.jpg")
var largeCobblestone : int := Pic.FileNew ("Large_Cobblestone.jpg")
var largeTNT : int := Pic.FileNew ("Large_TNT.jpg")
var largeDiamondBlock : int := Pic.FileNew ("Large_Diamond_Block.jpg")

var restartButton : int := Pic.FileNew ("Restart_Button.jpg")
var helpButton : int := Pic.FileNew ("Help_Button.jpg")
var closeButton : int := Pic.FileNew ("Close_Button.jpg")
var helpDisplay : int := Pic.FileNew ("Help_Screen.jpg")
var menuScreen : int := Pic.FileNew ("MenuScreen.jpg")

steve_x := 950
steve_y := 100
steveFuture_x := steve_x
steveFuture_y := steve_y
steveAnimation := 1
vely := 0
reachTimer := 0
mouseClickTimer := 0
allowBlockPlace := false
allowBlockDestroy := false
mouseLeftClick := true
helpScreenEnable := true
blockSelect := "grass"

Mouse.ButtonChoose ("multibutton")

%Map = 119 x 62 'blocks'

%Block's Coordinates
for count : 1 .. 7378
    blockCell_x1 (count) := (count mod 119) * 16 - 16
    blockCell_x2 (count) := (count mod 119) * 16
    blockCell_y1 (count) := (count div 119) + (count div 119) * 16
    blockCell_y2 (count) := (count div 119) + (count div 119) * 16 + 16
end for
Pic.Draw (menuScreen, 0, 0, picMerge)
View.Update
loop
    Mouse.Where (mouse_x, mouse_y, mouseClick)
    exit when mouseClick = 1 and mouse_x >= 658 and mouse_x <= 1260 and mouse_y >= 450 and mouse_y <= 513
    Draw.Box (658, 450, 1260, 513, black)
    View.Update
end loop
loop
    steve_x := 950
    steve_y := 100
    steveAlive := true

    %Making every cell air
    for count : 1 .. 7378
	blockCellType (count) := "air"
	blockCellTnt (count) := false
    end for

    %Drawing Bedrock Ground
    for count : 1 .. 119
	blockCellType (count) := "bedrock"
    end for

    %Drawing Stone Ground
    for count : 120 .. 238
	blockCellType (count) := "stone"
    end for

    %Drawing Dirt Ground
    for count : 239 .. 356
	blockCellType (count) := "dirt"
    end for

    %Grass Floor
    for count : 357 .. 476 %476
	blockCellType (count) := "grass"
    end for

    %Tree 1
    blockCellType (500) := "oakLog"

    blockCellType (619) := "oakLog"

    blockCellType (738) := "oakLog"

    blockCellType (857) := "oakLog"

    blockCellType (973) := "oakLeaves"
    blockCellType (974) := "oakLeaves"
    blockCellType (975) := "oakLeaves"
    blockCellType (976) := "oakLeaves"
    blockCellType (977) := "oakLeaves"
    blockCellType (978) := "oakLeaves"
    blockCellType (979) := "oakLeaves"

    blockCellType (1092) := "oakLeaves"
    blockCellType (1093) := "oakLeaves"
    blockCellType (1094) := "oakLeaves"
    blockCellType (1095) := "oakLeaves"
    blockCellType (1096) := "oakLeaves"
    blockCellType (1097) := "oakLeaves"
    blockCellType (1098) := "oakLeaves"

    blockCellType (1212) := "oakLeaves"
    blockCellType (1213) := "oakLeaves"
    blockCellType (1214) := "oakLeaves"
    blockCellType (1215) := "oakLeaves"
    blockCellType (1216) := "oakLeaves"

    blockCellType (1332) := "oakLeaves"
    blockCellType (1333) := "oakLeaves"
    blockCellType (1334) := "oakLeaves"

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

	locate (2, 8)
	put "Restart"
	if helpScreenEnable = false then
	    locate (2, 227)
	    put "Help"
	else
	    locate (2, 220)
	    put "Close Help"
	end if

	locate (5, 96)
	put "1     2      3     4     5      6     7     8     9"

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
	else
	    mouseLeftClick := false
	end if
	if mouseClick = 10 then
	    mouseMiddleClick := true
	else
	    mouseMiddleClick := false
	end if
	if mouseClick = 100 then
	    mouseRightClick := true
	else
	    mouseRightClick := false
	end if

	if reachTimer > 0 then
	    reachTimer -= 1
	    Draw.Box (steveHead_x - 150, steveHead_y - 150, steveHead_x + 150, steveHead_y + 150, 11)
	end if

	if mouseClickTimer > 0 then
	    mouseClickTimer -= 1
	end if

	%Restart Button
	if mouseLeftClick = true and mouse_x >= 10 and mouse_x <= 40 and mouse_y >= 960 and mouse_y <= 990 then
	    exit
	end if

	/*Buttons*/

	%Help Button On
	if helpScreenEnable = false and mouseLeftClick = true and mouseClickTimer = 0 and mouse_x >= 1850 and mouse_x <= 1880 and mouse_y >= 960 and mouse_y <= 990 then
	    helpScreenEnable := true
	    mouseClickTimer := 50
	end if

	%Help Button Off
	if mouseLeftClick = true and helpScreenEnable = true and mouseClickTimer = 0 and mouse_x >= 1850 and mouse_x <= 1880 and mouse_y >= 960 and mouse_y <= 990 then
	    helpScreenEnable := false
	    mouseClickTimer := 50
	end if

	%Draw.Box (1850, 960, 1880, 990, black)

	%Help Screen
	if helpScreenEnable = true then
	    %Close button
	    Pic.Draw (closeButton, 1850, 960, picMerge)
	    Pic.Draw (helpDisplay, 600, 500, picMerge)
	end if

	if helpScreenEnable = false then
	    Pic.Draw (helpButton, 1850, 960, picMerge)
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
	if mouse_x >= steveFutureHitbox_x1 - 8 and mouse_x <= steveFutureHitbox_x2 + 8 and mouse_y >= steveFutureHitbox_y1 - 8 and mouse_y <= steveFutureHitbox_y2 + 8 or mouse_x >= steveHitbox_x1
		- 8
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

	/*Draw.Box (741, 940, 791, 990, red)
	 Draw.Box (791, 940, 841, 990, red)
	 Draw.Box (841, 940, 891, 990, red)
	 Draw.Box (891, 940, 941, 990, red)
	 Draw.Box (941, 940, 991, 990, red)
	 Draw.Box (991, 940, 1041, 990, red)
	 Draw.Box (1041, 940, 1091, 990, red)
	 Draw.Box (1091, 940, 1141, 990, red)
	 Draw.Box (1141, 940, 1191, 990, red)*/

	if chars ('1') then
	    blockSelect := "grass"
	elsif chars ('2') then
	    blockSelect := "dirt"
	elsif chars ('3') then
	    blockSelect := "oakLog"
	elsif chars ('4') then
	    blockSelect := "oakPlanks"
	elsif chars ('5') then
	    blockSelect := "cobblestone"
	elsif chars ('6') then
	    blockSelect := "bookshelves"
	elsif chars ('7') then
	    blockSelect := "oakLeaves"
	elsif chars ('8') then
	    blockSelect := "diamondBlock"
	elsif chars ('9') then
	    blockSelect := "TNT"
	end if

	%Places block at cursor if button is clicked and allowBlockPlace is true
	if mouseClick > 0 and allowBlockPlace = true then
	    for count : 1 .. 7378
		if mouse_x >= blockCell_x1 (count) and mouse_x <= blockCell_x2 (count) and mouse_y >= blockCell_y1 (count) and mouse_y <= blockCell_y2 (count) and blockCellType (count) = "air" and
			mouseRightClick = true then
		    blockCellType (count) := blockSelect
		end if
	    end for
	end if
	if mouseClick > 0 and allowBlockDestroy = true then
	    for count : 1 .. 7378
		if mouse_x >= blockCell_x1 (count) and mouse_x <= blockCell_x2 (count) and mouse_y >= blockCell_y1 (count) and mouse_y <= blockCell_y2 (count) and blockCellType (count) ~= "air"
			and
			blockCellType (count) ~= "bedrock" and mouseLeftClick = true then
		    blockCellType (count) := "air"
		end if
		if mouse_x >= blockCell_x1 (count) and mouse_x <= blockCell_x2 (count) and mouse_y >= blockCell_y1 (count) and mouse_y <= blockCell_y2 (count) and blockCellType (count) = "TNT"
			and mouseMiddleClick = true then
		    for count2 : 1 .. 7378
			if blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
				blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) ~= "bedrock" and blockCellType (count2) ~= "air" then
			    blockCellType (count2) := "air"
			end if
			if blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
				blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) = "TNT" then
			    blockCellTnt (count2) := true
			end if
			%Tnt explosion destroying adjacenet blocks
			if blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
				blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) ~= "air" and blockCellType (count2) ~= "TNT" and blockCellType (count2) ~= "bedrock" then
			    blockCellType (count2) := "air"
			end if
			if blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
				blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) = "TNT" then
			    blockCellTnt (count2) := true
			end if
		    end for
		    if steve_x >= blockCell_x1 (count) - 80 and steve_x <= blockCell_x2 (count) + 80 and steve_y >= blockCell_y1 (count) - 80 and steve_y >= blockCell_y2 (count) + 80 then
			steveAlive := false
		    end if
		end if
	    end for
	end if

	%Steve Draw
	Pic.Draw (steveRight, steve_x, steve_y - 12, picMerge)

	%Blocks Draw
	%Tests every single cell to draw the block in the correct one
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
	    if blockCellType (count) = "oakPlanks" then
		Pic.Draw (oakPlanks, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "oakLeaves" then
		Pic.Draw (oakLeaves, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "stone" then
		Pic.Draw (stone, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "cobblestone" then
		Pic.Draw (cobblestone, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "bookshelves" then
		Pic.Draw (bookshelves, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "TNT" then
		Pic.Draw (tnt, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	    if blockCellType (count) = "diamondBlock" then
		Pic.Draw (diamondBlock, blockCell_x1 (count), blockCell_y1 (count), picMerge)
	    end if
	end for

	/*Inventory*/
	%Draws the slot background and the blocks inside
	Pic.Draw (hotbarSlot, 741, 940, picMerge)
	Pic.Draw (largeGrass, 750, 950, picMerge)
	Pic.Draw (hotbarSlot, 791, 940, picMerge)
	Pic.Draw (largeDirt, 800, 950, picMerge)
	Pic.Draw (hotbarSlot, 841, 940, picMerge)
	Pic.Draw (largeOakLog, 850, 950, picMerge)
	Pic.Draw (hotbarSlot, 891, 940, picMerge)
	Pic.Draw (largeOakPlanks, 900, 950, picMerge)
	Pic.Draw (hotbarSlot, 941, 940, picMerge)
	Pic.Draw (largeCobblestone, 950, 950, picMerge)
	Pic.Draw (hotbarSlot, 991, 940, picMerge)
	Pic.Draw (largeBookshelves, 1000, 950, picMerge)
	Pic.Draw (hotbarSlot, 1041, 940, picMerge)
	Pic.Draw (largeOakLeaves, 1050, 950, picMerge)
	Pic.Draw (hotbarSlot, 1091, 940, picMerge)
	Pic.Draw (largeDiamondBlock, 1100, 950, picMerge)
	Pic.Draw (hotbarSlot, 1141, 940, picMerge)
	Pic.Draw (largeTNT, 1150, 950, picMerge)

	%Restart Button
	Pic.Draw (restartButton, 10, 960, picMerge)

	/* DEBUGGING CODE */
	%Used to see variables/visible hitboxes
	
	/*
	 %Debug Variables
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
	 locate (48, 40)
	 put "mouseClickTimer: ", mouseClickTimer
	 */

	%Draw.Box (10, 960, 40, 990, 7)
	%Draw.Box (1850, 960, 1880, 990, 7)

	/*Reachability in Circle*/
	%Draw.Oval (steveHead_x, steveHead_y, 150, 150, 11)

	/*Steve Hitbox*/
	%Draw.Box (steveHitbox_x1, steveHitbox_y1, steveHitbox_x2, steveHitbox_y2, 1)

	/*Future Steve Hitbox*/
	%Draw.Box (steveFutureHitbox_x1, steveFutureHitbox_y1, steveFutureHitbox_x2, steveFutureHitbox_y2, 1)

	%Future Falling Hitbox
	%Draw.Box (steveFutureFallingHitbox_x1, steveFutureFallingHitbox_y1 + 15, steveFutureFallingHitbox_x2, steveFutureFallingHitbox_y2, 10)

	/*Every Cell Hitbox*/
	%for count : 1 .. 7378
	%Draw.Box (blockCell_x1 (count), blockCell_y1 (count), blockCell_x2 (count), blockCell_y2 (count), 4)
	%end for

	/*Boundary Hitbox*/
	%Draw.FillBox (-1, 0, 0, 1019, 1)
	%Draw.FillBox (1888, 0, 1889, 1019, 1)

	/*WIP Walking Animation*/
	%if steveAnimation > 0 and steveAnimation <= 5 then
	% steveAnimation += 1
	% Pic.Draw (steveRight, steve_x, steve_y - 12, picMerge)
	% elsif steveAnimation >= 6 and steveAnimation <= 9 then
	% steveAnimation += 1
	% Pic.Draw (steveWalkRight, steve_x-3, steve_y - 12, picMerge)
	% elsif steveAnimation = 10 then
	% steveAnimation := 1
	% Pic.Draw (steveWalkRight, steve_x-3, steve_y - 12, picMerge)
	% end if

	/*WIP Tnt Domino Effect*/
	%for count : 1 .. 7378
	%if blockCellTnt (count) = true then
	%for count2 : 1 .. 7378
	%if blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
	%blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) = "TNT" then
	%blockCellTnt (count2) := true
	%end if
	%if blockCellTnt (count2) = true and blockCell_x1 (count2) >= blockCell_x1 (count) - 80 and blockCell_x2 (count2) <= blockCell_x2 (count) + 80 and blockCell_y1 (count2) >= blockCell_y1 (count) - 80 and
	%blockCell_y2 (count2) <= blockCell_y2 (count) + 80 and blockCellType (count2) ~= "air" and blockCellType (count2) ~= "TNT" and blockCellType (count2) ~= "bedrock" then
	%blockCellType (count2) := "air"
	%end if
	%end for
	%end if
	%end for

	View.Update

	delay (1)

	cls

    end loop
end loop
