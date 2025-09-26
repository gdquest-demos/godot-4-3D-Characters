extends MarginContainer

@onready var _v_box = $VBoxContainer


func has_childrens() -> bool:
	return _v_box.get_child_count() > 0


func clear() -> void:
	for child in _v_box.get_children():
		child.queue_free()


func add_slider(tag_name: String) -> HSlider:
	var slider: HSlider = HSlider.new()

	var tag: Label = Label.new()
	tag.text = tag_name

	var tag_slider_box: VBoxContainer = VBoxContainer.new()

	tag_slider_box.add_child(tag)
	tag_slider_box.add_child(slider)

	_v_box.add_child(tag_slider_box)

	return slider


func add_options(tag_name: String, options_list: Array) -> OptionButton:
	var options_button: OptionButton = OptionButton.new()
	for option in options_list:
		options_button.add_item(option)

	var tag: Label = Label.new()
	tag.text = tag_name

	var tag_option_box: VBoxContainer = VBoxContainer.new()

	tag_option_box.add_child(tag)
	tag_option_box.add_child(options_button)

	_v_box.add_child(tag_option_box)

	return options_button
