extends Node3D

var walk_run_amount = 0.0 : set = _set_walk_run_amount

# Set loop on some animation
@export var _force_loop : PackedStringArray

func _ready():
	for animation_name in _force_loop:
		var anim : Animation = $mini_sophia/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR
		
func _set_walk_run_amount(value : float):
	walk_run_amount = value
