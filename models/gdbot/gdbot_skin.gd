extends Node3D

var walk_run_blending = 0.0 : set = _set_walk_run_blending

# Set loop on some animation
@export var _force_loop : PackedStringArray
@onready var _animation_tree = $AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position : String = "parameters/StateMachine/Walk/blend_position"
@onready var face = $SubViewport/GDbotFace

func _ready():
	for animation_name in _force_loop:
		var anim : Animation = $gdbot/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR
		
func _set_walk_run_blending(value : float):
	walk_run_blending = value
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)
	
func idle():
	_main_state_machine.travel("Idle")
	
func walk():
	_main_state_machine.travel("Walk")

func jump():
	_main_state_machine.travel("Jump")
	
func fall():
	_main_state_machine.travel("Fall")

func set_face(face_name):
	face._set_face(face_name)
