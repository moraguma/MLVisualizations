extends Control


const MODELS = [
	{"name": "Linear Regression", "script": preload("res://scenes/scripts/models/LinearRegression.gd")}
]

const STD = 0.5
const NORMAL_DISTRIBUTION_MULTIPLIER = 20
const PLOT_RESOLUTION = 100


var model
var rng = RandomNumberGenerator.new()


@onready var points_holder: Node2D = $Points
@onready var points: Array[Node] = $Points.get_children()
@onready var plot: Line2D = $Plot
@onready var adjuster: Draggable = $Adjuster
@onready var adjust_graph: GraphBase = $Interactibles/Adjust
@onready var adjust_base: ColorRect = $Interactibles/Adjust/Base
@onready var equation: Label = $Equation
@onready var error_toggle: CheckButton = $ErrorToggle
@onready var model_selector: OptionButton = $Buttons/Models


func _ready() -> void:
	# Setup
	toggle_error()
	error_toggle.pressed.connect(toggle_error)
	$Buttons/Generate.pressed.connect(generate_points)
	
	model_selector.clear()
	for model in MODELS:
		model_selector.add_item(model["name"])
	model_selector.selected = 0
	model = MODELS[0]["script"]
	
	# Initialize model
	
	var limits = model.get_limits()
	adjust_graph.min_down = limits[0]
	adjust_graph.max_down = limits[1]
	adjust_graph.min_left = limits[2]
	adjust_graph.max_left = limits[3]
	
	randomize()
	generate_points()


func _physics_process(delta: float) -> void:
	model.set_parameters((adjuster.position[0] - adjuster.limit_origin[0]) / adjuster.limit_size[0],
							-(adjuster.position[1] - adjuster.limit_origin[1]) / adjuster.limit_size[1])
	
	plot.clear_points()
	
	var limits = get_limits(a, b)
	for limit in limits:
		linear_regression.add_point(limit)
	update_points(a, b)
	
	equation.text = "Y = %.2fX + %.2f" % [a, b / 500]


func generate_points():
	var a = MIN_A + (MAX_A - MIN_A) * randf()
	var b = (MIN_B + (MAX_B - MIN_B) * randf()) * 500
	
	
	var min_max_x = get_min_max_x(a, b)
	var min_x = min_max_x[0]
	var max_x = min_max_x[1] 
	
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


## Returns min and max x in line
func get_min_max_x(a: float, b: float) -> Array[float]:
	var limits = get_limits(a, b)
	var min_x = limits[0][0]
	var max_x = limits[0][0]
	for i in range(1, len(limits)):
		min_x = min(min_x, limits[i][0])
		max_x = max(max_x, limits[i][0])
	return [min_x, max_x]


## Updates visualization of points
func update_points(a: float, b: float) -> void:
	var min_max_x = get_min_max_x(a, b)
	var min_x = min_max_x[0]
	var max_x = min_max_x[1] 
	
	for point: Point in points:
		point.update_dif(point.position[1] + a * point.position[0] + b, point.position[0] >= min_x and point.position[0] <= max_x)


## Updates visibility of points and error gradient
func toggle_error() -> void:
	var val = error_toggle.button_pressed
	points_holder.visible = val
	adjust_base.material.set_shader_parameter("on", val)
