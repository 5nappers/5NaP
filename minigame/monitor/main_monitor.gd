extends Node2D
class_name MainMonitor
## Handles behaviour that takes place on the 2D UI scene


var assignment: JSON
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
	assignment = AssignmentDatabase.current_assignment
	for question in assignment.data.questions:
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


func submit() -> void:
	SceneLoader.current_score = calculate_score()
	SceneLoader.end_level()
	

## returns score as a decimal value from 0 - 1
func calculate_score() -> float:
	var correct_count := 0
	for question in questions:
		if question.user_answer == question.answer:
			correct_count += 1
			print("%s = %s" % [question.user_answer, question.answer])
		else:
			print("%s is not %s" % [question.user_answer, question.answer])
	SceneLoader.current_questions_correct = correct_count
	return correct_count / (questions.size() as float)


func _get_current_question() -> Dictionary:
	return questions[current_question_index]
	

func _get_current_question_button() -> QuestionNavButton:
	return question_nav_bar.buttons[current_question_index]
	

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
		submit()
		return
	switch_question(index)


func _on_submit_pressed() -> void:
	submit()
