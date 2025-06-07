extends Control


func _on_math_button_down() -> void:
	SceneLoader.play_level(0)


func _on_programming_button_down() -> void:
	SceneLoader.play_level(1)
