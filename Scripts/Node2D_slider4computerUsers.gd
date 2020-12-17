extends Node2D

# slider position
var left_margin = 20
var top_margin = 20
var vertical_space = 20
var text_horizontal_space = -10

# slider update from on-screen changes
var count = 0

# slider update from itself
var mat = load("res://Shading/material_Gaussian.tres")


func _ready():
	$HSlider_mean_x.margin_left = left_margin
	$HSlider_mean_x.margin_top = top_margin
	$HSlider_mean_x.rect_size = Vector2(100,16)
	$HSlider_mean_x/Label_mean_x.margin_left = $HSlider_mean_x.margin_left + \
		$HSlider_mean_x.rect_size.x + text_horizontal_space
	$HSlider_mean_x.step = 0.01
	$HSlider_mean_x.min_value = -2
	$HSlider_mean_x.max_value = 2

	$HSlider_mean_z.margin_left = left_margin
	$HSlider_mean_z.margin_top = $HSlider_mean_x.margin_top + vertical_space
	$HSlider_mean_z.rect_size = Vector2(100,16)
	$HSlider_mean_z/Label_mean_z.margin_left = $HSlider_mean_z.margin_left + \
		$HSlider_mean_z.rect_size.x + text_horizontal_space
	$HSlider_mean_z.step = 0.01
	$HSlider_mean_z.min_value = -2
	$HSlider_mean_z.max_value = 2

	$HSlider_a.margin_left = left_margin
	$HSlider_a.margin_top = $HSlider_mean_z.margin_top + vertical_space
	$HSlider_a.rect_size = Vector2(100,16)
	$HSlider_a/Label_a.margin_left = $HSlider_a.margin_left + \
		$HSlider_a.rect_size.x + text_horizontal_space
	$HSlider_a.step = 0.01
	$HSlider_a.min_value = 1.0
	$HSlider_a.max_value = 1.5
			
	$HSlider_b.margin_left = left_margin
	$HSlider_b.margin_top = $HSlider_a.margin_top + vertical_space	
	$HSlider_b.rect_size = Vector2(100,16)
	$HSlider_b/Label_b.margin_left = $HSlider_b.margin_left + \
		$HSlider_b.rect_size.x + text_horizontal_space
	$HSlider_b.step = 0.01
	$HSlider_b.min_value = 1.0
	$HSlider_b.max_value = 1.5
		
	$HSlider_theta.margin_left = left_margin
	$HSlider_theta.margin_top = $HSlider_b.margin_top + vertical_space
	$HSlider_theta.rect_size = Vector2(100,16)
	$HSlider_theta/Label_theta.margin_left = $HSlider_theta.margin_left + \
		$HSlider_theta.rect_size.x + text_horizontal_space
	$HSlider_theta.step = 0.01
	$HSlider_theta.min_value = 0
	$HSlider_theta.max_value = PI
		
	$HSlider_cameraRot.margin_left = left_margin
	$HSlider_cameraRot.margin_top = $HSlider_theta.margin_top + vertical_space
	$HSlider_cameraRot.rect_size = Vector2(100,16)
	$HSlider_cameraRot/Label_cameraRot.margin_left = $HSlider_cameraRot.margin_left + \
		$HSlider_cameraRot.rect_size.x + text_horizontal_space
	$HSlider_cameraRot.step = 1	
	$HSlider_cameraRot.min_value = 0
	$HSlider_cameraRot.max_value = 360

func _process(_delta):
	
	if (count <= 10):
		$HSlider_mean_x.value = get_tree().get_root().find_node("Line2D_panel", true, false).mean_x
		$HSlider_mean_z.value = get_tree().get_root().find_node("Line2D_panel", true, false).mean_z
		$HSlider_a.value = get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[0]
		$HSlider_b.value = get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[1]
		$HSlider_theta.value = get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).contour_theta
		$HSlider_cameraRot.value = get_tree().get_root().find_node("Viewport_camera", true, false).get_node("Camera").camera_rotation
	
		$HSlider_mean_x/Label_mean_x.text = "Mean x: " + str($HSlider_mean_x.value)
		$HSlider_mean_z/Label_mean_z.text = "Mean z: " + str($HSlider_mean_z.value)
		$HSlider_a/Label_a.text = "Contour axis a: " + str($HSlider_a.value)
		$HSlider_b/Label_b.text = "Contour axis b: " + str($HSlider_b.value)
		$HSlider_theta/Label_theta.text = "Contour rot theta: " + str($HSlider_theta.value)
		$HSlider_cameraRot/Label_cameraRot.text = "Camera angle: " + str($HSlider_cameraRot.value)
		count += 1
		

func _on_HSlider_mean_x_value_changed(value):
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).mean_x.x = value * get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).x_scale
	$HSlider_mean_x/Label_mean_x.text = "Mean x: " + str($HSlider_mean_x.value)
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[0] = $HSlider_a.value
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[1] = $HSlider_b.value
	mat.set_shader_param("mean_x",value * get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).x_scale)

func _on_HSlider_a_value_changed(value):
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).drawing_type_flag = "slider_change_deviation"		
	
	$HSlider_a/Label_a.text = "Contour axis a: " + str($HSlider_a.value)


func _on_HSlider_mean_z_value_changed(value):
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).mean_z.z = value * get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).z_scale
	$HSlider_mean_z/Label_mean_z.text = "Mean z: " + str($HSlider_mean_z.value)
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[0] = $HSlider_a.value
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).list_parameters[1] = $HSlider_b.value
	mat.set_shader_param("mean_z",value * get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).z_scale)


func _on_HSlider_b_value_changed(value):
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).drawing_type_flag = "slider_change_deviation"		

	$HSlider_b/Label_b.text = "Contour axis b: " + str($HSlider_b.value)


func _on_HSlider_theta_value_changed(value):
	get_tree().get_root().find_node("Line2D_Gaussian_Contour", true, false).drawing_type_flag = "slider_change_deviation"		

	$HSlider_theta/Label_theta.text = "Contour rot theta: " + str($HSlider_theta.value)


func _on_HSlider_cameraRot_value_changed(value):
	$HSlider_cameraRot/Label_cameraRot.text = "Camera angle: " + str($HSlider_cameraRot.value)
	get_tree().get_root().find_node("Viewport_camera", true, false).get_node("Camera").camera_rotation = value
