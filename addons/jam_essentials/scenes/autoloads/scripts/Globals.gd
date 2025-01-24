extends Node


const MASTER_BUS = 0
const MUSIC_BUS = 1
const SFX_BUS = 2
const BUS_TO_STRING = {
	MASTER_BUS: "Master",
	MUSIC_BUS: "Music",
	SFX_BUS: "SFX"
}


var draggables_in_range: Array[Draggable] = []
var currently_dragging: Draggable = null


func _physics_process(delta: float) -> void:
	# Start drag
	if Input.is_action_just_pressed("click") and len(draggables_in_range) > 0:
		# Get closest draggable
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var closest_draggable: Draggable = draggables_in_range[0]
		var closest_distance: float = (mouse_pos - closest_draggable.global_position).length()
		for i in range(1, len(draggables_in_range)):
			var new_draggable: Draggable = draggables_in_range[i]
			var new_distance: float = (mouse_pos - new_draggable.global_position).length()
			if new_distance < closest_distance:
				closest_draggable = new_draggable
				closest_distance = new_distance
		
		# Start drag
		currently_dragging = closest_draggable
		closest_draggable.start_drag()
	# Stop drag
	elif Input.is_action_just_released("click") and is_dragging():
		currently_dragging.stop_drag()
		currently_dragging = null


## Return whether mouse is currently dragging
func is_dragging() -> bool:
	return currently_dragging != null


## Adds element to list of elements in drag range
func enter_draggable_range(d: Draggable) -> void:
	draggables_in_range.append(d)


## Removes element from list of elements in drag range
func exit_draggable_range(d: Draggable) -> void:
	draggables_in_range.erase(d)


## If the given check is true, pushes a warning message and returns true.
## Otherwise, returns false
func check_and_error(check: bool, message: String):
	if check:
		push_error(message)
		return true
	return false
