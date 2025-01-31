extends Area2D
class_name Draggable


const LERP_WEIGHT = 0.1
const DEFAULT_SCALE = Vector2(0.8, 0.8)
const DRAG_SCALE = Vector2(1.0, 1.0)


@export var limited: bool = false
@export var limit_origin: Vector2
@export var limit_size: Vector2


var is_hovered: bool = false
var is_being_dragged: bool = false


@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	process_priority = 1
	mouse_entered.connect(hover)
	mouse_exited.connect(unhover)


func _physics_process(delta: float) -> void:
	sprite.scale = lerp(sprite.scale, DRAG_SCALE if is_hovered or is_being_dragged else DEFAULT_SCALE, LERP_WEIGHT)
	
	if is_being_dragged:
		global_position = get_viewport().get_mouse_position()
		if limited:
			global_position[0] = clamp(global_position[0], limit_origin[0], limit_origin[0] + limit_size[0])
			global_position[1] = clamp(global_position[1], limit_origin[1], limit_origin[1] + limit_size[1])


func hover() -> void:
	is_hovered = true
	Globals.enter_draggable_range(self)


func unhover() -> void:
	is_hovered = false
	Globals.exit_draggable_range(self)


## Called when object starts being dragged
func start_drag() -> void:
	is_being_dragged = true


## Called when object stops being dragged
func stop_drag() -> void:
	is_being_dragged = false
