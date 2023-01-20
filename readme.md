<h1 align="center">
<img src="./character_icon.png"/>
<br/>
3D Characters Repository</h1>

This repository contains our open-source 3D models, pre-configured and compatible with Godot game engine version 4. The models have been tested and are ready to be used out of the box.

# Installation
1. Download or clone this repository.
2. Drag and drop the desired folder(s) from the `models` directory into your project.
3. After Godot imports the character, you can now use it in your project
4. To use the model, you need to instantiate the `model_name_skin.tscn` scene. This is the default scene where the model is set up and where you can call specific methods.

# Models
## GDbot

**Properties**

`_walk_run_blend_position`: This property represents the blending between the walking and running animations of the model. It can be set to different values (e.g. 0.0 to 1.0) to adjust the balance between the two animations, resulting in the model appearing to walk or run depending on the value.

**Methods**

`idle()`: This method sets the model in an idle state, in which the model will be in a neutral position, not performing any action.

`walk()`: This method sets the model in a walking state, in which the model will animate as if it is walking or moving forward.

`jump()`: This method sets the model in a ascending state, in which the model will animate as if it is jumping or leaping upwards.

`fall()`: This method sets the model in a falling state, in which the model will animate as if it is falling or dropping downwards.

`set_face()`: This method sets the model's face to a desired expression. The method accepts different string values, such as "default", "happy", "dizzy", "sleepy". Depending on the value passed to the method, the model's face will display different animations, such as the default blinking animation, a happy face, a spiraling eyes animation or a sleepy face.

Note: You can add new expressions by editing `gdbot_face.tscn`. It's a 2D scene that is picked up by a viewport node and displayed on Gdbot's face.

## Sophia

**Properties**

`_walk_run_blend_position`: This property represents the blending between the walking and running animations of the model. It can be set to different values (e.g. 0.0 to 1.0) to adjust the balance between the two animations, resulting in the model appearing to walk or run depending on the value.

`_current_eyes`: This property represents the current texture of Sophia's eyes. It can be set to different string values such as "default", "happy", "surprised", "frowning", "disgust" to change the texture of Sophia's eyes. This is done by offsetting the UV position of the material applied to the eyes, which results in a different texture being displayed on the model's eyes.

**Methods**

`idle()`: This method sets the model in an idle state, in which the model will be in a neutral position, not performing any action.

`walk()`: This method sets the model in a walking state, in which the model will animate as if it is walking or moving forward.

`jump()`: This method sets the model in a ascending state, in which the model will animate as if it is jumping or leaping upwards.

`fall()`: This method sets the model in a falling state, in which the model will animate as if it is falling or dropping downwards.

`wall_slide()`: This method sets the model in a wall sliding state, in which the model will animate as if it is sliding down a wall.

`edge_grab()`: This method sets the model in a edge grabbing state, in which the model will animate as if it is grabbing onto the edge of a platform or surface.

## Bee bot

**Methods**

`idle()`: This method sets the model in an idle state, in which the model will be in a neutral position, not performing any action.

`attack()`: This method sets the model in an attacking state, in which the model will animate as if it is attacking or engaging in combat.

`power_off()`: This method sets the model in a power off state, in which the model will animate as if it is shutting down or turning off.


## Beetle bot

**Methods**

`idle()`: This method sets the model in an idle state, in which the model will be in a neutral position, not performing any action.

`walk()`: This method sets the model in a walking state, in which the model will animate as if it is walking or moving forward.

`attack()`: This method sets the model in an attacking state, in which the model will animate as if it is attacking or engaging in combat.

`power_off()`: This method sets the model in a power off state, in which the model will animate as if it is shutting down or turning off.

