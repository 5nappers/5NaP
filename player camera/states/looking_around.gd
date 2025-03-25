extends State

@export var camera: PlayerCamera
@export var move_sensitivity_easing: Curve
@export var move_speed := 1.0


func _state_process(delta: float) -> void:
	if camera.move_velocity.x == 0:
		return
		
	var rotate_angle := (
			move_sensitivity_easing.sample(abs(camera.move_velocity.x))
			* move_speed * delta
	)
	if camera.move_velocity.x > 0:
		rotate_angle = -rotate_angle
	
	camera.global_rotate(Vector3(0, 1, 0), rotate_angle)
	
	print(camera.global_rotation)
