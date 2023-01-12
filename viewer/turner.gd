extends Node3D

@export var low_angle : float = -5.0
@export var high_angle : float = -50.0

var _is_grabbing = false

func _ready():
	_set_bg_ratio()
	get_viewport().connect("size_changed", _set_bg_ratio)
	
	
func _set_bg_ratio():
	var camera = $Camera3D
	var background_plane : MeshInstance3D = $BackgroundPlane
	var frustum_height = tan(camera.fov * PI / 180 * 0.5) * (camera.position.z - background_plane.position.z) * 2
	var viewport_size = get_viewport().size
	var ratio = float(viewport_size.x) / float(viewport_size.y)

	background_plane.mesh.size.x = frustum_height * ratio
	background_plane.mesh.size.y = frustum_height
	background_plane.material_override.set_shader_parameter("ratio", Vector2(ratio, 1.0))

func _unhandled_input(event):
	if (event is InputEventMouseButton): 
		_is_grabbing = event.pressed
	# Check mouse motion
	if !(event is InputEventMouseMotion): return
	if !_is_grabbing: return
	
	rotation.y += -event.relative.x * 0.005
	rotation.x += -event.relative.y * 0.005
	rotation.x = clamp(rotation.x, deg_to_rad(high_angle), deg_to_rad(low_angle))
