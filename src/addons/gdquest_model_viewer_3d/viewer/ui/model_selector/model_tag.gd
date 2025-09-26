extends PanelContainer

signal pressed

@export var tag_name: String:
	set = _set_label
@export var icon_texture: Texture:
	set = _set_icon


func _set_label(value: String) -> void:
	var label = $MarginContainer/Item/Label
	label.text = value


func _set_icon(value: Texture) -> void:
	var icon = $MarginContainer/Item/Icon
	icon.texture = value


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressed.emit()
