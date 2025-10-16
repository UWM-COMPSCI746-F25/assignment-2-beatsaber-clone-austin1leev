extends Node3D

@onready var raycast = $RayCast3D
@onready var laser_mesh = $LaserMesh

var laser_color_name: String = "blue"
var laser_color: Color = Color.BLUE

func _ready():
	laser_mesh.visible = true
	raycast.enabled = true
	raycast.cast_to = Vector3(0, 0, -10)
	laser_mesh.scale = Vector3(0.02, 0.02, 10)

func _process(_delta):
	var active = Input.is_action_pressed("trigger_left")
	laser_mesh.visible = active
	raycast.enabled = active

	if active and raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.has_method("check_hit"):
			collider.check_hit(laser_color_name, laser_color)
