extends Model


const STD = 0.2
const NORMAL_DISTRIBUTION_MULTIPLIER = 0.2


var rng = RandomNumberGenerator.new()


## Generates the specified amount of points to be fitted by this model
func generate_points(amount: int) -> Array[Vector2]:
	var og_a = a
	var og_b = b
	
	set_parameters(randf(), randf(), 50, 500)
	
	var point_positions: Array[Vector2] = []
	for i in range(amount):
		var x = randf_range(effective_x_limits[0][0], effective_x_limits[0][1])
		point_positions.append(Vector2(x, a * x + b + rng.randfn(0.0, STD) * NORMAL_DISTRIBUTION_MULTIPLIER))
	
	var limits = get_limits()
	set_parameters((og_a - limits[0]) / (limits[1] - limits[0]),
					(og_b - limits[2]) / (limits[3] - limits[2]), 50, 500)
	
	return point_positions


## Returns an array which contains, in this order, the minimum and maximum
## values for a and the minimum and maximum values for b
func get_limits() -> Array[float]:
	return [-1.0, 1.0, 0.25, 0.75]


## Returns the current equation of the model
func get_equation() -> String:
	return "Y = %.2fX + %.2f" % [a, b]


## Predicts y for the given x
func predict(x: float) -> float:
	return a * x + b


## Returns the shader material for model visualization
func get_shader() -> Shader:
	return preload("res://resources/shaders/LinearRegression.gdshader")
