extends ScrollContainer


const QUESTION_NAV_BUTTON = preload("res://minigame/monitor/UI/question_nav_button.tscn")

@export var button_hover_scale := 1.2
@export var button_toggled_scale := 1.4
@export var tween_duration := 0.1
@export var tween_ease := Tween.EaseType.EASE_IN_OUT
@export var tween_transition := Tween.TRANS_CIRC

var buttons: Array[QuestionNavButton]
var selected_button: QuestionNavButton

@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	for i: int in range(12):
		add_button()
	buttons[0].select()
		

func _process(delta: float) -> void:
	h_box_container.queue_sort()


func add_button() -> void:
	var button := QUESTION_NAV_BUTTON.instantiate()
	button.ui_behavior = copy_ui_behavior()
	button.select_button.connect(on_select_button)
	h_box_container.add_child(button)
	buttons.append(button)
	
	
func copy_ui_behavior() -> QuestionNavButton.UIBehavior:
	var ui_behavior := QuestionNavButton.UIBehavior.new()
	
	ui_behavior.button_hover_scale = Vector2.ONE * button_hover_scale
	ui_behavior.button_selected_scale = Vector2.ONE * button_toggled_scale
	ui_behavior.tween_duration = tween_duration
	ui_behavior.tween_ease = tween_ease
	ui_behavior.tween_transition = tween_transition
	
	return ui_behavior
	
	
func on_select_button(button: QuestionNavButton) -> void:
	if button == selected_button: return
	
	if selected_button:
		selected_button.deselect()
	selected_button = button
	
