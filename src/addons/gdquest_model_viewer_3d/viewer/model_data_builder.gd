extends Resource

class_name ModelData

const OptionSetterListData = preload("./option_list_data_builder.gd")

@export_group("Model Info")

@export var name: String = ""
@export_file var scene_path: String = ""
var scene: PackedScene
@export var vignette: Texture
@export var y_offset := 0.0
@export var scale_compensation := 1.0
@export var camera_offset_y := 0.5

@export_group("Parameters")
# Animation list:
# Name: Displayed Value: called
@export var animations_list: PackedStringArray:
	get = _get_animations
@export var range_bind: PackedStringArray:
	get = _get_ranges
@export var dropdown_bind: Array[OptionSetterListData]


func _get_options(options_index: int) -> Array[Dictionary]:
	return _array_string_to_dict(dropdown_bind[options_index].options_values)


func _get_animations() -> Array[Dictionary]:
	return _array_string_to_dict(animations_list)


func _get_ranges() -> Array[Dictionary]:
	return _array_string_to_dict(range_bind)


func _array_string_to_dict(source_array: PackedStringArray) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for text in source_array:
		var s = text.split(":")
		result.append({ "name": s[0], "value": s[1] })
	return result
