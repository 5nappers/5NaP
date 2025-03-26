@tool
extends Node2D

@export var size := Vector2i(512, 512)
@export var color: Color
@export var top_left := Vector2.ZERO


func _draw() -> void:
	var rect := Rect2(top_left, size)
	draw_rect(rect, color, false, 2)


func _process(delta: float) -> void:
	queue_redraw()
