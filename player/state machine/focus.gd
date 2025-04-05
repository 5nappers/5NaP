extends PlayerState


@export_range(45, 90) var fov := 60
@export var player: Player

var focused_object: Focusable


func _state_enter() -> void:
	focused_object.visible = false
	super._state_enter()
	
	
func _state_exit() -> void:
	super._state_exit()
	focused_object.visible = true
	

func transition_in() -> void:
	var target_position := focused_object.target_camera_transform.global_position
	var rotation := focused_object.target_camera_transform.global_rotation
	tween.parallel().tween_property(
			node_to_control, "global_position", target_position, transition_duration)
	tween.parallel().tween_property(
			node_to_control, "global_rotation", rotation, transition_duration)
	tween.parallel().tween_property(node_to_control, "fov", fov, transition_duration)
	
