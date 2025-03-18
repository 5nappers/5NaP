extends MeshInstance3D

@export var current_node: Node
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var cooldown: float = 2
	if time >= cooldown:
		move_node();
		time = fmod(time, cooldown) 
		
func move_node() -> void:
	var neighbour_nodes: Array[Node] = current_node.neighbour_nodes
	position = neighbour_nodes[0].position
	current_node = neighbour_nodes[0]
