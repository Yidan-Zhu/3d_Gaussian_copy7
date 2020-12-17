extends Line2D

###################
#    PARAMS
###################

# axis
var	x_end = Vector3(10,0,0)
var	y_end = Vector3(0,6,0)
var	z_end = Vector3(0,0,10)
var origin = Vector3(0,0,0)

onready var camera = get_node("/root/Spatial_SplitScreen/HBoxContainer/ViewportContainer_camera/Viewport_camera/Camera")

# axes scales
var x_scale = Vector3(2,0,0)
var x_scale_length = Vector3(0,0,0.5)
var number_on_x_one_side = floor((x_end.x - 0.2) / x_scale.x)
var z_scale = Vector3(0,0,2)
var z_scale_length = Vector3(0.5,0,0)
var number_on_z_one_side = floor((z_end.z - 0.2) / z_scale.z)

##################################

func _draw():
# repeat drawing the axes on Canvas, so will not be blocked by other meshes
	var origin_on_canvas = camera.unproject_position(origin)
		
	draw_line(origin_on_canvas, camera.unproject_position(y_end), ColorN("Green"),1.0,true)	
	draw_line(origin_on_canvas, camera.unproject_position(x_end), ColorN("Red"),1.0,true)
	draw_line(origin_on_canvas, camera.unproject_position(z_end), ColorN("Blue"),1.0,true)
	draw_line(origin_on_canvas, camera.unproject_position(-x_end), ColorN("Red"),1.0,true)
	draw_line(origin_on_canvas, camera.unproject_position(-z_end), ColorN("Blue"),1.0,true)
		
	draw_line(origin_on_canvas, camera.unproject_position(x_scale), ColorN("Red"),1.0,true)	
	draw_line(origin_on_canvas, camera.unproject_position(z_scale), ColorN("Blue"),1.0,true)	
	draw_line(origin_on_canvas, camera.unproject_position(-x_scale),ColorN("Red"),1.0,true)
	draw_line(origin_on_canvas, camera.unproject_position(-z_scale),ColorN("Blue"),1.0,true)		

	for i in range(0,number_on_x_one_side):
		draw_line(camera.unproject_position(x_scale*i),camera.unproject_position(x_scale*(i+1)),ColorN("Red"),1.0,true)
	for i in range(0,-number_on_x_one_side,-1):
		draw_line(camera.unproject_position(x_scale*i),camera.unproject_position(x_scale*(i-1)),ColorN("Red"),1.0,true)
	for i in range(0,number_on_z_one_side):
		draw_line(camera.unproject_position(z_scale*i),camera.unproject_position(z_scale*(i+1)),ColorN("Blue"),1.0,true)
	for i in range(0,-number_on_z_one_side,-1):
		draw_line(camera.unproject_position(z_scale*i),camera.unproject_position(z_scale*(i-1)),ColorN("Blue"),1.0,true)		

	for i in range(1,number_on_x_one_side+1):
		var scale_start = camera.unproject_position(x_scale*i)
		var scale_end = camera.unproject_position(x_scale*i + x_scale_length)
		draw_line(scale_start, scale_end, ColorN("Red"),1.0, true)
	for i in range(-1,-number_on_x_one_side-1,-1):
		var scale_start = camera.unproject_position(x_scale*i)
		var scale_end = camera.unproject_position(x_scale*i + x_scale_length)
		draw_line(scale_start, scale_end, ColorN("Red"),1.0, true)
	for i in range(1,number_on_z_one_side+1):
		var scale_start = camera.unproject_position(z_scale*i)
		var scale_end = camera.unproject_position(z_scale*i + z_scale_length)
		draw_line(scale_start, scale_end, ColorN("Blue"),1.0, true)
	for i in range(-1,-number_on_z_one_side-1,-1):
		var scale_start = camera.unproject_position(z_scale*i)
		var scale_end = camera.unproject_position(z_scale*i + z_scale_length)
		draw_line(scale_start, scale_end, ColorN("Blue"),1.0, true)

func _process(_delta):
	update()
