extends XROrigin3D

@export var test_cube_scene: PackedScene
@export var cube_distance: float = 2.0

func _ready():
	print("VR XROrigin Ready")
	create_test_cube()

func create_test_cube():
	if not test_cube_scene:
		# fallback: create cube manually
		var cube = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.3,0.3,0.3)
		cube.mesh = box

		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color.BLUE
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		cube.material_override = mat

		var static_body = StaticBody3D.new()
		var collision = CollisionShape3D.new()
		collision.shape = BoxShape3D.new()
		collision.shape.size = Vector3(0.3,0.3,0.3)
		static_body.add_child(collision)
		static_body.add_to_group("cubes")

		cube.add_child(static_body)
		cube.position = Vector3(0, 1.5, -cube_distance)
		add_child(cube)
		print("Test cube created at 2m in front")
