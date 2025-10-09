extends Node3D

@export var movement_velocity: float = 3.0
@export var rotation_velocity: float = 90.0
@export var jump_force: float = 5.0
@export var gravity: float = -9.8
@export var ground_height: float = 0.0  # Y position of the "ground"

var vertical_velocity: float = 0.0
var is_jumping: bool = false

func _process(delta):
	# --- Horizontal Movement ---
	if Input.is_action_pressed("Forward"):
		global_position += global_transform.basis.z * movement_velocity * delta
	elif Input.is_action_pressed("Backward"):
		global_position -= global_transform.basis.z * movement_velocity * delta

	if Input.is_action_pressed("Left"):
		global_rotation_degrees.y += rotation_velocity * delta
	elif Input.is_action_pressed("Right"):
		global_rotation_degrees.y -= rotation_velocity * delta

	# --- Jump logic ---
	if Input.is_action_just_pressed("Jump") and not is_jumping:
		is_jumping = true
		vertical_velocity = jump_force

	if is_jumping:
		vertical_velocity += gravity * delta
		global_position.y += vertical_velocity * delta

		# Stop the jump when we hit the ground
		if global_position.y <= ground_height:
			global_position.y = ground_height
			vertical_velocity = 0.0
			is_jumping = false
