extends PlayerState


@export var rotate_speed := 1.0
@export var input_sensitivity_curve: Curve
@export_range(-179.5, 0, 0.5, "radians_as_degrees") var left_rotation_bound := -PI/3
@export_range(0, 179.5, 0.5, "radians_as_degrees") var right_rotation_bound := PI/3


func _state_enter() -> void:
	super._state_enter()


func _state_process(delta: float) -> void:
	if input.push.length() == 0:
		return
	look_around(delta)
	
		
func look_around(delta: float) -> void:
	var rotate_angle := (input_sensitivity_curve
			.sample(abs(input.push.x))
			* rotate_speed * delta)
			
	if input.push.x > 0:
		rotate_angle = -rotate_angle
	
	control_object.rotate(Vector3(0, 1, 0), rotate_angle)
	control_object.rotation.y = clamp(
			control_object.rotation.y, left_rotation_bound, right_rotation_bound
	)
	
