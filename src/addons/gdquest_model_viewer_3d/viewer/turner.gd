extends Node3D

@export var low_angle := -5.0
@export var high_angle := -50.0
@export var min_zoom := 1.5
@export var max_zoom := 5.0

var _tween: Tween = null
var _is_grabbing := false

var turn_around_duration := 4.0

@onready var _camera: Camera3D = $Camera3D


func _ready() -> void:
	_set_bg_ratio()
	get_viewport().size_changed.connect(_set_bg_ratio)


func _set_bg_ratio() -> void:
	var background_plane: MeshInstance3D = $BackgroundPlane
	var frustum_height = tan(_camera.fov * PI / 180 * 0.5) * (_camera.position.z - background_plane.position.z) * 2
	var viewport_size = get_viewport().size
	var ratio = float(viewport_size.x) / float(viewport_size.y)

	background_plane.mesh.size.x = frustum_height * ratio
	background_plane.mesh.size.y = frustum_height
	background_plane.material_override.set_shader_parameter("ratio", Vector2(ratio, 1.0))


func _unhandled_input(event: InputEvent) -> void:
	var wheel_direction = 0.0
	if (event is InputEventMouseButton):
		if event.button_index == MOUSE_BUTTON_LEFT:
			_is_grabbing = event.pressed
			if _tween != null:
				_tween.kill()

		if event.pressed:
			var wheel_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
			var wheel_down = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
			wheel_direction = float(wheel_down) - float(wheel_up)

		if (_tween == null or _tween != null and not _tween.is_valid()) and event.button_index == MOUSE_BUTTON_RIGHT:
			_tween = create_tween().set_loops()
			_tween.tween_property(self, "rotation:y", rotation.y + TAU, turn_around_duration).from(rotation.y)

	if wheel_direction != 0:
		_camera.position.z += wheel_direction * 0.25
		_camera.position.z = clamp(_camera.position.z, min_zoom, max_zoom)
		_set_bg_ratio()

	# Check mouse motion
	if (event is InputEventMouseMotion):
		if !_is_grabbing:
			return
		rotation.y += -event.relative.x * 0.005
		rotation.x += -event.relative.y * 0.005
		rotation.x = clamp(rotation.x, deg_to_rad(high_angle), deg_to_rad(low_angle))
