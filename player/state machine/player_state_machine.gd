extends StateMachine
class_name PlayerStateMachine


@onready var look_around: PlayerState = $LookAround
@onready var focus: PlayerState = $Focus

	
var input := Player.PlayerInput.new():
	set = set_player_input


func set_active_state(value) -> void:
	if value is not PlayerState:
		print_debug("Tried to set active state to % which is not a PlayerState"
			.format([value], "%"))
		return
	super.set_active_state(value)
	
	
func get_active_state() -> PlayerState:
	return active_state as PlayerState


func set_player_input(value: Player.PlayerInput) -> void:
	input = value
	active_state.input = input
	if input.push.y > 0:
		push_up()
	elif input.push.y < 0:
		push_down()


func push_up() -> void:
	pass
	
	
func push_down() -> void:
	if active_state == focus:
		active_state = look_around


func handle_focusable_clicked(focusable: Node3D) -> void:
	if active_state != look_around:
		return
	focus.focused_object = focusable
	active_state = focus
