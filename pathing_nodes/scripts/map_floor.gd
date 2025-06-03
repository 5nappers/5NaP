extends Node2D

@export var monsters: Array[Node3D] = []

@export var top_left_pos: Node3D
@export var bottom_right_pos: Node3D

@export var image_size: Vector2

signal monster_moved(monster: Node3D)

var monster_icons: Array[Sprite2D] = []
var monster_icon = preload("res://pathing_nodes/scenes/monster_icon.tscn")

func _ready() -> void:
	add_all_icons()
	monster_moved.connect(on_movement)


func add_all_icons():
	for icon in monster_icons:
		icon.queue_free()
	
	monster_icons = []
	
	for monster in monsters:
		add_icon()


func add_icon():
	var new_icon = monster_icon.instantiate()
	monster_icons.append(new_icon)
	add_child(new_icon)
	update_icon(monster_icons.size() - 1)


# Temporary script that moves the icons when the monster moves which will be removed whenever we add grayson and just call update_icon() directly
func on_movement(monster: Node3D):
	var index: int = monsters.find(monster)
	update_icon(index)


# Takes in the index of the monster in both the monsters array and monster_icons array and updates the icon pos
func update_icon(index: int):
	var path_node_pos: Vector3 = monsters[index].current_node.global_position
	
	var x_pos: float = inverse_lerp(top_left_pos.global_position.x, bottom_right_pos.global_position.x, path_node_pos.x)
	var y_pos: float = inverse_lerp(top_left_pos.global_position.z, bottom_right_pos.global_position.z, path_node_pos.z)
	
	x_pos = lerpf(0, image_size.x, x_pos)
	y_pos = lerpf(0, image_size.y, y_pos)
	
	var pos: Vector2 = Vector2(x_pos, y_pos)
	
	monster_icons[index].global_position = pos
