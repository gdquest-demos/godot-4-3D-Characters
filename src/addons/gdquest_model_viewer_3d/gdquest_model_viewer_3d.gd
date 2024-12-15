@icon("./gdquest_model_viewer_3d.svg")
class_name GDQuestModelViewer3D
extends Node

const _ModelViewer3d = preload("./viewer/model_viewer_3d.gd")
const _MODEL_VIEWER_3D_SCENE = preload("./viewer/model_viewer_3d.tscn")

@export var known_models : Array[ModelData]

func _ready() -> void:
	var scene := _MODEL_VIEWER_3D_SCENE.instantiate() as _ModelViewer3d
	scene.known_models = known_models
	add_child(scene)
