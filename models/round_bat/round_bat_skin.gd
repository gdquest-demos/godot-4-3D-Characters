extends Node3D

## Bat skin

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _hurt_shot_path: String = "parameters/HurtShot/request"

## Play a OneShot hurt animation.
## This animation will be played in paralel with Idle state.
func hurt():
	_animation_tree.set(_hurt_shot_path, true)
