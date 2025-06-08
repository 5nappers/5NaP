# A node of which a monster can path to 
class_name PathingNode
extends Node

@export var node_name: String = ""
@export var neighbour_nodes: Array[Node3D] = []

func _ready() -> void:
	for neighbour in neighbour_nodes:
		if (!neighbour.neighbour_nodes.has(self)):
			print("One sided connection on " + node_name + " and " + neighbour.node_name)
