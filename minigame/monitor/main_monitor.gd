extends Node2D
class_name MainMonitor

## Handles behaviour that takes place on the 2D UI scene

signal assignment_submitted(score_percentage: float)

const ASSIGNMENT: JSON = preload("res://minigame/monitor/assignment/assignment-1.json")

var questions: Array[Dictionary]
var current_question_index: int
var current_question: Dictionary:
	get = _get_current_question
var current_question_button: QuestionNavButton:
	get = _get_current_question_button

@onready var cursor: Sprite2D = $Cursor
@onready var question_nav_bar: QuestionNavBar = $QuestionUI/QuestionNavBar
@onready var question: Label = $QuestionUI/Question
@onready var answer: LineEdit = $QuestionUI/Answer


func _ready() -> void:
	for question in ASSIGNMENT.data.questions:
		questions.append({
				"question": question.question, 
				"answer": question.answer,
				"user_answer": "",
		})
		question_nav_bar.add_button()
	answer.grab_focus()
	question_nav_bar.buttons[0].select()
	switch_question(0)
	

func switch_question(index: int) -> void:
	if current_question.user_answer == "":
		current_question_button.state = QuestionNavButton.State.UNANSWERED
	else:
		current_question_button.state = QuestionNavButton.State.ANSWERED
		
	current_question_index = index
	question.text = questions[index].question
	answer.text = questions[index].user_answer
	question_nav_bar.buttons[index].select()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		cursor.global_position = event.position


func _on_question_nav_bar_button_selected(index: int) -> void:
	switch_question(index)


func _on_answer_text_changed(new_text: String) -> void:
	current_question.user_answer = new_text
	question_nav_bar.buttons[current_question_index].state = (
			QuestionNavButton.State.ANSWERED
	)


func _on_answer_text_submitted(_new_text: String) -> void:
	var index = current_question_index + 1
	if index >= questions.size():
		return
	switch_question(index)


func _get_current_question() -> Dictionary:
	return questions[current_question_index]
	

func _get_current_question_button() -> QuestionNavButton:
	return question_nav_bar.buttons[current_question_index]
