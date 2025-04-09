extends PlayerState


var focused_object: Focusable


func _state_enter() -> void:
	focused_object.visible = false
	super._state_enter()
	
	
func _state_exit() -> void:
	super._state_exit()
	focused_object.on_unfocus.emit()
	focused_object.visible = true
	

func transition_in() -> void:
	var target_position := focused_object.target_camera_transform.global_position
	var rotation := focused_object.target_camera_transform.global_rotation
	var fov := focused_object.fov
	var camera := node_to_control as Camera3D
	var attributes := camera.attributes as CameraAttributesPractical
	var dof_distance := target_position.distance_to(focused_object.global_position)
	
	tween.parallel().tween_property(
			camera, "global_position", target_position, transition_duration)
	tween.parallel().tween_property(
			camera, "global_rotation", rotation, transition_duration)
	tween.parallel().tween_property(camera, "fov", fov, transition_duration)
	tween.parallel().tween_property(
			attributes, "dof_blur_far_distance", dof_distance, transition_duration)
	
	
