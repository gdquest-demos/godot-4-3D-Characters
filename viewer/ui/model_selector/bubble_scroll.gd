extends Control

@onready var v_box = $VBoxContainer

var scroll_index = 0
var displayed_items = 3

func setup():
	custom_minimum_size.y = _get_item_height() * displayed_items - (v_box.get("theme_override_constants/separation") / 2.0)

	for tag in v_box.get_children():
		tag.pivot_offset.y = tag.size.y / 2

func _gui_input(event):
	if !(event is InputEventMouseButton): return
	accept_event()
	var wheel_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
	var wheel_down = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
	
	scroll_index += float(wheel_up) - float(wheel_down)
	scroll_index = clamp(scroll_index, -v_box.get_child_count() + displayed_items, 0)
	
	var goal_position = scroll_index * _get_item_height()
	
	var t = create_tween()
	t.tween_property(v_box, "position:y", goal_position, 0.1)
	
func _get_item_height():
	var box_sep = v_box.get("theme_override_constants/separation")
	var tag_height = v_box.get_child(0).size.y
	return (tag_height + box_sep)
