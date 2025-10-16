extends XRController3D

@export var laser_color: String = "red" # set "blue" on left hand manually in editor
@export var laser_length: float = 1.0
@export var laser_thickness: float = 0.02
@export var toggle_button: StringName = "xr_a" # change to "xr_x" on left hand

var laser_mesh: MeshInstance3D
var laser_area: Area3D
var laser_visible: bool = true
var last_pressed: bool = false

func _ready():
	# --- Create laser mesh ---
	laser_mesh = $LaserMesh
	var cylinder = CylinderMesh.new()
	cylinder.top_radius = laser_thickness
	cylinder.bottom_radius = laser_thickness
	cylinder.height = laser_length
	laser_mesh.mesh = cylinder

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED if laser_color == "red" else Color.BLUE
	mat.emission_enabled = true
	mat.emission = mat.albedo_color * 3.0
	laser_mesh.material_override = mat

	laser_mesh.rotation_degrees.x = 90
	laser_mesh.position = Vector3(0, 0, -laser_length / 2)

	# --- Setup collider ---
	laser_area = $LaserArea
	var shape = $LaserArea/CollisionShape3D
	var box = BoxShape3D.new()
	box.size = Vector3(laser_thickness * 3, laser_thickness * 3, laser_length)
	shape.shape = box
	laser_area.position = Vector3(0, 0, -laser_length / 2)

	laser_area.body_entered.connect(_on_laser_body_entered)


func _process(_delta):
	var pressed = is_button_pressed(toggle_button)

	if pressed and not last_pressed:
		laser_visible = !laser_visible
		update_laser_state()

	last_pressed = pressed


func update_laser_state():
	laser_mesh.visible = laser_visible
	laser_area.monitoring = laser_visible


func _on_laser_body_entered(body):
	if not laser_visible:
		return

	if body.is_in_group("Cubes"):
		if not body.has_meta("cube_color"):
			return
		var cube_color = body.get("cube_color")
		if (laser_color == "red" and cube_color == "red") or (laser_color == "blue" and cube_color == "blue"):
			body.queue_free()
