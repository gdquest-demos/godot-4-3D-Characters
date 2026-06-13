extends Node3D

## Emitted when Gobot's feet hit the ground will running.
@warning_ignore("unused_signal")
signal stepped

## Represents the blending between the walking and running animations.
## It can be set to different values (e.g. 0.0 to 1.0) to adjust the balance between
## the two animations, resulting in the model appearing to walk or run depending on the value.
@export_range(0.0, 1.0, 0.01) var walk_run_blending = 0.0:
	set = set_walk_run_blending

## Determines whether blinking is enabled or disabled.
@export var is_blinking := true:
	set = set_blinking

## Gobot's MeshInstance3D model.
@export var gobot_model: MeshInstance3D = null

@export var left_eye_mat_override := ""
@export var right_eye_mat_override := ""
@export var opened_eye: CompressedTexture2D = null
@export var closed_eye: CompressedTexture2D = null

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position: String = "parameters/StateMachine/Move/blend_position"

@onready var _flip_shot_path := "parameters/FlipShot/request"
@onready var _hurt_shot_path := "parameters/HurtShot/request"

@onready var _blink_timer = %BlinkTimer
@onready var _closed_eyes_timer = %ClosedEyesTimer

@onready var _left_eye_mat: StandardMaterial3D = gobot_model.get(left_eye_mat_override)
@onready var _right_eye_mat: StandardMaterial3D = gobot_model.get(right_eye_mat_override)


func _ready() -> void:
	_blink_timer.timeout.connect(
		func() -> void:
			_left_eye_mat.albedo_texture = closed_eye
			_right_eye_mat.albedo_texture = closed_eye
			_closed_eyes_timer.start(_closed_eyes_timer.wait_time)
	)

	_closed_eyes_timer.timeout.connect(
		func() -> void:
			_left_eye_mat.albedo_texture = opened_eye
			_right_eye_mat.albedo_texture = opened_eye
			_blink_timer.start(randf_range(1.0, 8.0))
	)


func set_blinking(new_is_blinking: bool) -> void:
	is_blinking = new_is_blinking
	if not is_node_ready():
		return

	if is_blinking:
		_blink_timer.start(0.2)
	else:
		_blink_timer.stop()
		_closed_eyes_timer.stop()


func set_walk_run_blending(value: float) -> void:
	walk_run_blending = value
	if not is_node_ready():
		return
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)


## Sets the model to a neutral, action-free state.
func idle() -> void:
	_state_machine.travel("Idle")


## Sets the model to a running animation or forward movement.
func move() -> void:
	_state_machine.travel("Move")


## Sets the model to an upward-leaping animation, simulating a jump.
func jump() -> void:
	_state_machine.travel("Jump")


## Sets the model to a downward animation, imitating a fall.
func fall() -> void:
	_state_machine.travel("Fall")


## Sets the model to an edge-grabbing animation.
func edge_grab() -> void:
	_state_machine.travel("EdgeGrab")


## Sets the model to a wall-sliding animation.
func wall_slide() -> void:
	_state_machine.travel("WallSlide")


## Plays a one-shot front-flip animation.
## This animation does not play in parallel with other states.
func flip() -> void:
	_animation_tree.set(_flip_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


## Makes a victory sign.
func victory_sign() -> void:
	_state_machine.travel("VictorySign")


## Plays a one-shot hurt animation.
## This animation plays in parallel with other states.
func hurt() -> void:
	_animation_tree.set(_hurt_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
