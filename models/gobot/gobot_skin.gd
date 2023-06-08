extends Node3D

signal foot_step

@export var gobot_model: MeshInstance3D
@export var blink = true : set = set_blink
@export var left_eye_mat_override: String
@export var right_eye_mat_override: String
@export var open_eye: CompressedTexture2D
@export var close_eye: CompressedTexture2D

var move_speed = 0.0 : set = set_move_speed

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get(
		"parameters/StateMachine/playback"
)
@onready var move_blend_path: String = "parameters/StateMachine/Move/blend_position"
@onready var flip_shot_path: String = "parameters/FlipShot/request"
@onready var hurt_shot_path: String = "parameters/HurtShot/request"

@onready var blink_timer = %BlinkTimer
@onready var closed_eyes_timer = %ClosedEyesTimer

@onready var left_eye_mat: StandardMaterial3D = gobot_model.get(left_eye_mat_override)
@onready var right_eye_mat: StandardMaterial3D = gobot_model.get(right_eye_mat_override)


func _ready():
	blink_timer.connect(
			"timeout",
			func():
				left_eye_mat.albedo_texture = close_eye
				right_eye_mat.albedo_texture = close_eye
				closed_eyes_timer.start(0.2)
	)

	closed_eyes_timer.connect(
			"timeout",
			func():
				left_eye_mat.albedo_texture = open_eye
				right_eye_mat.albedo_texture = open_eye
				blink_timer.start(randf_range(1.0, 8.0))
	)


func set_blink(state: bool):
	if blink == state:
		return
	blink = state
	if blink:
		blink_timer.start(0.2)
	else:
		blink_timer.stop()
		closed_eyes_timer.stop()


func set_move_speed(value: float):
	move_speed = clamp(value, 0.0, 1.0)
	animation_tree.set(move_blend_path, move_speed)


func idle():
	state_machine.travel("Idle")


func move():
	state_machine.travel("Move")


func fall():
	state_machine.travel("Fall")


func jump():
	state_machine.travel("Jump")


func edge_grab():
	state_machine.travel("EdgeGrab")


func wall_slide():
	state_machine.travel("WallSlide")


func flip():
	animation_tree.set(flip_shot_path, true)


func victory_sign():
	state_machine.travel("VictorySign")


func hurt():
	animation_tree.set(hurt_shot_path, true)
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
