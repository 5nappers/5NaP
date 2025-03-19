extends Node3D

@export var current_node: Node3D
@export var dest_node_temp: Node3D
#var goal_node: Node3D
var time: float = 0
var path_to_goal: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_new_destination(dest_node_temp)

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
	if (get_destination() == current_node):
		arrived_at_destination()

# This is called by whatever script (some state machine) that tells the freaks where to path to
func set_new_destination(new_node: Node3D) -> void:
	path_to_goal = calculate_path(new_node)

func calculate_path(destination: Node3D) -> Array[Node3D]:
	var path: Array[Node3D] = []
	var pathFound: bool = false
	var check_node: Node3D = current_node
	var count: int = 0
	
	var blocked_nodes: Array[Node3D] = []
	var backtrack_path: bool = false
	
	var prev_node: Node3D
	
	while (!pathFound):
		if (check_node.neighbour_nodes.size() == 0):
			print("Node has no neighbours womp womp!")
			return []
		
		
		# Starting the backtrack on a dead end
		if (check_node.neighbour_nodes.size() == 1):
			backtrack_path = true
		
		var blocked_check_count: int = 0 
		# Ending the backtrack on a dead end
		while (blocked_check_count < check_node.neighbour_nodes.size() && backtrack_path):
			if (!blocked_nodes.has(check_node.neighbour_nodes[blocked_check_count])):
				backtrack_path = false
				var first_index: int = path.find(prev_node)
				if (first_index >= 0):
					var second_index: int = path.find(prev_node, first_index)
					print(first_index)
					print(second_index)
					
					# If index out of bounds array issues start happening its because of right under here
					var for_min: int = max(0, first_index - 1)
					var for_max: int = min(path.size() - 1, second_index + 2)
					
					for i in range(for_min, for_max):
						print(path)
						path.remove_at((first_index - 1))
						print(path)
			blocked_check_count += 1
		
		
		var best_index: int = -1
		var best_distance: float = 69694206969; # Needs to be a big number and couldn't find a way to do the bit limit
		for i in check_node.neighbour_nodes.size():
			if ((!blocked_nodes.has(check_node.neighbour_nodes[i]) || backtrack_path) && (!prev_node == check_node.neighbour_nodes[i] || check_node.neighbour_nodes.size() == 1)):
				var distance: float = check_node.neighbour_nodes[i].position.distance_to(destination.position)
				if (distance < best_distance):
					best_distance = distance
					best_index = i
		
		print(str(best_distance) + ", " + str(best_index))
		
		prev_node = check_node
		check_node = check_node.neighbour_nodes[best_index]
		path.append(check_node)
		blocked_nodes.append(check_node)
		
		if (check_node == destination): pathFound = true
		
		count += 1
		if (count >= 250): 
			print("Tried to path 250 times, probably stuck in a loop. Returning empty path.")
			return []
		
	return path
	
func get_destination() -> Node3D:
	if (path_to_goal.size() == 0): return null
	
	return path_to_goal[path_to_goal.size() - 1]

func arrived_at_destination() -> void:
	print("Arrived at path, this could call an event or something later");
