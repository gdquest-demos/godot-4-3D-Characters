@icon("./gdquest_model_viewer_3d.svg")
class_name GDQuestModelViewer3D
extends Node

const _ModelViewer3d = preload("./viewer/model_viewer_3d.gd")
const _MODEL_VIEWER_3D_SCENE = preload("./viewer/model_viewer_3d.tscn")

signal children_ready

var _data_models_map := {}
var _scene: _ModelViewer3d
var _children_are_ready := false

@export var known_models : Array[ModelData]

func _ready() -> void:
	_scene = _MODEL_VIEWER_3D_SCENE.instantiate() as _ModelViewer3d
	_scene.known_models = known_models
	add_child(_scene)
	
	for index in known_models.size():
		var model := known_models[index]
		var model_name := model.name.to_lower().replace(" ", "_")
		_data_models_map[model_name] = index
	
	# allow the sie menu to get its size
	await get_tree().physics_frame
	await get_tree().physics_frame
	_children_are_ready = true
	children_ready.emit()
	
	set_model_from_arguments()
	set_model_from_browser_hash()


func set_model_by_name(model_name: String) -> void:
	if not (model_name in _data_models_map):
		return
	if not _children_are_ready:
		await children_ready
	_scene.model_selector.selection = _data_models_map[model_name]


func set_model_from_arguments() -> void:
	var arguments := {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value := argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	if 'model' in arguments:
		set_model_by_name(arguments['model'])


func set_model_from_browser_hash() -> void:
	if not OS.has_feature('web'):
		return
	var hash_bits = (JavaScriptBridge.eval("window.location.hash") as String).lstrip('#').split("&")
	var arguments := {}
	for hash in hash_bits:
		if hash.find('=') > -1:
			var key_value := hash.split("=")
			arguments[key_value[0]] = key_value[1]
	if 'model' in arguments:
		set_model_by_name(arguments['model'])
			
