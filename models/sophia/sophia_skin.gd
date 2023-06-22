extends Node3D

## Represents the blending between the walking and running animations. It can be set to different values (e.g. 0.0 to 1.0) to adjust the balance between the two animations, resulting in the model appearing to walk or run depending on the value.
var walk_run_blending = 0.0 : set = _set_walk_run_blending

# Set loop on some animation
@export var _force_loop : PackedStringArray
@onready var _animation_tree = $AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _second_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/StateMachine/playback")
@onready var _walk_run_blend_position : String = "parameters/StateMachine/StateMachine/Walk/blend_position"

@onready var _model_mesh : MeshInstance3D = $mini_sophia/Armature/Skeleton3D/sophia_mesh
@onready var _eye_left_mat : BaseMaterial3D = _model_mesh.get("surface_material_override/1")
@onready var _eye_right_mat : BaseMaterial3D = _model_mesh.get("surface_material_override/2")
@onready var _mouth_mat : BaseMaterial3D = _model_mesh.get("surface_material_override/3")


var _blinking = null : set = _set_blinking
@onready var _blinking_timer : Timer = $BlinkTimer
@onready var _closed_eyes_timer : Timer = $ClosedTimer
var _eyes_atlas_order = ["default", "closed", "surprised", "worried", "angry"]
var _eyes_atlas = {}
var _current_eyes = "default" : set = _set_current_eyes
var _mouth_atlas_order = ["default", "happy", "surprised", "frowning", "disgust"]
var _mouth_atlas = {}

func _ready():
	for animation_name in _force_loop:
		var anim : Animation = $mini_sophia/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR
	# Setup eyes
	_eyes_atlas = _get_atlas(_eyes_atlas_order)
	_mouth_atlas = _get_atlas(_mouth_atlas_order)
	_blinking_timer.connect("timeout", _on_blink_timer_timeout)
	_set_blinking(true)
	
func _get_atlas(base_atlas):
	var atlas = {}
	var step = 1.0 / base_atlas.size()
	for atlas_index in base_atlas.size():
		atlas[base_atlas[atlas_index]] = step * atlas_index
	return atlas
	
func _set_walk_run_blending(value : float):
	walk_run_blending = value
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)

## Sets the model to a neutral, action-free state.
func idle():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Idle")

## Sets the model to a walking or running animation or forward movement.
func walk():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Walk")
	
## Sets the model to an upward-leaping animation, simulating a jump.
func jump():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Jump")
	
## Sets the model to a downward animation, imitating a fall.
func fall():
	_main_state_machine.travel("StateMachine")
	_second_state_machine.travel("Fall")

## Sets the model to an edge-grabbing animation.
func edge_grab():
	_main_state_machine.travel("EdgeGrab")

## Sets the model to a wall-sliding animation.
func wall_slide():
	_main_state_machine.travel("WallSlide")

func _set_blinking(value : bool):
	_blinking = value
	if _blinking:
		_blinking_timer.start()
	else:
		_blinking_timer.stop()
		_set_eyes(_current_eyes)

func _on_blink_timer_timeout():
	# Close eyes
	_set_eyes("closed")
	_closed_eyes_timer.start(randf_range(0.1, 0.25))
	await _closed_eyes_timer.timeout
	# Return to current eyes
	_set_eyes(_current_eyes)
	if randf_range(0.0, 1.0) > 0.8:
		_blinking_timer.wait_time = randf_range(0.1, 0.15)
	else:
		_blinking_timer.wait_time = randf_range(1.0, 4.0)
	_blinking_timer.start()

func _set_current_eyes(value : String):
	_current_eyes = value
	_set_eyes(value)
	_set_blinking(value == "default")
		
func _set_eyes(eyes_name : String):
	var texture_offset = _eyes_atlas[eyes_name]
	_eye_left_mat.set("uv1_offset", Vector3(0.0, texture_offset, 0.0))
	_eye_right_mat.set("uv1_offset", Vector3(0.0, texture_offset, 0.0))
	
func _set_mouth(mouth_name : String):
	var texture_offset = _mouth_atlas[mouth_name]
	_mouth_mat.set("uv1_offset", Vector3(0.0, texture_offset, 0.0))
