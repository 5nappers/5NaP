extends Camera3D

@export_range(0,200) var edge_width := 100


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	# TODO: when the cursor is on the side of the screen, move camera to that side
	# at an interpolated speed based on closeness to the boreder
	# make sure to give bounds to how far left/right the player can look
	# 
	# TODO: when the cursor is at the top, look up
	# then when cursor goes to the bottom look back to normal
	pass
