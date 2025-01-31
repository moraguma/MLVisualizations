extends Control


const MODELS = [
	{"name": "Linear Regression", "script": preload("res://scenes/scripts/models/LinearRegression.gd")},
	{"name": "Logistic Regression", "script": preload("res://scenes/scripts/models/LogisticRegression.gd")}
]

const STD = 0.5
const NORMAL_DISTRIBUTION_MULTIPLIER = 20
const PLOT_RESOLUTION = 50
const PLOT_SIZE = 500.0


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
	adjuster.changed_position.connect(update_graph)
	
	# Initialize model selector
	model_selector.clear()
	for model in MODELS:
		model_selector.add_item(model["name"])
	model_selector.selected = 0
	model_selector.item_selected.connect(update_model)
	
	update_model(0)
	
	randomize()


## Updates model based on selection
func update_model(index: int) -> void:
	model = MODELS[index]["script"].new()
	
	# Initialize model
	update_graph()
	var limits = model.get_limits()
	adjust_graph.min_down = limits[0]
	adjust_graph.max_down = limits[1]
	adjust_graph.min_left = limits[2]
	adjust_graph.max_left = limits[3]
	adjust_base.material.set_shader_parameter("limits", limits)
	adjust_base.material.set_shader_parameter("model", model.get_shader())
	
	generate_points()


## Updates visualization of the graph
## TODO: Allow for multiple line segments
func update_graph() -> void:
	var baked_line = model.set_parameters((adjuster.position[0] - adjuster.limit_origin[0]) / adjuster.limit_size[0],
							1.0 - (adjuster.position[1] - adjuster.limit_origin[1]) / adjuster.limit_size[1],
							PLOT_RESOLUTION, PLOT_SIZE)
	
	plot.clear_points()
	plot.points = baked_line[-1]
	
	equation.text = model.get_equation()
	
	update_points()


func generate_points():
	var point_positions = model.generate_points(len(points))
	adjust_base.material.set_shader_parameter("points", point_positions)
	for i in range(len(points)):
		points[i].position = PLOT_SIZE * Vector2(point_positions[i][0], -point_positions[i][1])
	
	update_points()
	adjust_base.material.set_shader_parameter("points", point_positions)


## Updates visualization of points
func update_points() -> void:
	for point: Point in points:
		point.update_dif(point.position[1] + model.predict(point.position[0] / PLOT_SIZE) * PLOT_SIZE, point.position[0] >= model.effective_x_limits[0][0] * PLOT_SIZE and point.position[0] <= model.effective_x_limits[0][1] * PLOT_SIZE)


## Updates visibility of points and error gradient
func toggle_error() -> void:
	var val = error_toggle.button_pressed
	points_holder.visible = val
	adjust_base.material.set_shader_parameter("on", val)
