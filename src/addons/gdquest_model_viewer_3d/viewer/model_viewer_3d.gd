extends Node

const ModelSelector = preload("./ui/model_selector/model_selector.gd")

@onready var model_selector: ModelSelector = %ModelSelector
@onready var animation_selector: OptionButton = %AnimationSelector
@onready var turner: Node3D = %Turner
@onready var parameters: MarginContainer = %Parameters
@onready var model_holder: Node3D = %ModelHolder

var known_models: Array[ModelData] = []

var selected_model_idx := 0
var selected_animation_idx := 0
var selected_animation_name: String = ""
var animations: Dictionary[String, int] = { }

var current_model: Node3D = null
var current_animations := []
var current_range_values := []
var dropdown_list := []


func _ready() -> void:
	model_selector.selection_changed.connect(_on_model_selection)
	animation_selector.item_selected.connect(
		func(item_index: int) -> void:
			call_method(current_animations[item_index].value)
	)

	for model_data in known_models:
		model_data.scene = load(model_data.scene_path)
	model_selector.setup(known_models)
	model_selector.selection_changed.emit(selected_model_idx)

	if OS.has_feature("movie"):
		if "_animation_tree" in current_model:
			var animation_tree: AnimationTree = current_model._animation_tree
			for animation_name in animation_tree.get_animation_list():
				var animation_name_snake := animation_name.to_snake_case()
				animations[animation_name.to_snake_case()] = 0
				var animation := animation_tree.get_animation(animation_name)
				var track_idx := animation.add_track(Animation.TYPE_METHOD)
				animation.track_set_path(track_idx, animation_tree.get_path_to(self))
				animation.track_insert_key(track_idx, animation.length, { method = "animation_inc", args = [animation_name_snake] })

		model_selector.set_selection(selected_model_idx)

		await get_tree().process_frame
		animation_selector.selected = selected_animation_idx

		if selected_animation_name in ["attack", "power_off", "fall", "jump", "flip", "victory_sign", "wall_slide", "edge_grab", "hurt"]:
			await get_tree().create_timer(0.5).timeout
			animation_selector.item_selected.emit(selected_animation_idx)
		elif selected_animation_name in ["walk", "run", "move"]:
			animation_selector.item_selected.emit(selected_animation_idx)


func _on_model_selection(value: int) -> void:
	set_model(known_models[value])


func set_model(model_data: ModelData) -> void:
	# Check if a model is already displayed
	if current_model != null:
		# Purge Model Holder
		for child in model_holder.get_children():
			child.queue_free()
		await get_tree().process_frame

	# Set the new current model node
	current_model = model_data.scene.instantiate()

	# Set a model wrapper and put the model in it
	var base_scale := Vector3.ONE * model_data.scale_compensation
	var wrapper = Node3D.new()
	wrapper.position.y = model_data.y_offset
	wrapper.scale = base_scale * 0.8
	wrapper.add_child(current_model)
	model_holder.add_child(wrapper)

	# Set animations
	animation_selector.hide()
	current_animations = model_data.animations_list
	if current_animations.size() != 0:
		var method_names = current_animations.map(func(m: Dictionary) -> String: return m.name)
		animation_selector.setup(method_names)
		animation_selector.show()

	# Check if the parameters panel already show something, remove the children if so.
	if parameters.has_childrens():
		parameters.clear()

	# Ranges
	current_range_values = model_data.range_bind
	if current_range_values.size() != 0:
		for range_index in current_range_values.size():
			var slider_info: Dictionary = current_range_values[range_index]
			var slider: HSlider = parameters.add_slider(
				slider_info.name,
				slider_info.get("min_value", 0.0),
				slider_info.get("max_value", 1.0),
			)

			slider.value_changed.connect(
				func(value: float) -> void:
					set_variable(current_range_values[range_index].value, value)
			)

			var slider_value := current_model.get(current_range_values[range_index].value)
			if slider_value != null:
				slider.value = slider_value
	# Dropdown
	dropdown_list = []
	for option_setter_index in model_data.dropdown_bind.size():
		var setter := model_data.dropdown_bind[option_setter_index]
		var options := model_data._get_options(option_setter_index)
		var options_names := options.map(func(m: Dictionary) -> String: return m.name)
		dropdown_list.append(
			{
				"bind_variable": setter.bind_name,
				"options": options,
			},
		)
		var option_button: OptionButton = parameters.add_options(setter.list_name, options_names)
		option_button.item_selected.connect(
			func(dropdown_choice_index: int) -> void:
				var v_value = dropdown_list[option_setter_index].options[dropdown_choice_index].value
				if setter.mode == setter.MODE.SET:
					set_variable(setter.bind_name, v_value)
				elif setter.mode == setter.MODE.CALL:
					current_model.call(setter.bind_name, v_value)
		)

	if OS.has_feature("movie"):
		turner.position.y = model_data.camera_offset_y
		wrapper.scale = base_scale
	else:
		var t = create_tween().set_parallel(true)
		t.tween_property(turner, "position:y", model_data.camera_offset_y, 0.2)
		t.tween_property(wrapper, "scale", base_scale, 0.2)


func call_method(method_name: String) -> void:
	current_model.call(method_name)


func set_variable(variable_name: String, new_value: Variant) -> void:
	current_model.set(variable_name, new_value)


func animation_inc(anim_name: String) -> void:
	animations[anim_name] += 1

	if anim_name in ["fall", "jump", "power_off", "flip", "victory_sign", "wall_slide", "edge_grab", "hurt"] and animations[anim_name] == 1 and anim_name == selected_animation_name:
		await get_tree().create_timer(1.0).timeout
		animations.idle = 0
		current_model.idle()

	elif anim_name in ["idle", "head_movement", "walk", "run"] and animations[anim_name] == 1:
		get_tree().quit()
