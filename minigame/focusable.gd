extends Area3D
class_name Focusable
## Determines an area the player can click on to focus


@export var fov := 60.0
@export var focus_to_left: Focusable
@export var focus_to_right: Focusable

@onready var target_camera_transform: Marker3D = $TargetCameraTransform

signal on_click(focusable: Focusable)
signal on_unfocus


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		on_click.emit(self)
