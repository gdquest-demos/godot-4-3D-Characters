extends Control

@onready var tag_list = %TagList

var displayed_items = 3

var scroll_index = 0 : set = set_scroll_index
var scroll_position = 0.0 : set = set_scroll_position

signal value_changed(value : int)

func set_scroll_index(value : int):
	if value == scroll_index: return
	scroll_index = clamp(value, -tag_list.get_child_count() + displayed_items, 0)
	scroll_position = scroll_index * _get_item_height()
	value_changed.emit(-scroll_index)

func set_scroll_position(value : float):
	scroll_position = value
	var t = create_tween()
	t.tween_property(tag_list, "position:y", scroll_position, 0.1)

func setup():
	custom_minimum_size.y = _get_item_height() * displayed_items - (tag_list.get("theme_override_constants/separation") / 2.0)
	
	for tag in tag_list.get_children():
		tag.pivot_offset.y = tag.size.y / 2
	
func _gui_input(event):
	if !(event is InputEventMouseButton): return
	if !event.is_pressed(): return
	
	accept_event()
	
	var wheel_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
	var wheel_down = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
	
	scroll_index += float(wheel_up) - float(wheel_down)
	
func _get_item_height():
	var box_sep = tag_list.get("theme_override_constants/separation")
	var tag_height = tag_list.get_child(0).size.y
	return (tag_height + box_sep)
