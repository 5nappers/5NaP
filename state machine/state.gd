extends Node
class_name State


## Object to control properties of
@export var control_object: Node3D
## All properties of the control object to set on state enter
## Key: NodePath, Property: Variant
@export var transformations: Dictionary
## Time it takes for state enter transition
@export var transition_duration := 0.4

var tween: Tween
var state_machine: StateMachine


func _state_enter() -> void:
	if transformations.keys().size() > 0:
		transition_in()
	
	
func _state_process(delta: float) -> void:
	pass


func _state_exit() -> void:
	if tween:
		tween.kill()


func transition_in() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	for property in transformations.keys():
		var node_path = property as NodePath
		if node_path == null:
			continue
		var final_val = transformations[property]
		(tween.parallel()
				.tween_property(control_object, node_path, final_val, transition_duration)
				.set_ease(Tween.EASE_IN_OUT))
