extends Node3D


func _on_play_button_down() -> void:
	SceneLoader.level_select()


func _on_quit_button_down() -> void:
	get_tree().quit()
