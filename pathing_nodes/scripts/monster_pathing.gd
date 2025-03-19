extends Node3D

@export var current_node: Node3D
var goal_node: Node3D
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var cooldown: float = 2
	if time >= cooldown:
		select_new_node()
		time = fmod(time, cooldown) 

func select_new_node() -> void:
	var neighbour_nodes: Array[Node] = current_node.neighbour_nodes
	move_node(neighbour_nodes[0])

func move_node(new_node: Node3D) -> void:
	position = new_node.position
	current_node = new_node
