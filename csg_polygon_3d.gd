extends CSGPolygon3D

var speed = 2.0          
var rotation_speed = 1.0 
var distance = 5.0       

var direction = 1        
var start_position = Vector3.ZERO

func _ready():
	start_position = global_transform.origin

func _process(delta):
	var offset = direction * speed * delta
	global_translate(Vector3(offset, 0, 0))
	
	if global_transform.origin.x > start_position.x + distance:
		direction = -1
	elif global_transform.origin.x < start_position.x - distance:
		direction = 1

	rotate_y(rotation_speed * delta)
