extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var hurt_shot_path: String = "parameters/HurtShot/request"

func hurt():
	animation_tree.set(hurt_shot_path, true)
