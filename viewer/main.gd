extends Node

@export var known_models : Array[ModelData]
@onready var model_selector = $UI/ModelSelector
@onready var animation_selector = $UI/AnimationSelector
@onready var turner = $World/Turner
@onready var parameters = $UI/Parameters

var current_model : Node3D = null
var current_animations = []
var current_range_values = []
var dropdown_list = []

func _ready():
	for model_data in known_models:
		model_data.scene = load(model_data.scene_path)
	model_selector.setup(known_models)
	set_model(known_models[0])
	animation_selector.connect("item_selected", func(item_index : int):
		call_method(current_animations[item_index].value)
		)
	model_selector.connect("selection_changed", _on_model_selection)
	
func _on_model_selection(value):
	set_model(known_models[value])
	
func set_model(model_data : ModelData):
	# Set model
	var next_model = model_data.scene.instantiate()
	next_model.position.y = model_data.y_offset
	next_model.hide()
	$World.add_child(next_model)
	
	if current_model != null:
		var t = create_tween()
		t.tween_property(current_model, "scale", current_model.scale * 0.8, 0.1)
		await t.finished
		current_model.queue_free()
	
	var base_scale = Vector3.ONE * model_data.scale_compensation
	next_model.scale = base_scale * 0.8
	next_model.show()
	var t = create_tween().set_parallel(true)
	t.tween_property($World/Turner, "position:y", model_data.camera_offset_y, 0.2)
	t.tween_property(next_model, "scale", base_scale, 0.2)
	current_model = next_model
	
	# Set animations
	animation_selector.hide()
	current_animations = model_data.animations_list
	if current_animations.size() != 0:
		var method_names = current_animations.map(func(m): return m.name)
		animation_selector.setup(method_names)
		animation_selector.show()
		call_method(current_animations[0].value)
	
	# Check if the parameters panel already show something, remove the children if so.
	if parameters.has_childrens():
		parameters.clear()
		await get_tree().node_removed
		
	# Ranges
	current_range_values = model_data.range_bind
	if current_range_values.size() != 0:
		for range_index in current_range_values.size():
			var slider : HSlider = parameters.add_slider(current_range_values[range_index].name)
			slider.connect("value_changed", func(value : float):
				set_variable(current_range_values[range_index].value, remap(value, 0, 100, 0, 1))
				)
	# Dropdown
	dropdown_list = []
	for option_setter_index in model_data.dropdown_bind.size():
		var setter = model_data.dropdown_bind[option_setter_index]
		var options = model_data._get_options(option_setter_index)
		var options_names = options.map(func(m): return m.name)
		dropdown_list.append({
			"bind_variable": setter.bind_name,
			"options": options
		})
		var option_button : OptionButton = parameters.add_options(setter.list_name, options_names)
		option_button.connect("item_selected", func(dropdown_choice_index):
			var v_value = dropdown_list[option_setter_index].options[dropdown_choice_index].value
			if setter.mode == setter.MODE.SET:
				set_variable(setter.bind_name, v_value)
			elif setter.mode == setter.MODE.CALL:
				current_model.call(setter.bind_name, v_value)
			)
	
func call_method(method_name : String):
	current_model.call(method_name)
	
func set_variable(variable_name, new_value):
	current_model.set(variable_name, new_value)
