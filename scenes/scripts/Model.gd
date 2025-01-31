extends Object
class_name Model


const CONSTANT_MULTIPLIER = 500


var a: float = 0
var b: float = 0


## Sets parameters of the model. Only models with 2 parameters are supported to
## allow for better visualization
func set_parameters(a_progress: float, b_progress: float) -> void:
	var limits = get_limits()
	a = limits[0] + (limits[1] - limits[0]) * a_progress
	b = limits[2] + (limits[3] - limits[2]) * b_progress


## Returns an array which contains, in this order, the minimum and maximum
## values for a and the minimum and maximum values for b
func get_limits() -> Array[float]:
	return [0.0, 0.0, 0.0, 0.0]


## Returns the current equation of the model
func get_equation() -> String:
	return ""


## Predicts y for the given x
func predict(x: float) -> float:
	return 0.0


## Returns the shader material for model visualization
func get_shader() -> Shader:
	return Shader.new()
