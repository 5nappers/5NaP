extends Area3D
class_name Focusable

## Determines an area the player can click on to focus

@onready var target_camera_transform: Marker3D = $TargetCameraTransform

signal on_click(focusable: Focusable)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		on_click.emit(self)
