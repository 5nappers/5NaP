extends Control

@export var monsters: Array[Node3D] = []

@export var top_left_pos: Node3D
@export var bottom_right_pos: Node3D

var monster_icons: Array[TextureRect] = []
var monster_icon = preload("res://pathing_nodes/scenes/monster_icon.tscn")

func _ready() -> void:
	add_all_icons()

func add_all_icons():
	for icon in monster_icons:
		icon.queue_free()
	
	monster_icons = []
	
	for monster in monsters:
		add_icon(monster)


func add_icon(monster: Node3D):
	var new_icon = monster_icon.instantiate()
	monster_icons.append(new_icon)
	update_icon(monster_icons.size() - 1)


# Temporary script that moves the icons when the monster moves which will be removed whenever we add grayson and just call update_icon() directly
func on_movement(index: int):
	update_icon(index)


func update_icon(index: int):
	print("update pos")
