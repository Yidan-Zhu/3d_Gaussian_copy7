extends MeshInstance

####################
#    PARAMS
####################
# mesh
var tmpMesh = Mesh.new()
var vertices = PoolVector3Array()
var mat = SpatialMaterial.new()
var color = Color(1,0,0,0.5)  # option 1: xxx
var st = SurfaceTool.new()

# vertices
onready var script_parameter_axes = get_node("../..")
var x_coord_1_origin
var x_coord_1
var x_coord_2
var z_coord_origin
var z_coord
var number_of_vertices_in_row = 81

# formula parameters
onready var gesture_para = get_node("../Line2D_Gaussian_Contour")
var mean_x
var mean_z
var variance_x 
var variance_z 
var covariance 

# adjust
export var Gaussian_scale_up = 40
var x_scale
var z_scale

##################################

func _process(_delta):
	x_coord_1_origin = -script_parameter_axes.x_end.x+2
	x_coord_1 = x_coord_1_origin
	z_coord_origin = -script_parameter_axes.z_end.z+2
	z_coord = z_coord_origin

	covariance = gesture_para.covariance_Gaussian

	x_scale = script_parameter_axes.x_scale.x
	z_scale = script_parameter_axes.z_scale.z
	mean_x = gesture_para.mean_x.x/x_scale   # the real mean
	mean_z = gesture_para.mean_z.z/z_scale
	variance_x = gesture_para.std_deviation_x # the real variance
	variance_z = gesture_para.std_deviation_z
	
	st = SurfaceTool.new()
	tmpMesh = Mesh.new()	
	
	# vertex array prepare
	vertices = PoolVector3Array()

	var step_x = 2.0*abs(x_coord_1) / (number_of_vertices_in_row - 1)
	var step_z = 2.0*abs(z_coord) / (number_of_vertices_in_row - 1)
	var value_y_1
	var value_y_2

	for n in range(number_of_vertices_in_row-2):
		x_coord_1 = x_coord_1_origin + n*step_x
		x_coord_2 = x_coord_1 + step_x
		for m in range(number_of_vertices_in_row-1):
			z_coord = z_coord_origin + m*step_z
			value_y_1 = Gaussian_scale_up*calculate_Gaussian_probability(1.0*x_coord_1/x_scale, 1.0*z_coord/z_scale)  # the real coordinates
			value_y_2 = Gaussian_scale_up*calculate_Gaussian_probability(1.0*x_coord_2/x_scale, 1.0*z_coord/z_scale)
			vertices.push_back(Vector3(x_coord_1, value_y_1, z_coord))
			vertices.push_back(Vector3(x_coord_2, value_y_2, z_coord))

	# draw mesh
	st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	# set material
	#mat.params_cull_mode = SpatialMaterial.CULL_DISABLED
	#mat.flags_unshaded = true
	#mat.vertex_color_use_as_albedo = true
	mat = load("res://Shading/material_Gaussian.tres")
	st.set_material(mat)

	# add vertices
	for v in vertices.size():
		if vertices[v][1] < 0.1:
			#st.add_color(color - Color(0.5,0,0,0.3))
			st.add_vertex(vertices[v])	
		elif vertices[v][1] < 0.3 and vertices[v][1] >= 0.1:
			#st.add_color(color)
			st.add_vertex(vertices[v])			
		elif vertices[v][1] < 0.6 and vertices[v][1] >= 0.3:
			#st.add_color(color+Color(0,0.5,0,0))
			st.add_vertex(vertices[v])
		elif vertices[v][1] < 0.9 and vertices[v][1] >= 0.6:
			#st.add_color(color+Color(0,1,0,0))
			st.add_vertex(vertices[v])
		elif vertices[v][1] < 1.2 and vertices[v][1] >= 0.9:
			#st.add_color(color+Color(0,1,0.5,0))
			st.add_vertex(vertices[v])
		else:
			#st.add_color(color+Color(0,1,1,0))
			st.add_vertex(vertices[v])	
	
	#st.generate_normals()			

	st.commit(tmpMesh)
	mesh = tmpMesh
	


# a function calculating probability density of any point (x,z)
func calculate_Gaussian_probability(x, z):
	var coefficient = 1.0/(2*PI*variance_x*variance_z*sqrt(1-covariance*covariance))
	var power_index_coefficient = -1.0/(2*(1-covariance*covariance))
	var power_index_main = pow(x-mean_x,2.0)/pow(variance_x,2.0) - \
						   2.0*covariance*(x-mean_x)*(z-mean_z)/(variance_x*variance_z) + \
						   pow(z-mean_z,2.0)/pow(variance_z,2.0)
	var probability_density = coefficient*exp(power_index_coefficient*power_index_main)
	return probability_density
