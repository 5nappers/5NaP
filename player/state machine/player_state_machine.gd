extends StateMachine
class_name PlayerStateMachine


@export_range(0,45) var edge_threshold_percentage := 30

@onready var look_around: PlayerState = $LookAround
@onready var look_up: PlayerState = $LookUp
@onready var focus: PlayerState = $Focus

	
var input := Player.PlayerInput.new():
	set = handle_player_input


func set_active_state(value) -> void:
	if value is not PlayerState:
		print_debug("Tried to set active state to % which is not a PlayerState"
			.format([value], "%"))
		return
	super.set_active_state(value)
	
	
func get_active_state() -> PlayerState:
	return active_state as PlayerState


func handle_player_input(value: Player.PlayerInput) -> void:
	input = value
	active_state.input = input
