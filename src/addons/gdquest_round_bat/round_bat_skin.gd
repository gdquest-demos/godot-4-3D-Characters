extends Node3D

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _hurt_shot_path: String = "parameters/HurtShot/request"


## Sets the model to a neutral, action-free state.
func idle() -> void:
	_animation_tree.set(_hurt_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


## Play a OneShot hurt animation.
## This animation is played in paralel with other states.
func hurt() -> void:
	_animation_tree.set(_hurt_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
