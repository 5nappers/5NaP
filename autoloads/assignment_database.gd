extends Node


const assignments: Array[JSON] = [
	preload("res://minigame/monitor/assignment/assignment-1.json"),
	preload("res://minigame/monitor/assignment/assignment-2.json"),
]

var current_assignment_index := 0:
	set(value):
		current_assignment_index = value % assignments.size()
var next_assignment_index := 0:
	set(value):
		next_assignment_index = value % assignments.size()
		
## the currently assigned assignment
var current_assignment: JSON:
	get:
		return assignments[current_assignment_index]


func get_next_assignment() -> JSON:
	current_assignment_index = next_assignment_index
	next_assignment_index += 1
	return assignments[current_assignment_index]
