extends Node
class_name StateMachine


@export var default_state: State

## classes that extend State/StateMachine can make sure active_state is its own derived type
## i.e. PlayerState
var active_state:
	get = get_active_state, set = set_active_state
	
	
func _ready() -> void:
	active_state = default_state
		
	
func _process(delta: float) -> void:
	if active_state:
		active_state._state_process(delta)
	

func set_active_state(value: State) -> void:
	if value is not State:
		print_debug("Tried to set active state to % which is not a State"
			.format([value], "%"))
		return
	if active_state:
		active_state._state_exit()
	active_state = value
	print("Changed state to " + active_state.name)
	active_state._state_enter()


func get_active_state() -> State:
	return active_state as State
