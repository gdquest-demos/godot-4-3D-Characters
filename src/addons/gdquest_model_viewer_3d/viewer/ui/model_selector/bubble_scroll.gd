extends Control

@onready var tag_list = %TagList

var displayed_items = 3

signal value_changed(value: int)


func setup() -> void:
	custom_minimum_size.y = _get_item_height() * displayed_items - (tag_list.get("theme_override_constants/separation") / 2.0)

	for tag in tag_list.get_children():
		tag.pivot_offset.y = tag.size.y / 2


func _get_item_height() -> float:
	var box_sep: int = tag_list.get("theme_override_constants/separation")
	var tag_height: float = tag_list.get_child(0).size.y
	return (tag_height + box_sep)
