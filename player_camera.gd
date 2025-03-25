extends Camera3D

# TODO: when the cursor is on the side of the screen, move camera to that side
# at an interpolated speed based on closeness to the boreder
# make sure to give bounds to how far left/right the player can look

# TODO: when the cursor is at the top, look up
# then when cursor goes to the bottom look back to normal

@export_range(0,45) var edge_threshold_percentage := 30
@export var states: Array[State]
@export var active_state: State

@onready var debug_ui: Control = $CameraDebugUI

var resolution: Vector2
var move_velocity: Vector2

var edges := {
	left = 0.0,
	right = 0.0,
	top = 0.0,
	bottom = 0.0,
}


func _ready() -> void:
	set_edges()
	
	
func _process(delta: float) -> void:
	resolution = get_viewport().get_visible_rect().size
	
	set_edges()
	process_mouse_position()
	
	#active_state._state_process()


func set_edges() -> void:
	edges.left = edge_threshold_percentage * resolution.x / 100
	edges.right = resolution.x - edges.left
	edges.top = edge_threshold_percentage * resolution.y / 100
	edges.bottom = resolution.y - edges.top
	
	debug_ui.edges = edges


func process_mouse_position() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	
	# set x velocity to negative (left) or positive (right) depending on mouse position
	# closer to the end of the screen means greater strength
	if mouse_position.x < edges.left:
		move_velocity.x = -inverse_lerp(edges.left, 0, mouse_position.x)
	elif mouse_position.x > edges.right:
		move_velocity.x = inverse_lerp(edges.right, resolution.x, mouse_position.x)
	else:
		move_velocity.x = 0
	move_velocity.x = clamp(move_velocity.x, -1, 1)
	
	# set y velocity to negative (down) or positive (up)
	# reminder: in 2D space, negative Y is up and positive is down
	if mouse_position.y < edges.top:
		move_velocity.y = 1.0
	elif mouse_position.y > edges.bottom:
		move_velocity.y = -1.0
	else:
		move_velocity.y = 0.0
		
	print(move_velocity)
