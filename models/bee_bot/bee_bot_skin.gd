extends Node3D

# Set loop on some animation
@export var _force_loop : PackedStringArray

func _ready():
	for animation_name in _force_loop:
		var anim : Animation = $bee_bot/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR
