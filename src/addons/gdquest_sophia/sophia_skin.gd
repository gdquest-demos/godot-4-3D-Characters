extends Node3D

## Emitted when Gobot's feet hit the ground will running.
@warning_ignore("unused_signal")
signal stepped

## Use it to make the run animation lean left (-1.0), right (1.0) or straight (0.0).
@export_range(-1.0, 1.0, 0.01) var run_tilt = 0.0:
	set = set_run_tilt

## Determines whether blinking is enabled or disabled.
@export var is_blinking = true:
	set = set_is_blinking

@onready var _animation_tree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
@onready var _move_tilt_path: String = "parameters/Run/tilt/add_amount"
@onready var _blink_timer = %BlinkTimer
@onready var _closed_eyes_timer = %ClosedEyesTimer
@onready var _eye_mat = $sophia/rig/Skeleton3D/Sophia.get("surface_material_override/1")


func _ready() -> void:
	_blink_timer.timeout.connect(
		func() -> void:
			_eye_mat.set("uv1_offset", Vector3(0.0, 0.5, 0.0))
			_closed_eyes_timer.start(0.2)
	)

	_closed_eyes_timer.timeout.connect(
		func() -> void:
			_eye_mat.set("uv1_offset", Vector3.ZERO)
			_blink_timer.start(randf_range(1.0, 4.0))
	)


func set_is_blinking(new_is_blinking: bool) -> void:
	is_blinking = new_is_blinking
	if not is_node_ready():
		return

	if is_blinking:
		_blink_timer.start(0.2)
	else:
		_blink_timer.stop()
		_closed_eyes_timer.stop()


func set_run_tilt(value: float) -> void:
	run_tilt = clamp(value, -1.0, 1.0)
	if not is_node_ready():
		return
	_animation_tree.set(_move_tilt_path, run_tilt)


func idle() -> void:
	_state_machine.travel("Idle")


func run() -> void:
	_state_machine.travel("Run")


func fall() -> void:
	_state_machine.travel("Fall")


func jump() -> void:
	_state_machine.travel("Jump")


func edge_grab() -> void:
	_state_machine.travel("EdgeGrab")


func wall_slide() -> void:
	_state_machine.travel("WallSlide")
