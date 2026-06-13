@icon("./gdquest_model_viewer_3d.svg")
class_name GDQuestModelViewer3D
extends Node

const ModelViewer3D = preload("./viewer/model_viewer_3d.gd")
const MODEL_VIEWER_3D_SCENE = preload("./viewer/model_viewer_3d.tscn")

signal children_ready

@export var known_models: Array[ModelData] = []

var _data_models_map := { }
var _scene: ModelViewer3D = MODEL_VIEWER_3D_SCENE.instantiate()
var _children_are_ready := false
var _time := 0.0


func _ready() -> void:
	for index in known_models.size():
		var model := known_models[index]
		var model_name := model.name.to_lower().replace(" ", "_")
		_data_models_map[model_name] = index

	_scene.known_models = known_models
	if OS.has_feature("movie"):
		var meta_file: String = get_meta("movie_file")
		var info := meta_file.get_file().get_basename().split("-")

		_scene.selected_model_idx = get_selected_model_idx(info[0])
		_scene.selected_animation_idx = get_selected_animation_idx(_scene.selected_model_idx, info[1])
		_scene.selected_animation_name = info[1]

		if _scene.selected_model_idx < 0 or _scene.selected_animation_idx < 0:
			_scene.selected_model_idx = 0
			_scene.selected_animation_idx = 0
	add_child(_scene)

	# allow the side menu to get its size
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
	var arguments := { }
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
	var arguments := { }
	for hash in hash_bits:
		if hash.find('=') > -1:
			var key_value := hash.split("=")
			arguments[key_value[0]] = key_value[1]
	if 'model' in arguments:
		set_model_by_name(arguments['model'])


func get_selected_model_idx(model_name: String) -> int:
	return _data_models_map[model_name]


func get_selected_animation_idx(selected_model_idx: int, animation_name: String) -> int:
	var animations_list: Array[Dictionary] = known_models[selected_model_idx].animations_list
	var animation_names: Array = animations_list.map(func(d: Dictionary) -> String: return d.value)
	return animation_names.find(animation_name)
