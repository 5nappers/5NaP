class_name EndLevel
extends Control
## Shows the player their score and grade at the end of a level


var score: float

@onready var feedback_label: Label = $Control/FeedbackLabel
@onready var grade_label: Label = $Control/GradeLabel


func _ready() -> void:
	score = SceneLoader.current_score
	print(score)


func _on_play_again_button_down() -> void:
	SceneLoader.play_level()


func _on_return_menu_button_down() -> void:
	pass # Replace with function body.
