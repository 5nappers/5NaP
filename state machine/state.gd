extends Node
class_name State


## Node to control properties of
@export var node_to_control: Node3D

## Time it takes for state enter transition
@export var transition_duration := 0.4

var tween: Tween
var state_machine: StateMachine


func _state_enter() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	transition_in()
	
	
func _state_process(delta: float) -> void:
	pass


func _state_exit() -> void:
	if tween:
		tween.kill()


## use tween to set object properties smoothly
func transition_in() -> void:
	pass
