extends Node
## Handles loading of scenes and things


const level_scene := "res://minigame/minigame.tscn"
const end_level_scene := "res://minigame/end_level.tscn"
const menu_scene := "res://main_menu/main_menu.tscn"
const level_select_scene := "res://main_menu/level_select.tscn"

var loaded_level: Node
var current_questions_correct: int
var current_score: float


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func play_level(assignment: int) -> void:
	AssignmentDatabase.current_assignment_index = assignment
	get_tree().change_scene_to_file(level_scene)
	

func main_menu() -> void:
	get_tree().change_scene_to_file(menu_scene)


func end_level() -> void:
	get_tree().change_scene_to_file(end_level_scene)
	# reset to confined because the mouse mode is edited by main monitor in level
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func level_select() -> void:
	get_tree().change_scene_to_file(level_select_scene)
