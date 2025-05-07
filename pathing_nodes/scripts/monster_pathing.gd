class_name MonsterPathing

extends Node3D

@export var lecturer_name: String
@export var current_node: Node3D
@export var player_office_node: Node3D
@export var map_control: Node2D
@export var max_path_attempts: int = 100
@export var difficulty: int = 10
const max_difficulty: int = 20
var time: float = 0
var path_to_goal: Array[Node3D] = []
signal finish_path
signal no_path

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var cooldown: float = 2
	if (time >= cooldown):
		move_to_next_node()
		time = fmod(time, cooldown) 


func move_to_next_node() -> void:
	if (path_to_goal.size() == 0): 
		print("No Path For Monster (This may or may not be intended)")
		no_path.emit()
		return
	
	# If it fails the roll based on difficulty don't move
	if (randi_range(0, max_difficulty) > difficulty):
		return
	
	var new_node: Node3D = path_to_goal[0]
	move_node(new_node)
	path_to_goal.pop_front()
	map_control.monster_moved.emit(self)
	print("moved")


func move_node(new_node: Node3D) -> void:
	position = new_node.position
	current_node = new_node
	
	# If arrived at end of path
	if (get_destination() == current_node):
		arrived_at_destination()


func get_destination() -> Node3D:
	if (path_to_goal.size() == 0): return null
	
	return path_to_goal[path_to_goal.size() - 1]


func arrived_at_destination() -> void:
	print("Arrived at path");
	finish_path.emit()


# This is called by whatever script (some state machine) that tells the freaks where to path to maybe
func set_new_destination(new_node: Node3D) -> void:
	path_to_goal = calculate_path(new_node)


func calculate_path(destination: Node3D) -> Array[Node3D]:
	var path: Array[Node3D] = []
	var blocked_nodes: Array[Node3D] = []
	
	var path_found: bool = false
	var node_to_check: Node3D = current_node
	var count: int = 0
	
	var backtrack_path: bool = false
	
	var prev_node: Node3D = null
	
	# Run until a path is found
	while (!path_found):
		# if stuck on a path node with no neighbours
		if (node_to_check.neighbour_nodes.size() == 0):
			print("Got stuck on node with no neighbours" + node_to_check.to_string())
			return []
		
		# Starting the backtrack on a dead end
		if (node_to_check.neighbour_nodes.size() == 1):
			backtrack_path = true
		
		var blocked_check_count: int = 0 
		# Loops until a node that isn't blocked is found and then disables the ability to backtrack
		while (blocked_check_count < node_to_check.neighbour_nodes.size() && backtrack_path):
			# Ending the backtrack on a dead end
			if (!blocked_nodes.has(node_to_check.neighbour_nodes[blocked_check_count])):
				backtrack_path = false
				
				# Finding the path it just backtracked on and removing it
				# from the final path to avoid needless looping
				var first_index: int = path.find(prev_node)
				if (first_index >= 0):
					var second_index: int = path.find(prev_node, first_index)
					print(first_index)
					print(second_index)
					
					# If index out of bounds array issues start happening its because of right under here
					# Removing the path nodes that were in the backtracked section
					var for_min: int = max(0, first_index - 1)
					var for_max: int = min(path.size() - 1, second_index + 2)
					
					for i in range(for_min, for_max):
						path.remove_at((first_index - 1))
			blocked_check_count += 1
		
		# Calculating the best path node to choose to check
		var best_index: int = -1
		var best_distance: float = 69694206969; # Needs to be a big number and couldn't find a way to do the bit limit
		for i in node_to_check.neighbour_nodes.size():
			if ((!blocked_nodes.has(node_to_check.neighbour_nodes[i]) || backtrack_path) && (!prev_node == node_to_check.neighbour_nodes[i] || node_to_check.neighbour_nodes.size() == 1)):
				var distance: float = node_to_check.neighbour_nodes[i].position.distance_to(destination.position)
				if (distance < best_distance):
					best_distance = distance
					best_index = i
		
		# Upating to the best fit node and adding it to the path
		prev_node = node_to_check
		node_to_check = node_to_check.neighbour_nodes[best_index]
		path.append(node_to_check)
		blocked_nodes.append(node_to_check)
		
		# If path found break the loop
		if (node_to_check == destination): path_found = true
		
		# Checking it doesn't run forever in case of a loop (which shouldn't be possible)
		count += 1
		if (count >= max_path_attempts): 
			print("Tried to path 250 times, probably stuck in a loop. Returning empty path.")
			return []
		
	return path
