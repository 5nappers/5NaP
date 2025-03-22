extends Camera3D

@export_range(0,45) var edge_threshold_percentage := 30

var edge_left := 0
var edge_right := 0
var edge_top := 0
var edge_bottom := 0


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	var resolution := get_viewport().get_visible_rect().size
	print("resolution: %\n  position: %".format([resolution, mouse_position], "%"))
	
	# TODO: when the cursor is on the side of the screen, move camera to that side
	# at an interpolated speed based on closeness to the boreder
	# make sure to give bounds to how far left/right the player can look
	if mouse_position < 
	
	# TODO: when the cursor is at the top, look up
	# then when cursor goes to the bottom look back to normal
	pass

func set_edges() -> void:
	edge_left = 
