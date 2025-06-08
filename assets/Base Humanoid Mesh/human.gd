# human.gd
extends CharacterBody3D

@onready var animation_player = $AnimationPlayer

@export var speed: float = 4.0
@export var height_offset: float = 1.0

var path_to_goal: Array[Node3D] = []
var target_pos: Vector3
var moving: bool = false
var home_y: float

func _ready():
	await get_tree().create_timer(1).timeout
	animation_player.play("Walking")
	home_y = global_transform.origin.y

func _physics_process(delta: float) -> void:
	if moving:
		var to_target = target_pos - global_transform.origin
		to_target.y = 0
		var dir = to_target.normalized()
		var target_angle = atan2(dir.x, dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 10 * delta)
		if to_target.length() < 0.1:
			global_transform.origin = target_pos
			moving = false
			path_to_goal.pop_front()
			if path_to_goal.size() > 0:
				_move_to_next_node()
			else:
				animation_player.play("Idle")
		else:
			if animation_player.current_animation != "Walking":
				animation_player.play("Walking")
			velocity = dir * speed
			move_and_slide()

func set_new_path(nodes: Array[Node3D]) -> void:
	path_to_goal = nodes
	if path_to_goal.size() > 0:
		_move_to_next_node()

func _move_to_next_node() -> void:
	var next_node = path_to_goal[0]
	target_pos = next_node.global_transform.origin
	target_pos.y = home_y + height_offset
	moving = true
