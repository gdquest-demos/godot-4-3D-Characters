extends VBoxContainer

@onready var tag_list = %TagList
@onready var model_tag = %ModelTag
@onready var scroll_container = %ScrollContainer
@export var model_tag_scene : PackedScene

var selection := 0: set = set_selection
var model_list: Array[ModelData]

var _is_open = false : set = _set_is_open

signal selection_changed(value : int)

func setup(new_model_list : Array[ModelData]):
	model_list = new_model_list
	model_tag.tag_name = model_list[0].name
	model_tag.icon_texture = model_list[0].vignette
	for model_index in model_list.size():
		var model : ModelData = model_list[model_index]
		var tag = model_tag_scene.instantiate()
		tag.tag_name = model.name
		tag.icon_texture = model.vignette
		tag.connect("pressed", set_selection.bind(model_index))
		tag_list.add_child(tag)
		
	await get_tree().process_frame
	tag_list.position.y = 0.0
	scroll_container.setup()
	_set_is_open(false)
	
func set_selection(index : int):
	if selection == index  or selection < 0 or selection >= model_list.size(): 
		return
	selection = index
	_set_is_open(false)
	model_tag.tag_name = model_list[index].name
	model_tag.icon_texture = model_list[index].vignette
	emit_signal("selection_changed", index)


func _on_model_tag_pressed():
	_set_is_open(!_is_open)

func _set_is_open(value : bool):
	_is_open = value
	scroll_container.visible = _is_open
