extends XROrigin3D

# VARIABLES
var spawn_timer: float = 0.0
var spawn_interval: float = 0.8  # Spawn every 1 second
var cube_speed: float = 4.2      # meters per second
var collision_enabled: bool = true
@onready var sound_player = $"../AudioStreamPlayer3D"  # Reference player with the AudioStream

func _ready():
	print("Laser swords ready! Left: Blue, Right: Red")
	set_lasers_active(true)

	# Assign the reference player from the scene

func _process(delta):
	# Check left controller hits
	check_controller_hits($left, "blue")
	# Check right controller hits  
	check_controller_hits($right, "red")
	
	# Cube spawning and movement
	spawn_cubes(delta)
	move_cubes(delta)
	

func check_controller_hits(controller: XRController3D, sword_color: String):
	var raycast = controller.get_node("SwordRaycast") as RayCast3D
	if raycast and raycast.is_colliding():
		var hit_object = raycast.get_collider()
		if hit_object and hit_object.is_in_group("cubes"):
			handle_cube_hit(hit_object, sword_color)

func handle_cube_hit(cube, sword_color: String):
	var cube_node = cube.get_parent()
	var cube_color = cube_node.get_meta("cube_color")

	if cube_color == sword_color:
		sound_player.play()

		cube_node.queue_free()
		print("SUCCESS: ", cube_color, " cube destroyed!")
	else:
		print("WRONG COLOR: ", cube_color, " cube hit with ", sword_color, " sword")
		# Optional: flash red or visual feedback

func set_lasers_active(active: bool):
	var left_visual = $left.get_node("LaserVisual")
	var left_raycast = $left.get_node("SwordRaycast")
	var right_visual = $right.get_node("LaserVisual")
	var right_raycast = $right.get_node("SwordRaycast")
	
	left_visual.visible = active
	left_raycast.enabled = active
	right_visual.visible = active
	right_raycast.enabled = active


# SPAWN CUBES OVER TIME
func spawn_cubes(delta: float):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		create_flying_cube()

# CREATE FLYING CUBES
func create_flying_cube():
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.mesh.size = Vector3(0.3, 0.3, 0.3)

	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	collision.shape.size = Vector3(0.3, 0.3, 0.3)

	var static_body = StaticBody3D.new()
	static_body.add_child(collision)
	cube.add_child(static_body)

	# Random position
	cube.position = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(1.0, 2.0),
		-10.0
	)

	# Random color
	var cube_color = "blue" if randf() > 0.5 else "red"
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.BLUE if cube_color == "blue" else Color.RED
	cube.material_override = material

	cube.set_meta("cube_color", cube_color)
	static_body.add_to_group("cubes")

	add_child(cube)
	print("Spawned ", cube_color, " cube")

# MOVE ALL CUBES TOWARD PLAYER
func move_cubes(delta: float):
	for child in get_children():
		if child is MeshInstance3D and child != $left.get_node("LaserVisual") and child != $right.get_node("LaserVisual"):
			child.position.z += cube_speed * delta
			if child.position.z > 2.0:
				child.queue_free()
				print("Cube missed!")

func _on_right_button_pressed(name: String) -> void: 
	if name == "ax_button": 
		$right.visible = !$right.visible 
		collision_enabled = !collision_enabled
		
func _on_left_button_pressed(name: String) -> void: 
	if name == "ax_button": 
		$left.visible = !$left.visible
		collision_enabled = !collision_enabled
