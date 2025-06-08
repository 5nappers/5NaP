extends Camera3D
## the camera that moves like it's breathing. you might say it's pretty cool


@export_range(0.01, 2) var speed_horizontal := 0.36
@export_range(0.01, 2) var speed_vertical := 1.0
@export_range(0, 0.015) var strength_horizontal := 0.015
@export_range(0, 0.015) var strength_vertical := 0.01

var time := 0.0


func _process(delta: float) -> void:
	time += delta
	rotation.y = sin(time * speed_horizontal) * strength_horizontal
	rotation.x = sin(time * speed_vertical) * strength_vertical
