extends Node
## Handles loading of scenes and things


const level_scene := "res://minigame/minigame.tscn"
const end_level_scene := "res://minigame/end_level.tscn"
const menu_scene := ""

var loaded_level: Node


func play_level() -> void:
	get_tree().change_scene_to_file(level_scene)
	

func main_menu() -> void:
	get_tree().change_scene_to_file(menu_scene)


func end_level(score: float) -> void:
	print(score)
	get_tree().change_scene_to_file(end_level_scene)
