# MonsterPathing.gd
extends CharacterBody3D
class_name MonsterPathing

@export var lecturer_name: String
@export var player_office_node: Node3D
@export var monster_home_node: Node3D
@export var map_control: Node2D
@export var max_path_attempts: int = 100
@export var difficulty: int = 10
const max_difficulty: int = 20
var current_node: Node3D
var time: float = 0
var path_to_goal: Array[Node3D] = []
var is_movement_paused: bool = false
var path_completed: bool = false
var speed: float = 3.0
var height_offset: float = 1.0
var target_pos: Vector3
var moving: bool = false
var home_y: float = 0

signal finish_path
signal no_path
signal trigger_jumpscare

func _ready() -> void:
	current_node = monster_home_node
	home_y = global_transform.origin.y

func _process(delta: float) -> void:
	time += delta
	var cooldown: float = 2
	if time >= cooldown:
		move_to_next_node()
		time = fmod(time, cooldown)

func _physics_process(delta: float) -> void:
	if moving:
		var to_target = target_pos - global_transform.origin
		to_target.y = 0
		var dir = to_target.normalized()
		var target_angle = atan2(dir.x, dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 10 * delta)
		if to_target.length() < 0.1:
			global_transform.origin = target_pos
			current_node = path_to_goal[0]
			path_to_goal.pop_front()
			map_control.monster_moved.emit(self)
			moving = false
			if path_to_goal.size() == 0:
				arrived_at_destination()
		else:
			velocity = dir * speed
			move_and_slide()

func move_to_next_node() -> void:
	if is_movement_paused:
		return
	if path_to_goal.size() == 0:
		print("No Path For Monster (This may or may not be intended)")
		no_path.emit()
		return
	if randi_range(0, max_difficulty) > difficulty:
		return
	var new_node: Node3D = path_to_goal[0]
	target_pos = new_node.global_transform.origin
	target_pos.y = home_y + height_offset
	moving = true

func get_destination() -> Node3D:
	if path_to_goal.size() == 0: return null
	return path_to_goal[path_to_goal.size() - 1]

func arrived_at_destination() -> void:
	path_completed = true
	finish_path.emit()
	if current_node == player_office_node:
		trigger_jumpscare.emit()

func set_new_destination(new_node: Node3D) -> void:
	path_to_goal = calculate_path(new_node)
	path_completed = false

func calculate_path(destination: Node3D) -> Array[Node3D]:
	var path: Array[Node3D] = []
	var blocked_nodes: Array[Node3D] = []
	var path_found: bool = false
	var node_to_check: Node3D = current_node
	var count: int = 0
	var backtrack_path: bool = false
	var prev_node: Node3D = null

	while not path_found:
		if node_to_check.neighbour_nodes.size() == 0:
			print("Got stuck on node with no neighbours" + node_to_check.to_string())
			return []
		if node_to_check.neighbour_nodes.size() == 1:
			backtrack_path = true
		var blocked_check_count: int = 0
		while blocked_check_count < node_to_check.neighbour_nodes.size() and backtrack_path:
			if not blocked_nodes.has(node_to_check.neighbour_nodes[blocked_check_count]):
				backtrack_path = false
				var first_index: int = path.find(prev_node)
				if first_index >= 0:
					var second_index: int = path.find(prev_node, first_index)
					var for_min: int = max(0, first_index - 1)
					var for_max: int = min(path.size() - 1, second_index + 2)
					for i in range(for_min, for_max):
						path.remove_at(first_index - 1)
			blocked_check_count += 1
		var best_index: int = -1
		var best_distance: float = 69694206969
		for i in node_to_check.neighbour_nodes.size():
			if (not blocked_nodes.has(node_to_check.neighbour_nodes[i]) or backtrack_path) and (prev_node != node_to_check.neighbour_nodes[i] or node_to_check.neighbour_nodes.size() == 1):
				var distance: float = node_to_check.neighbour_nodes[i].position.distance_to(destination.position)
				if distance < best_distance:
					best_distance = distance
					best_index = i
		prev_node = node_to_check
		node_to_check = node_to_check.neighbour_nodes[best_index]
		path.append(node_to_check)
		blocked_nodes.append(node_to_check)
		if node_to_check == destination:
			path_found = true
		count += 1
		if count >= max_path_attempts:
			print("Tried to path 250 times, probably stuck in a loop. Returning empty path.")
			return []
	return path
