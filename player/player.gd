class_name Player
extends Node3D
## Handles player input


## The percentage of the horizontal resolution to be considered "push zone"
@export_range(0, 100, 0.5) var push_zone_size_horizontal := 25.0
## The percentage of the vertical resolution to be considered "push zone"
@export_range(0, 100, 0.5) var push_zone_size_vertical := 25.0


## the inner bounds from which to exclude push zone
var push_zone_bounds := {
	left = 0.0,
	right = 0.0,
	top = 0.0,
	bottom = 0.0,
}
var viewport_resolution: Vector2i:
	set = set_resolution
	
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var input := PlayerInput.new()


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	viewport_resolution = get_viewport().get_visible_rect().size
	get_player_input()
	
	
func set_resolution(value: Vector2i) -> void:
	if value == viewport_resolution: 
		return
	viewport_resolution = value
	input.viewport_resolution = viewport_resolution
	set_push_zone_bounds()


func set_push_zone_bounds() -> void:
	push_zone_bounds.left = push_zone_size_horizontal * viewport_resolution.x / 200
	push_zone_bounds.right = viewport_resolution.x - push_zone_bounds.left
	push_zone_bounds.top = push_zone_size_vertical * viewport_resolution.y / 200
	push_zone_bounds.bottom = viewport_resolution.y - push_zone_bounds.top
	
	
func get_player_input() -> void:
	input.mouse_position = get_viewport().get_mouse_position()
	input.push = get_push_vector(input.mouse_position)
	state_machine.input = input
	

func get_push_vector(mouse_position: Vector2) -> Vector2:
	var push_vector: Vector2
	# set x velocity to negative (left) or positive (right) depending on mouse position
	# closer to the end of the screen means greater strength
	if mouse_position.x < push_zone_bounds.left:
		push_vector.x = -inverse_lerp(push_zone_bounds.left, 0, mouse_position.x)
	elif mouse_position.x > push_zone_bounds.right:
		push_vector.x = inverse_lerp(
				push_zone_bounds.right, viewport_resolution.x, mouse_position.x)
	else:
		push_vector.x = 0
	push_vector.x = clamp(push_vector.x, -1, 1)
	
	# set y velocity to negative (down) or positive (up)
	# reminder: in 2D space, negative Y is up and positive is down
	if mouse_position.y < push_zone_bounds.top:
		push_vector.y = 1.0
	elif mouse_position.y > push_zone_bounds.bottom:
		push_vector.y = -1.0
	else:
		push_vector.y = 0.0
		
	return push_vector


class PlayerInput:
	var push: Vector2
	var mouse_position: Vector2
	var viewport_resolution: Vector2i
