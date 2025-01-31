extends Model


## Returns an array which contains, in this order, the minimum and maximum
## values for a and the minimum and maximum values for b
func get_limits() -> Array[float]:
	return [-1.0, 1.0, 0.25, 0.75]


## Returns the current equation of the model
func get_equation() -> String:
	return "Y = %.2fX + %.2f" % [a, b / CONSTANT_MULTIPLIER]


## Predicts y for the given x
func predict(x: float) -> float:
	return a * x + b * CONSTANT_MULTIPLIER


## Returns the shader material for model visualization
func get_shader() -> Shader:
	return preload("res://resources/shaders/LinearRegression.gdshader")
