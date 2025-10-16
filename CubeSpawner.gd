extends Node3D

@export var cube_scene: PackedScene
@export var spawn_distance: float = 10.0
@export var min_spawn_time: float = 0.5
@export var max_spawn_time: float = 2.0
@export var cube_speed: float = 5.0
@export var laser_colors: Array = [Color.RED, Color.BLUE]

func _ready():	spawn_cube()

func spawn_cube():
	if not cube_scene:
		return

	var cube = cube_scene.instantiate()
	var x = randf_range(-1.5, 1.5)
	var y = randf_range(0.5, 2.0)
	cube.position = Vector3(x, y, -spawn_distance)
	cube.cube_color = laser_colors[randi() % laser_colors.size()]
	add_child(cube)

	if cube is RigidBody3D:
		cube.linear_velocity = Vector3(0, 0, cube_speed)

	# Schedule next spawn using Godot 4 'await'
	var next_time = randf_range(min_spawn_time, max_spawn_time)
	await get_tree().create_timer(next_time).timeout
	spawn_cube()
