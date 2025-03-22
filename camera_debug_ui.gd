extends Control

@export var color_left: Color
@export var color_right: Color
@export var color_top: Color
@export var color_bottom: Color
@export var length := 50
@export var thickness := 10

var edges := {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
var center: Vector2


func _ready() -> void:
	center = get_viewport().get_visible_rect().size / 2


func _process(delta: float) -> void:
	center = get_viewport().get_visible_rect().size / 2
	

func _draw() -> void:
	draw_rect(Rect2(edges.left, center.y - length/2, -thickness, length), color_left)
	draw_rect(Rect2(edges.right, center.y - length/2, thickness, length), color_right)
	draw_rect(Rect2(center.x - length/2, edges.top, length, -thickness), color_top)
	draw_rect(Rect2(center.x - length/2, edges.bottom, length, thickness), color_bottom)
	
