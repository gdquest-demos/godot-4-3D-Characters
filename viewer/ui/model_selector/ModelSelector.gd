extends VBoxContainer

@export var model_tag_scene : PackedScene

var selection = 0
var model_list 

var _is_open = false : set = _set_is_open

signal selection_changed(value : int)


func setup(new_model_list : Array[ModelData]):
	model_list = new_model_list
	$ModelTag.tag_name = model_list[0].name
	$ModelTag.icon_texture = model_list[0].vignette
	for model_index in model_list.size():
		var model : ModelData = model_list[model_index]
		var tag = model_tag_scene.instantiate()
		tag.tag_name = model.name
		tag.icon_texture = model.vignette
		tag.connect("pressed", tag_pressed.bind(model_index))
		$ScrollContainer/VBoxContainer.add_child(tag)
	$ScrollContainer.setup()
	
	_set_is_open(false)
	
func tag_pressed(index : int):
	if selection == index: return
	selection = index
	_set_is_open(false)
	$ModelTag.tag_name = model_list[index].name
	$ModelTag.icon_texture = model_list[index].vignette
	emit_signal("selection_changed", index)

func _on_model_tag_pressed():
	_set_is_open(!_is_open)

func _set_is_open(value : bool):
	_is_open = value
	$ScrollContainer.visible = _is_open
