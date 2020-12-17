extends Camera

##################
#    PARAMS
##################

# target
#export var camera_rotation = 245
export var camera_rotation = 45
var rot_matrix = Transform2D()

func _ready():
	var signal_node = get_tree().get_root().find_node("Line2D_panel", true, false)
	signal_node.connect("rotation_status", self, "_on_Node2D_rotation_status")
		
	# set the initial location of the camera
	rot_matrix.x.x = cos(deg2rad(camera_rotation))
	rot_matrix.x.y = - sin(deg2rad(camera_rotation))
	rot_matrix.y.x = sin(deg2rad(camera_rotation))
	rot_matrix.y.y = cos(deg2rad(camera_rotation))
	
	rotation_degrees = Vector3(-30, 90, 0)   # camera rotation
	
	var coord_ref = Vector2(0,-10)
	var initial_coord = rot_matrix*coord_ref
	translation = Vector3(initial_coord.x, 6, initial_coord.y)   # camera position
	
	look_at(Vector3(0,0,0), Vector3(0,1,0))   # camera facing


func _process(delta):		
	rot_matrix.x.x = cos(deg2rad(camera_rotation))
	rot_matrix.x.y = - sin(deg2rad(camera_rotation))
	rot_matrix.y.x = sin(deg2rad(camera_rotation))
	rot_matrix.y.y = cos(deg2rad(camera_rotation))
	
	rotation_degrees = Vector3(-30, 90, 0)
	
	var coord_ref = Vector2(0,-10)
	var initial_coord = rot_matrix*coord_ref
	translation = Vector3(initial_coord.x, 6, initial_coord.y)
	
	look_at(Vector3(0,0,0), Vector3(0,1,0))


func _on_Node2D_rotation_status(angle, direction):
#	var new_camera_location = Vector2(translation.x, translation.z)
#
##	elif direction == "clockwise":
#	if direction == "clockwise":
#		# write the rotation matrix
#		rot_matrix.x.x = cos(deg2rad(angle))
#		rot_matrix.x.y = - sin(deg2rad(angle))
#		rot_matrix.y.x = sin(deg2rad(angle))
#		rot_matrix.y.y = cos(deg2rad(angle))
#		# rotate the camera x, z by the matrix
#		new_camera_location = rot_matrix * new_camera_location
#		# recover the camera's location in 3D space
#		translation.x = new_camera_location.x
#		translation.z = new_camera_location.y
#		look_at(Vector3(0,0,0), Vector3(0,1,0))
			
	camera_rotation += angle
	camera_rotation = fposmod(camera_rotation,360)

