extends Model


const STD = 0.2
const NORMAL_DISTRIBUTION_MULTIPLIER = 0.05


var rng = RandomNumberGenerator.new()


## Modifies the point position from the base generated one
func get_final_point_position(line_pos: Vector2) -> Vector2:
	line_pos[1] = 1.0 if line_pos[1] > 0.5 else 0.0
	return line_pos + Vector2(rng.randfn(0.0, STD) * NORMAL_DISTRIBUTION_MULTIPLIER, 0)


## Returns an array which contains, in this order, the minimum and maximum
## values for a and the minimum and maximum values for b
func get_limits() -> Array[float]:
	return [-10, 10, -10, 10]


## Gets limits for a and b. Used only for point generation
func get_point_limits() -> Array[float]:
	if randf() < 0.5:
		return [0.0, 0.3, 0.7, 1.0]
	return [0.7, 1.0, 0.0, 0.3]


## Returns the current equation of the model
func get_equation() -> String:
	return "Log(Y/(1-Y)) = %.2fX + %.2f" % [a, b]


## Predicts y for the given x
func predict(x: float) -> float:
	var val = a * x + b
	return exp(val) / (1 + exp(val))


## Returns the shader material for model visualization
func get_shader() -> int:
	return 1
