extends Control


const MIN_A = -1.0
const MAX_A = 1.0
const MIN_B = 0.25
const MAX_B = 0.75

const STD = 0.5
const NORMAL_DISTRIBUTION_MULTIPLIER = 20


var rng = RandomNumberGenerator.new()


@onready var points: Array[Node] = $Points.get_children()
@onready var linear_regression: Line2D = $LinearRegression
@onready var adjuster: Draggable = $Adjuster
@onready var adjust_base: ColorRect = $Interactibles/Adjust/Base


func _ready() -> void:
	$Buttons/Generate.pressed.connect(generate_points)
	
	var adjust: GraphBase = $Interactibles/Adjust
	adjust.min_down = MIN_A
	adjust.max_down = MAX_A
	adjust.min_left = MIN_B
	adjust.max_left = MAX_B
	
	randomize()
	generate_points()


func _physics_process(delta: float) -> void:
	var a = MIN_A + (MAX_A - MIN_A) * (adjuster.position[0] - adjuster.limit_origin[0]) / adjuster.limit_size[0]
	var b = (MAX_B - (MAX_B - MIN_B) * (adjuster.position[1] - adjuster.limit_origin[1]) / adjuster.limit_size[1]) * 500
	
	linear_regression.clear_points()
	
	var limits = get_limits(a, b)
	for limit in limits:
		linear_regression.add_point(limit)


func generate_points():
	var a = MIN_A + (MAX_A - MIN_A) * randf()
	var b = (MIN_B + (MAX_B - MIN_B) * randf()) * 500
	
	var limits = get_limits(a, b)
	var min_x = limits[0][0]
	var max_x = limits[0][0]
	for i in range(1, len(limits)):
		min_x = min(min_x, limits[i][0])
		max_x = max(max_x, limits[i][0])
	var point_positions: Array[Vector2] = []
	for point in points:
		var x = randf_range(min_x, max_x)
		point.position = Vector2(x, -a * x - b + rng.randfn(0.0, STD) * NORMAL_DISTRIBUTION_MULTIPLIER)
		point_positions.append(point.position)
	adjust_base.material.set_shader_parameter("points", point_positions)


## Given a and b, returns the points that match with the edges of graph
func get_limits(a: float, b: float) -> Array[Vector2]:
	var limits: Array[Vector2] = []
	var x_limits = [50, 450]
	var y_limits = [50, 450]
	for x in x_limits:
		var y = a * x + b 
		if y >= y_limits[0] and y <= y_limits[1]:
			limits.append(Vector2(x, -y))
	if a != 0:
		for y in y_limits:
			var x = (y - b) / a
			if x >= x_limits[0] and x <= x_limits[1]:
				limits.append(Vector2(x, -y))
	return limits
