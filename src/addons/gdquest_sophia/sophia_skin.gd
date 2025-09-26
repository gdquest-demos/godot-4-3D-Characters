extends Node3D

@onready var animation_tree = %AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var move_tilt_path: String = "parameters/StateMachine/Move/tilt/add_amount"

var run_tilt = 0.0:
	set = _set_run_tilt

@export var blink = true:
	set = set_blink
@onready var blink_timer = %BlinkTimer
@onready var closed_eyes_timer = %ClosedEyesTimer
@onready var eye_mat = $sophia/rig/Skeleton3D/Sophia.get("surface_material_override/2")


func _ready() -> void:
	blink_timer.timeout.connect(
		func() -> void:
			eye_mat.set("uv1_offset", Vector3(0.0, 0.5, 0.0))
			closed_eyes_timer.start(0.2)
	)

	closed_eyes_timer.timeout.connect(
		func() -> void:
			eye_mat.set("uv1_offset", Vector3.ZERO)
			blink_timer.start(randf_range(1.0, 4.0))
	)


func set_blink(state: bool) -> void:
	if blink == state:
		return
	blink = state
	if blink:
		blink_timer.start(0.2)
	else:
		blink_timer.stop()
		closed_eyes_timer.stop()


func _set_run_tilt(value: float) -> void:
	run_tilt = clamp(value, -1.0, 1.0)
	animation_tree.set(move_tilt_path, run_tilt)


func idle() -> void:
	state_machine.travel("Idle")


func move() -> void:
	state_machine.travel("Move")


func fall() -> void:
	state_machine.travel("Fall")


func jump() -> void:
	state_machine.travel("Jump")


func edge_grab() -> void:
	state_machine.travel("EdgeGrab")


func wall_slide() -> void:
	state_machine.travel("WallSlide")
