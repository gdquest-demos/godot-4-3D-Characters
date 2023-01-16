extends MarginContainer

# Used to bind values of the model script

@onready var _v_box = $VBoxContainer


signal slider_value_changed(value : float, index : int)

func has_childrens():
	return _v_box.get_child_count() > 0

func clear():
	for child in _v_box.get_children():
		child.queue_free()

func add_slider(tag_name : String, range_value_index):
	
	var slider : HSlider = HSlider.new()
	slider.connect("value_changed", _slider_changed.bind(range_value_index))

	var tag : Label = Label.new()
	tag.text = tag_name
	
	var tag_slider_box : VBoxContainer = VBoxContainer.new()
	
	tag_slider_box.add_child(tag)
	tag_slider_box.add_child(slider)
	
	_v_box.add_child(tag_slider_box)

func add_options(tag_name : String, options_list : Array):
	
	var options_button : OptionButton = OptionButton.new()
	for option in options_list:
		options_button.add_item(option)
		
	var tag : Label = Label.new()
	tag.text = tag_name
	
	var tag_option_box : VBoxContainer = VBoxContainer.new()
	
	tag_option_box.add_child(tag)
	tag_option_box.add_child(options_button)
	
	_v_box.add_child(tag_option_box)
	
	return options_button
	
func _slider_changed(value : float, index : int):
	emit_signal("slider_value_changed", index, remap(value, 0, 100, 0, 1))
