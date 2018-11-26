# Simplat Attributes

simplat's attribute editor is a type of programming language similar to css/json

### general knowledge when

## Examples
```
.12,5,23 {
    "canHurt":true,
    "isGoal":true,
    "teleport-to":"1,10",
    "animation":"flip",
    "animation-direction":"leftright",
    "animation-rate":10
}
```
this example shows setting the textures 12, 5, and 23 to enemies, and making them the goal. This means when they get killed the player wins the level. Their animations with flip left and right according to "animation-direction" every 10 frames according to "animation-rate".

```
.level1 {  
    "name": "SMB 1-1"
}
```
 The example also shows setting the name of level1 to SMB 1-1 with the "name" tag.

## SELECTOR
.   a period at the start says you are referencing a texture  

/   a slash at the start says you are referencing a level

## ATTRIBUTES for TEXTURES
### canHurt [bool] (only textures)
makes the object an enemy, can hurt the player

### canCollide [bool] (only textures)
the player and land on top of an run into the texture, treated as level collision, do NOT use this on an enemy

### canBreak [bool] (only textures)
the player can break all instances of this texture but hitting it with the top of his head

### isGoal [bool] (only textures)
as soon as the player touches this texture they win, after this they will go to the next level1

### GENERAL TEXTURE TAGS
* #### animation ["flip", "texture"]
    the type of animation
    EXAMPLE: "animation":"texture"
    * FLIP : moves the enemy based on the "animation-direction" tag every "animation-rate" frames
    * TEXTURE : a list of textures to go through every "animation-rate" frames
* #### animation-rate [integer]
    the rate at which an animation flips or goes onto the next texture  
    EXAMPLE: "animation-rate": 10

* #### animation-direction ["updown", "leftright"]
    the direction an animation flips (only works if "animation":"flip")
    EXAMPLE: "animation-direction":"leftright"
    * updown : flips the texture vertically every "animation-rate" frames
    * leftright : flips the texture horizontally every "animation-rate" frames
* #### teleport-to ["level,textureid"]
    integer is the texture id to teleport on top of, the block you teleport to must have an open block above it.  
    EXAMPLE: "teleport-to":"1,12"

## ATTRIBUTES for LEVELS
### GENERAL LEVEL TAGS
* #### name [string]
    the name of a level, shown in the menu 
