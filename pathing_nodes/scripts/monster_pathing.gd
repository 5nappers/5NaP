extends Node3D

@export var current_node: Node3D
#var goal_node: Node3D
var time: float = 0
var path_to_goal: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var cooldown: float = 2
	if time >= cooldown:
		move_to_next_node()
		time = fmod(time, cooldown) 

func move_to_next_node() -> void:
	if (path_to_goal.size() == 0): 
		print("No Path For Monster (This may or may not be intended)")
		return
	
	var new_node: Node3D = path_to_goal[0]
	move_node(new_node)
	path_to_goal.pop_front()

func move_node(new_node: Node3D) -> void:
	position = new_node.position
	current_node = new_node
	
	# If arrived at end of path
	if (path_to_goal[path_to_goal.size() - 1] == current_node):
		arrived_at_destination()

# This is called by whatever script (some state machine) that tells the freaks where to path to
func set_new_destination(new_node: Node) -> void:
	path_to_goal = calculate_path(new_node)

func calculate_path(destination: Node) -> Array[Node]:
	var path: Array[Node] = []
	
	
	return path
	
func arrived_at_destination() -> void:
	print("Arrived at path, this could call an event or something later");
