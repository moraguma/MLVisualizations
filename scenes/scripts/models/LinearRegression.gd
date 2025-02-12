extends Model


const STD = 0.2
const NORMAL_DISTRIBUTION_MULTIPLIER = 0.2


var rng = RandomNumberGenerator.new()


## Modifies the point position from the base generated one
func get_final_point_position(line_pos: Vector2) -> Vector2:
	return line_pos + Vector2(0, rng.randfn(0.0, STD) * NORMAL_DISTRIBUTION_MULTIPLIER)


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
func get_shader() -> int:
	return 0
