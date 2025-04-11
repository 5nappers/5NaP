extends Area3D

## Allows interacting with a 2D scene projected on a surface in 3D
## Base written by joshii
## Code reference (mine is better though):
## https://github.com/Chevifier/ChevifierTutorials/blob/main/DiegeticUITutorial/Better%20Implementation/Area3D.gd

var world_to_screen_scaling: Vector2
var shape: BoxShape3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var main_monitor: MainMonitor = $SubViewport/MainMonitor


func _ready() -> void:
	shape = collision_shape_3d.shape
	world_to_screen_scaling = Vector2(
			sub_viewport.size.x / shape.size.x, sub_viewport.size.y / shape.size.y)


func _unhandled_input(event):
	if event is not InputEventMouse:
		sub_viewport.push_input(event)


func _on_input_event(_c: Node, event: InputEvent, pos: Vector3, _n: Vector3, _s: int):
	var local_event_position = get_global_transform().affine_inverse() * pos
		
	# Position of the event on screen.
	var screen_position := (
			Vector2(local_event_position.x, -local_event_position.y)
			* world_to_screen_scaling
			+ Vector2(sub_viewport.size) / 2
	)
	
	# Send mouse event.
	var e := event.duplicate()
	if e is InputEventMouse:
		e.set_position(screen_position)
		e.set_global_position(screen_position)
		sub_viewport.push_input(e)


func _on_mouse_entered() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	main_monitor.cursor.visible = true


func _on_mouse_exited() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	main_monitor.cursor.visible = false
