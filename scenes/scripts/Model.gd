extends Object
class_name Model


const DOMAIN_X_LIMITS = [0.0, 1.0]
const DOMAIN_Y_LIMITS = [0.0, 1.0]


var a: float = 0
var b: float = 0

var effective_x_limits: Array[Array] = []


## Sets parameters of the model. Only models with 2 parameters are supported to
## allow for better visualization. Returns an array that contains the baked line
func set_parameters(a_progress: float, b_progress: float, resolution: int, size: float) -> Array[Array]:
	var limits = get_limits()
	a = limits[0] + (limits[1] - limits[0]) * a_progress
	b = limits[2] + (limits[3] - limits[2]) * b_progress
	
	# Bake line
	var baked_line : Array[Array] = []
	var step_size = (DOMAIN_X_LIMITS[1] - DOMAIN_X_LIMITS[0]) / float(resolution)
	
	effective_x_limits = []
	var is_visible = false
	for i in range(resolution):
		var x = DOMAIN_X_LIMITS[0] + step_size * i
		var y = predict(x)
		
		if y >= DOMAIN_Y_LIMITS[0] and y <= DOMAIN_Y_LIMITS[1]:
			if not is_visible:
				baked_line.append([])
				
				effective_x_limits.append([])
				effective_x_limits[-1].append(x)
				
				is_visible = true
			baked_line[-1].append(size * Vector2(x, -y))
		elif is_visible:
			effective_x_limits[-1].append(x - step_size)
			is_visible = false
	
	if is_visible:
		effective_x_limits[-1].append(DOMAIN_X_LIMITS[0] + step_size * (resolution - 1))
	return baked_line


## Generates the specified amount of points to be fitted by this model
func generate_points(amount: int) -> Array[Vector2]:
	var og_a = a
	var og_b = b
	
	var point_limits = get_point_limits()
	set_parameters(randf_range(point_limits[0], point_limits[1]), randf_range(point_limits[2], point_limits[3]), 50, 500)
	
	var point_positions: Array[Vector2] = []
	for i in range(amount):
		var x = randf_range(effective_x_limits[0][0], effective_x_limits[0][1])
		var point_pos = get_final_point_position(Vector2(x, predict(x)))
		point_pos[0] = clamp(point_pos[0], DOMAIN_X_LIMITS[0], DOMAIN_X_LIMITS[1])
		point_pos[1] = clamp(point_pos[1], DOMAIN_Y_LIMITS[0], DOMAIN_Y_LIMITS[1])
		point_positions.append(point_pos)
	
	var limits = get_limits()
	set_parameters((og_a - limits[0]) / (limits[1] - limits[0]),
					(og_b - limits[2]) / (limits[3] - limits[2]), 50, 500)
	
	return point_positions


## Modifies the point position from the base generated one
func get_final_point_position(line_pos: Vector2) -> Vector2:
	return Vector2(0, 0)


## Returns an array which contains, in this order, the minimum and maximum
## values for a and the minimum and maximum values for b
func get_limits() -> Array[float]:
	return [0.0, 0.0, 0.0, 0.0]


## Gets limits for a and b. Used only for point generation
func get_point_limits() -> Array[float]:
	return [0.0, 1.0, 0.0, 1.0]


## Returns the current equation of the model
func get_equation() -> String:
	return ""


## Predicts y for the given x
func predict(x: float) -> float:
	return 0.0


## Returns the shader material for model visualization
func get_shader() -> int:
	return 0
