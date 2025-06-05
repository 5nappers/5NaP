class_name EndLevel
extends Control
## Shows the player their score and grade at the end of a level


var score: float

@onready var feedback_label: Label = $FeedbackLabel
@onready var grade_label: Label = $GradeLabel


func _ready() -> void:
	score = SceneLoader.current_score
	var questions_correct := SceneLoader.current_questions_correct
	var question_count = AssignmentDatabase.current_assignment.data.questions.size()
	var grade := grade()
	grade_label.text = "Score: %s/%s\nGrade: %s" % [questions_correct, question_count, grade]


# returns a grade based on the score and NZ's grading scale
func grade() -> String:
	if score >= 0.9:
		return "A+"
	if score >= 0.85:
		return "A"
	if score >= 0.8:
		return "A-"
	if score >= 0.75:
		return "B+"
	if score >= 0.7:
		return "B"
	if score >= 0.65:
		return "B-"
	if score >= 0.6:
		return "C+"
	if score >= 0.55:
		return "C"
	if score >= 0.5:
		return "C-"
	if score >= 0.45:
		return "D"
	return "F"


func _on_play_again_button_down() -> void:
	SceneLoader.play_level()


func _on_return_menu_button_down() -> void:
	get_tree().quit()
