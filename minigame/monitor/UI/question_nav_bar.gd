class_name QuestionNavBar
extends ScrollContainer


signal button_selected(index: int)

const QUESTION_NAV_BUTTON = preload("res://minigame/monitor/UI/question_nav_button.tscn")

@export var button_hover_scale := 1.2
@export var button_toggled_scale := 1.4
@export var button_answered_modulate: Color
@export var button_unanswered_modulate: Color
@export var tween_duration := 0.1
@export var tween_ease := Tween.EaseType.EASE_IN_OUT
@export var tween_transition := Tween.TRANS_CIRC

var button_ui_behavior: QuestionNavButton.UIBehavior
var buttons: Array[QuestionNavButton]
var selected_button: QuestionNavButton

@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	copy_ui_behavior()
		

func _process(delta: float) -> void:
	h_box_container.queue_sort()
	
	
func add_button() -> void:
	var button := QUESTION_NAV_BUTTON.instantiate()
	button.ui_behavior = button_ui_behavior
	button.select_button.connect(_on_button_selected)
	h_box_container.add_child(button)
	buttons.append(button)
	
	
func copy_ui_behavior() -> void:
	button_ui_behavior = QuestionNavButton.UIBehavior.new()
	button_ui_behavior.button_hover_scale = Vector2.ONE * button_hover_scale
	button_ui_behavior.button_selected_scale = Vector2.ONE * button_toggled_scale
	button_ui_behavior.button_answered_modulate = button_answered_modulate
	button_ui_behavior.button_unanswered_modulate = button_unanswered_modulate
	button_ui_behavior.tween_duration = tween_duration
	button_ui_behavior.tween_ease = tween_ease
	button_ui_behavior.tween_transition = tween_transition
	
	
func _on_button_selected(button: QuestionNavButton) -> void:
	if button == selected_button: return
	
	if selected_button:
		selected_button.deselect()
	selected_button = button
	
	var index := buttons.find(button)
	button_selected.emit(index)
