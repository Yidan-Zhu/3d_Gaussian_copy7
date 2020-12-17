extends Line2D

#################
#    PARAMS
#################
# title
var screen_size
# var rect_color = Color(0.94,0.97,1,0.8)   # option 1, aliceblue
var rect_color = Color(0.96,0.96,0.86,0.8)  # option 2, beige
#var rect_color = Color(0.68,0.85,0.9,0.8)   # option 3, lightblue

var rect_width_title = 200
var rect_height_title = 35
var rect_y_title = 20
var rect_x_layout = 15
var rect_x_title

var node_title
var title_adjust_x = 30
var title_adjust_y = -3

# panel 2
var padding_top = 20
var rect_width_gesture = rect_width_title
var rect_height_gesture = 200
var rect_y_gesture = rect_y_title + rect_height_title + padding_top
var rect_x_gesture

var node_gesture
var gesture_adjust_x = 6
var gesture_adjust_y = 6

# panel 3
var rect_width_parameters = rect_width_gesture
var rect_height_parameters = 170
var rect_y_parameters = rect_y_gesture + rect_height_gesture + padding_top
var rect_x_parameters

var node_parameters
var opt_node
var parameter_title_adjust_x = 6
var parameter_title_adjust_y = 6
var parameter_adjust_x = 35
var parameter_adjust_each_line = 24

var text_variance_x = Label.new()
var text_variance_z = Label.new()
var text_rot_angle = Label.new()
var text_mean_x = Label.new()
var text_mean_z = Label.new()
var text_covariance = Label.new()
var variance_x
var variance_z
var mean_x = 0
var mean_z = 0
onready var camera_panel = get_node("/root/Spatial_SplitScreen/HBoxContainer/ViewportContainer_panel/Viewport_panel/Camera")
onready var camera =  get_node("/root/Spatial_SplitScreen/HBoxContainer/ViewportContainer_camera/Viewport_camera/Camera")

onready var gesture_para = get_tree().get_root().find_node("Line2D_Gaussian_Contour",true,false)
var Gaussian_covariance

# drag input
var rotation_delta = 100
var rot_error = 0.2
var origin = Vector3(0,0,0)
var position_start_1 
var position_end_1 
var position_start_2 
var position_end_2 

# draw variables
var draw_type_flag
var draw_10 = Vector2()
var draw_11 = Vector2()
var draw_20 = Vector2()
var draw_21 = Vector2()
var center
var radius
onready var timer = $Timer
var x_scale
var z_scale

# camera rotation
var rotation_direction
var angle_rotated = 0
signal rotation_status(angle, direction)
var camera_angle_convert_ratio = 240.0/120.0

# multi-inputs
var events = {}

###################################################

func _ready():
# get default parameters, create text labels
	x_scale = gesture_para.x_scale
	z_scale = gesture_para.z_scale

	add_child(text_variance_x)
	add_child(text_variance_z)
	add_child(text_rot_angle)
	add_child(text_mean_x)
	add_child(text_mean_z)
	add_child(text_covariance)


func _process(_delta):
# update parameters
	variance_x = stepify(gesture_para.std_deviation_x,0.01)
	variance_z = stepify(gesture_para.std_deviation_z,0.01)
	Gaussian_covariance = stepify(gesture_para.covariance_Gaussian,0.01)
	mean_x = stepify(gesture_para.mean_x.x/x_scale,0.01)  # the real mean
	mean_z = stepify(gesture_para.mean_z.z/z_scale,0.01)
	
	text_variance_x.text = "Variance X: " + str(variance_x)
	text_variance_z.text = "Variance Z: " + str(variance_z)	
	text_covariance.text = "Covariance: " + str(Gaussian_covariance)	
	text_mean_x.text = "Mean X: " + str(mean_x)
	text_mean_z.text = "Mean Z: " + str(mean_z)
	text_rot_angle.text = "Camera Rotation: " + str(camera.camera_rotation)

func _input(event):
# rotation gesture panel
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
			
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 2:
			if events[0].position.x > 0 and events[1].position.x > 0 and\
				events[0].position.x + events[0].relative.x > 0 and\
				events[1].position.x + events[1].relative.x > 0:
				position_start_1 = events[0].position
				draw_10 = position_start_1
				position_end_1 = events[0].position + events[0].relative
				draw_11 = position_end_1
				position_start_2 = events[1].position
				draw_20 = position_start_2
				position_end_2 = events[1].position + events[1].relative
				draw_21 = position_end_2
	
		# a rotation gesture
				#if abs(start_dist - end_dist) <= rotation_delta and abs(cos_angle2) <= 1 - rot_error:
				if true:
					draw_type_flag = "rotate"
					rotation_direction = "clockwise"
					update()
					
	
func _draw():
	screen_size = get_viewport_rect().size
	rect_x_title = screen_size.x - rect_width_title - rect_x_layout
	rect_x_gesture = rect_x_title
	rect_x_parameters = rect_x_gesture
	
	# draw the title rectangle
	draw_rect(Rect2(rect_x_title, rect_y_title, rect_width_title, rect_height_title),rect_color,true)

	if !get_node_or_null("label_title"):
		node_title = Label.new()
		node_title.name = "label_title"
		add_child(node_title)

	node_title.text = "Gesture to parameters"
	node_title.add_color_override("font_color", ColorN("Black"))
	node_title.set_position(Vector2(rect_x_title+title_adjust_x, rect_height_title+title_adjust_y))

	# draw the gesture rectangle 
	draw_rect(Rect2(rect_x_gesture, rect_y_gesture, rect_width_gesture, rect_height_gesture),rect_color,true)

	if !get_node_or_null("label_gesture"):
		node_gesture = Label.new()
		node_gesture.name = "label_gesture"
		add_child(node_gesture)	

	node_gesture.text = "Gesture region:"
	node_gesture.add_color_override("font_color", ColorN("Black"))
	node_gesture.set_position(Vector2(rect_x_gesture + gesture_adjust_x, rect_y_gesture + gesture_adjust_y))

	text_rot_angle.add_color_override("font_color", ColorN("Brown"))
	text_rot_angle.set_global_position(Vector2(rect_x_gesture + parameter_adjust_x,rect_y_gesture + parameter_adjust_each_line))

	# draw the parameter rectangle
	draw_rect(Rect2(rect_x_parameters, rect_y_parameters, rect_width_parameters, rect_height_parameters),rect_color,true)
	
	if !get_node_or_null("label_parameters"):
		node_parameters = Label.new()
		node_parameters.name = "label_parameters"
		add_child(node_parameters)		

	node_parameters.text = "Parameters of \n Multivariate Gaussian: "
	node_parameters.add_color_override("font_color", ColorN("Black"))	
	node_parameters.set_position(Vector2(rect_x_parameters + parameter_title_adjust_x, rect_y_parameters + parameter_title_adjust_y))

	
	text_variance_x.add_color_override("font_color", ColorN("Brown"))
	text_variance_x.set_global_position(Vector2(rect_x_parameters + parameter_adjust_x,rect_y_parameters + parameter_adjust_each_line *2))

	text_variance_z.add_color_override("font_color", ColorN("Brown"))
	text_variance_z.set_global_position(Vector2(rect_x_parameters + parameter_adjust_x,rect_y_parameters + parameter_adjust_each_line *3))

	text_mean_x.add_color_override("font_color", ColorN("Brown"))
	text_mean_x.set_global_position(Vector2(rect_x_parameters + parameter_adjust_x,rect_y_parameters + parameter_adjust_each_line *4))

	text_mean_z.add_color_override("font_color", ColorN("Brown"))
	text_mean_z.set_global_position(Vector2(rect_x_parameters + parameter_adjust_x,rect_y_parameters + parameter_adjust_each_line *5))

	text_covariance.add_color_override("font_color", ColorN("Brown"))
	text_covariance.set_global_position(Vector2(rect_x_parameters + parameter_adjust_x,rect_y_parameters + parameter_adjust_each_line *6))

	# draw rotation gesture
	if draw_type_flag == "rotate":

		center = find_center(position_start_1, position_start_2, position_end_1, position_end_2)
		radius = calculate_length(position_start_1 - position_start_2) / 2.0
		var angle1 = acos(calculate_angle(draw_10 - center, draw_11 - center))
		var draw_point

		var trace_number = 100
		var step = 180/(trace_number - 1)

		var angle_with_position_start_1 = acos(calculate_angle(draw_10, Vector2(1,0)))
		angle_rotated = 0

		for n in range(trace_number):
			if rotation_direction == "counter-clockwise":
				draw_point = Vector2(radius*cos(deg2rad(n*step)+angle_with_position_start_1), radius*sin(deg2rad(n*step)+angle_with_position_start_1))
			elif rotation_direction == "clockwise":
				draw_point = Vector2(radius*cos(-deg2rad(n*step)+angle_with_position_start_1), radius*sin(-deg2rad(n*step)+angle_with_position_start_1))	

			var angle_with_10 = acos(calculate_angle(draw_point, draw_10))
			var angle_with_11 = acos(calculate_angle(draw_point, draw_11))

			if angle_with_10 <= angle1 and angle_with_11 <= angle1:
				angle_rotated += step  # rotation angle in degree

		emit_signal("rotation_status", angle_rotated*camera_angle_convert_ratio, rotation_direction)


func calculate_angle(vec1, vec2):
	var cos_angle = vec1.dot(vec2)/(calculate_length(vec1)*calculate_length(vec2))
	return cos_angle

func calculate_length(vec):
	if typeof(vec) == TYPE_VECTOR2:
		vec = Vector3(vec.x, vec.y, 0)
	var length = sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z)
	return length


# find the intersection of two lines
func find_center(point1, point2, pointa, pointb):
	var number_of_search = 100
	var step = (point2.x-point1.x)/(number_of_search-1)
	var line_A_y
	var line_B_y 
	var lines_diff
	var lines_diff_pre
	var guess_root = point1.x
	var root = Vector2()
	for n in range(number_of_search):
		guess_root = guess_root + n * step
		line_A_y = point1.y + (point2.y - point1.y)/(point2.x - point1.x) * (guess_root - point1.x)
		line_B_y = pointa.y + (pointb.y - pointa.y)/(pointb.x - pointa.x) * (guess_root - pointa.x)
		lines_diff = abs(line_A_y - line_B_y)
		if n == 0: 
			lines_diff_pre = lines_diff
		elif lines_diff > lines_diff_pre:
			root.x = guess_root + (n-1)*step
			root.y = point1.y + (point2.y - point1.y)/(point2.x - point1.x) * (root.x - point1.x)
			root.y += pointa.y + (pointb.y - pointa.y)/(pointb.x - pointa.x) * (root.x - pointa.x)
			root.y = root.y/2.0
			break
		lines_diff_pre = lines_diff

	return root	
