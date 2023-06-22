extends Node3D

## Emitted when Gobot's feet hit the ground will running.
signal foot_step
## Gobot's MeshInstance3D model.
@export var gobot_model: MeshInstance3D
## Determines whether blinking is enabled or disabled.
@export var blink = true : set = _set_blink
@export var _left_eye_mat_override: String
@export var _right_eye_mat_override: String
@export var _open_eye: CompressedTexture2D
@export var _close_eye: CompressedTexture2D

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get(
		"parameters/StateMachine/playback"
)

@onready var _flip_shot_path: String = "parameters/FlipShot/request"
@onready var _hurt_shot_path: String = "parameters/HurtShot/request"

@onready var _blink_timer = %BlinkTimer
@onready var _closed_eyes_timer = %ClosedEyesTimer

@onready var _left_eye_mat: StandardMaterial3D = gobot_model.get(_left_eye_mat_override)
@onready var _right_eye_mat: StandardMaterial3D = gobot_model.get(_right_eye_mat_override)


func _ready():
	_blink_timer.connect(
			"timeout",
			func():
				_left_eye_mat.albedo_texture = _close_eye
				_right_eye_mat.albedo_texture = _close_eye
				_closed_eyes_timer.start(0.2)
	)

	_closed_eyes_timer.connect(
			"timeout",
			func():
				_left_eye_mat.albedo_texture = _open_eye
				_right_eye_mat.albedo_texture = _open_eye
				_blink_timer.start(randf_range(1.0, 8.0))
	)


func _set_blink(state: bool):
	if blink == state:
		return
	blink = state
	if blink:
		_blink_timer.start(0.2)
	else:
		_blink_timer.stop()
		_closed_eyes_timer.stop()

## Sets the model to a neutral, action-free state.
func idle():
	_state_machine.travel("Idle")
	
## Sets the model to a running animation or forward movement.
func run():
	_state_machine.travel("Run")

## Sets the model to an upward-leaping animation, simulating a jump.
func jump():
	_state_machine.travel("Jump")

## Sets the model to a downward animation, imitating a fall.
func fall():
	_state_machine.travel("Fall")

## Sets the model to an edge-grabbing animation.
func edge_grab():
	_state_machine.travel("EdgeGrab")

## Sets the model to a wall-sliding animation.
func wall_slide():
	_state_machine.travel("WallSlide")

## Plays a one-shot front-flip animation.
## This animation does not play in parallel with other states.
func flip():
	_animation_tree.set(_flip_shot_path, true)

## Makes a victory sign.
func victory_sign():
	_state_machine.travel("VictorySign")

## Plays a one-shot hurt animation.
## This animation plays in parallel with other states.
func hurt():
	_animation_tree.set(_hurt_shot_path, true)
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
