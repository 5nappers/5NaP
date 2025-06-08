extends PlayerState


const INPUT_PUSH_SIDE_THRESHOLD := 0.9

@export var ui_push_bar_down: TextureRect
@export var ui_push_bar_left: TextureRect
@export var ui_push_bar_right: TextureRect

var focused_object: Focusable
var camera_rotation: Vector3


func _state_enter() -> void:
	focused_object.visible = false
	ui_push_bar_down.visible = true
	ui_push_bar_left.visible = focused_object.focus_to_left != null
	ui_push_bar_right.visible = focused_object.focus_to_right != null
	super._state_enter()
	
	
func _state_exit() -> void:
	super._state_exit()
	focused_object.on_unfocus.emit()
	focused_object.visible = true
	ui_push_bar_down.visible = false
	ui_push_bar_left.visible = false
	ui_push_bar_right.visible = false


func _state_process(delta: float) -> void:
	node_to_control.global_rotation = camera_rotation
	var player_state_machine := state_machine as PlayerStateMachine
	
	if (player_state_machine.input.push.x > INPUT_PUSH_SIDE_THRESHOLD
			and focused_object.focus_to_right):
		shift_focus(focused_object.focus_to_right)
	if (player_state_machine.input.push.x < -INPUT_PUSH_SIDE_THRESHOLD
			and focused_object.focus_to_left):
		shift_focus(focused_object.focus_to_left)

	
func shift_focus(new_focused_object: Focusable) -> void:
	_state_exit()
	focused_object = new_focused_object
	focused_object.on_click.emit(focused_object)
	_state_enter()


func transition_in() -> void:
	var target_position := focused_object.target_camera_transform.global_position
	var rotation := focused_object.target_camera_transform.global_rotation
	var fov := focused_object.fov
	var camera := node_to_control as Camera3D
	var attributes := camera.attributes as CameraAttributesPractical
	var dof_distance := target_position.distance_to(focused_object.global_position)
	camera_rotation = camera.global_rotation
	
	# use positive values only
	if camera_rotation.y < 0:
		camera_rotation.y += 2 * PI
	if rotation.y < 0:
		rotation.y += 2 * PI
	
	tween.parallel().tween_property(
			camera, "global_position", target_position, transition_duration)
	tween.parallel().tween_property(
			self, "camera_rotation", rotation, transition_duration)
	tween.parallel().tween_property(camera, "fov", fov, transition_duration)
	tween.parallel().tween_property(
			attributes, "dof_blur_far_distance", dof_distance, transition_duration)
