<h1 align="center">
<img src="./character_icon.png"/>
<br/>
3D Characters Repository</h1>

This repository contains our open-source 3D models, pre-configured and compatible with Godot game engine version 4. The models have been tested and are ready to be used out of the box.
# Installation
1. Download or clone this repository.
2. Drag and drop the desired folder(s) from the `models` directory into your project.
3. After Godot imports everything, you can now use the character in your project.
4. To use the model, you need to instantiate the `model_name_skin.tscn` scene. This is the default scene where the model is set up and where you can call specific methods.
# Models
## GDbot
**Properties**
`_walk_run_blend_position`: A setter that changes the blending between the walking and running animation.
**Methods**
`idle()`: sets the model in an idle state
`walk()`: sets the model in a walking state
`jump()`: sets the model in a ascending state
`fall()`: sets the model in a falling state
`set_face()`: sets the model's face to a desired expression
 - `"default"`: displays the default blinking animation
 - `"happy"`: displays a happy face
 - `"dizzy"`: displays a spiraling eyes animation
 - `"sleepy"`: displays a sleepy face

	 Note: You can add new expressions by editing `gdbot_face.tscn`. It's a 2D scene that is picked up by a viewport node and displayed on Gdbot's face.
