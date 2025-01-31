extends Sprite2D
class_name Point


const MAX_DIF = 200


@export var gradient: GradientTexture1D


@onready var dif_line: Line2D = $Dif


func update_dif(dif: float, show: bool) -> void:
	dif_line.set_point_position(1, Vector2(0, -dif))
	
	var grad_image: Image = gradient.get_image()
	modulate = grad_image.get_pixel(min(int(min(abs(dif) / MAX_DIF, 1.0) * grad_image.get_width()), grad_image.get_width() - 1), 0)
	
	dif_line.visible = show
