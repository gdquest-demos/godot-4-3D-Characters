extends Node

@export var known_models : Array[ModelData]
@onready var model_selector = $UI/ModelSelector
@onready var animation_selector = $UI/AnimationSelector
@onready var turner = $World/Turner
@onready var parameters = $UI/Parameters

var current_model : Node3D = null
var current_methods = []
var current_range_values = []

func _ready():
	for model_data in known_models:
		model_data.scene = load(model_data.scene_path)
	model_selector.setup(known_models)
	set_model(known_models[0])
	
func _on_model_selector_selection_changed(value):
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
	
	# Set animations settings
	animation_selector.hide()
	current_methods = model_data.name_methods
	if current_methods.size() != 0:
		var method_names = current_methods.map(func(m): return m.name)
		animation_selector.setup(method_names)
		animation_selector.show()
		use_method(0)
		
	# Set animations settings
	current_range_values = model_data.range_values
	if parameters.has_childrens():
		parameters.clear()
		await get_tree().node_removed
	# Slides
	if current_range_values.size() != 0:
		for range_index in current_range_values.size():
			parameters.add_slider(current_range_values[range_index].name, range_index)
	
	
func use_method(index):
	var method = current_methods[index].value
	current_model.call(method)
	
func slider_update(index, value):
	var slider = current_range_values[index].value
	current_model.set(slider, value)
