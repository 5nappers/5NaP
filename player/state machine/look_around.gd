extends PlayerState


@export var rotate_speed := 1.0
@export var input_sensitivity_curve: Curve
@export_range(-179.5, 0, 0.5, "radians_as_degrees") var left_rotation_bound := -PI/3
@export_range(0, 179.5, 0.5, "radians_as_degrees") var right_rotation_bound := PI/3
@export_range(45, 90, 0.5) var fov := 75.0
@export var dof_distance := 10.0


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
	
	node_to_control.rotate(Vector3(0, 1, 0), rotate_angle)
	node_to_control.rotation.y = clamp(
			node_to_control.rotation.y, left_rotation_bound, right_rotation_bound
	)
	

func transition_in() -> void:
	# rotation.x at 0 to untilt the camera
	var rotation := node_to_control.rotation
	var camera := node_to_control as Camera3D
	var attributes := camera.attributes as CameraAttributesPractical
	rotation.x = 0
	tween.parallel().tween_property(camera, "rotation", rotation, transition_duration)
	tween.parallel().tween_property(camera, "position", Vector3.ZERO, transition_duration)
	tween.parallel().tween_property(camera, "fov", fov, transition_duration)
	tween.parallel().tween_property(
			attributes, "dof_blur_far_distance", dof_distance, transition_duration)
