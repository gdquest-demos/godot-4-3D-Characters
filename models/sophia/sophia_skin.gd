extends Node3D

var walk_run_blending = 0.0 : set = _set_walk_run_blending

# Set loop on some animation
@export var _force_loop : PackedStringArray
@onready var _animation_tree = $AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _second_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/StateMachine/playback")
@onready var _walk_run_blend_position : String = "parameters/StateMachine/StateMachine/Walk/blend_position"

func _ready():
	for animation_name in _force_loop:
		var anim : Animation = $mini_sophia/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR
		
func _set_walk_run_blending(value : float):
	walk_run_blending = value
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)

func idle():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Idle")
	
func walk():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Walk")
	
func jump():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Jump")
	
func fall():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Fall")
	
func wall_slide():
	_main_state_machine.travel("WallSlide")
	
func edge_grab():
	_main_state_machine.travel("EdgeGrab")
