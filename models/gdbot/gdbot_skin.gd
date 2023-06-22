extends Node3D

## Represents the blending between the walking and running animations. It can be set to different values (e.g. 0.0 to 1.0) to adjust the balance between the two animations, resulting in the model appearing to walk or run depending on the value.
var walk_run_blending = 0.0 : set = _set_walk_run_blending

@onready var _animation_tree = $AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position : String = "parameters/StateMachine/Walk/blend_position"
@onready var _face = $SubViewport/GDbotFace

func _set_walk_run_blending(value : float):
	walk_run_blending = value
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)

## Sets the model to a neutral, action-free state.
func idle():
	_main_state_machine.travel("Idle")

## Sets the model to a walking or running animation or forward movement.
func walk():
	_main_state_machine.travel("Walk")

## Sets the model to an upward-leaping animation, simulating a jump.
func jump():
	_main_state_machine.travel("Jump")

## Sets the model to a downward animation, imitating a fall.
func fall():
	_main_state_machine.travel("Fall")

## Changes the model's facial expression based on the provided input string values. Possible expressions include "default" (for default blinking), "happy" (for a joyful expression), "dizzy" (for spiraling eyes), and "sleepy" (for a drowsy countenance).
##[br][b]Note:[/b] To add new expressions, you can edit gdbot_face.tscn, which is a 2D scene utilized by a viewport node to display on Gdbot's face.
func set_face(face_name):
	_face._set_face(face_name)
