extends Node2D
class_name MainMonitor


@onready var cursor: Sprite2D = $Cursor

signal assignment_submitted(score_percentage: float)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		handle_mouse_event(event)
		
		
func handle_mouse_event(event: InputEventMouse) -> void:
	cursor.global_position = event.position
