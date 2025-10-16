extends XRController3D

@export var laser_color: Color = Color.RED
@export var laser_length: float = 1.0

@onready var laser_mesh = $LaserMesh
@onready var laser_area = $LaserArea

func _ready():
	# PlaneMesh laser
	var mesh = PlaneMesh.new()
	mesh.size = Vector2(0.02, laser_length)
laser_mesh.mesh = mesh
	laser_mesh.position = Vector3(0, 0, -laser_length / 2)
	laser_mesh.rotation_degrees = Vector3(-90, 0, 0)

	var mat = StandardMaterial3D.new()
	mat.albedo_color = laser_color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	laser_mesh.material_override = mat

	# Collision off initially
	laser_area.monitoring = false
	laser_mesh.visible = false

func _process(_delta):
	var button_pressed = false
	if name.to_lower().find("right") != -1:
		button_pressed = Input.is_action_just_pressed("xr_right_primary")
	elif name.to_lower().find("left") != -1:
		button_pressed = Input.is_action_just_pressed("xr_left_primary")

	if button_pressed:
		laser_mesh.visible = !laser_mesh.visible
		laser_area.monitoring = !laser_area.monitoring

func _on_laser_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
