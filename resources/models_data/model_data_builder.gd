extends Resource
class_name ModelData

@export_group("Model Info")

@export var name : String = ""
@export_file var scene_path : String = ""
var scene : PackedScene
@export var vignette : Texture
@export var y_offset = 0.0
@export var scale_compensation = 1.0
@export var camera_offset_y = 0.5

@export_group("Parameters")
@export var name_methods : PackedStringArray : get = _get_methods
@export var range_values : PackedStringArray : get = _get_ranges

func _get_methods():
	return _array_string_to_dict(name_methods)
	
func _get_ranges():
	return _array_string_to_dict(range_values)

func _array_string_to_dict(source_array : PackedStringArray):
	var result = []
	for text in source_array:
		var s = text.split(":")
		result.append({"name": s[0], "value": s[1]})
	return result
