@tool
extends Control
class_name GraphBase


@export var legend_down: String:
	set(val):
		legend_down = val
		$Base/LegendDown.text = val
@export var min_down: float:
	set(val):
		min_down = val
		$Base/MinDown.text = "%.1f" % val
@export var max_down: float:
	set(val):
		max_down = val
		$Base/MaxDown.text = "%.1f" % val
@export var legend_left: String:
	set(val):
		legend_left = val
		$Base/LegendLeft.text = val
@export var min_left: float:
	set(val):
		min_left = val
		$Base/MinLeft.text = "%.1f" % val
@export var max_left: float:
	set(val):
		max_left = val
		$Base/MaxLeft.text = "%.1f" % val
