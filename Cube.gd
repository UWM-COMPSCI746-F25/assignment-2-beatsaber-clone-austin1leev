extends RigidBody3D

@export var cube_color: Color = Color.RED
@onready var mesh_instance = $MeshInstance3D

func _ready():
	var mat = StandardMaterial3D.new()
	mat.albedo_color = cube_color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.material_override = mat
