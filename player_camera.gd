extends Camera3D

@export_range(0,45) var edge_threshold_percentage := 30

var edge_left := 0
var edge_right := 0
var edge_top := 0
var edge_bottom := 0
var edges := {
	left = 0.0,
	right = 0.0,
	top = 0.0,
	bottom = 0.0,
}


func _ready() -> void:
	set_edges()
	
	
func _process(delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	
	# TODO: when the cursor is on the side of the screen, move camera to that side
	# at an interpolated speed based on closeness to the boreder
	# make sure to give bounds to how far left/right the player can look
	set_edges()
	
	# TODO: when the cursor is at the top, look up
	# then when cursor goes to the bottom look back to normal


func set_edges() -> void:
	var resolution := get_viewport().get_visible_rect().size

	edges.left = edge_threshold_percentage * resolution.x / 100
	edges.right = resolution.x - edges.left
	edges.top = edge_threshold_percentage * resolution.y / 100
	edges.bottom = resolution.y - edges.top
	
	edge_left = 
