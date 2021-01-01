# ⛏️ Minecraft 2D
A 2D platformer sandbox fan-made game based on [Minecraft](https://www.minecraft.net/) by Mojang. Developed using [Turing](https://en.wikipedia.org/wiki/Turing_(programming_language)) programming language.

<img src="README%20Assets/Main%20Menu.png" alt="Minecraft 2D main menu" width="400"/>

This game was originally designed for my 10th grade academic final project, where it utilizes condition statements, looping, variables, graphics, and other programming aspects.

## 📑 Contents

1. **[Features](#-features)**  
1.1 [Movement](#movement)  
1.2 [Block Placing](#block-placing)  
1.3 [Block Breaking](#block-breaking)  
1.4 [Functional TNT](#functional-tnt)  
1.5 [GUI and Instructions](#gui-and-instructions)  
2. **[How to Install](#-how-to-install)**  

## 📝 Features

### Movement

The player's movement can be controlled using `W` or `D` for left and right respectively, while using `Spacebar` for jump.
Collision is detected using pre-defined hitboxes around both the player and each block in the game, making it possible for the player to maneuver, jump over obstacles, and fall landing on a surface.

![Walking animation WIP](https://i.imgur.com/90vPBUy.gif)

### Block Placing

Block placement is achieved by detecting the user's mouse position and comparing it relative to the position of the player. The player can only place blocks within a predefined range of the physical player, which is checked when the player attempts to place a block using `Right Click`. The player can also choose from a defined set of different blocks by using the keys `1-9`. 

![Placing blocks down](README%20Assets/Block%20Placing.gif)

### Block Breaking

Block breaking works similarily to block placing, where the player can only destroy blocks that are within a predefined range from the physical player using `Left Click`.

![Breaking blocks](https://github.com/PaisWillie/Minecraft-2D/blob/master/README%20Assets/Block%20Breaking.gif)

### Functional TNT

TNT is a well known feature in Mojang's [Minecraft](https://www.minecraft.net/) that has been a part of the game since [Java Edition Classic](https://minecraft.gamepedia.com/Java_Edition_Classic). In Minecraft 2D, TNT can be placed or destroyed similarily to every other block, but is ignited using `Middle Click`, destroying the blocks around it within a specific range.

![Placing TNT and destroying blocks](https://github.com/PaisWillie/Minecraft-2D/blob/master/README%20Assets/TNT.gif)

### GUI and Instructions

When the game begins, a flat-world is generated, and the player is presented with a graphical user interface with instructions on how the game is played. Although there is no objective, it is designed to be a sandbox game, where it is up to the player's imagination and creativity.

<img src="README%20Assets/GUI.png" alt="Minecraft 2D Game GUI and Instructions" width="500"/>

## 🛠 How to Install

In order to play Minecraft 2D,

1. Download the game files at the top of the GitHub repository by clicking `Code 🠒 Download ZIP`, and unzipping the downloaded folder.  
2. Install Turing [here](http://compsci.ca/blog/download-turing-411/).
3. Unzip the downloaded folder, and run `Turing.exe`. 
4. Click `Open` at the top of the Turing program, and navigate inside one of the versions of Minecraft 2D from the downloaded game files (preferrably the Beta version, which is the latest version), and open `Minecraft 2D.t`
5. Click `Run`!
