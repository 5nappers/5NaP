class_name QuestionNavButton
extends CenterContainer


signal select_button(button: QuestionNavButton)

enum State {
	UNANSWERED,
	ANSWERED,
	NEEDS_ATTENTION,
}

var is_selected: bool
var is_hovered: bool:
	set = _set_is_hovered
var state: QuestionNavButton.State = QuestionNavButton.State.UNANSWERED:
	set = _set_state
var tween: Tween
var ui_behavior: UIBehavior

@onready var button: TextureRect = $Control/Button
@onready var rescalable_control: Control = $Control


func _ready() -> void:
	reset_tween()
	
	
func _on_button_mouse_entered() -> void:
	is_hovered = true


func _on_button_mouse_exited() -> void:
	is_hovered = false


func _on_button_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouse:
		return
	if (event as InputEventMouse).is_pressed():
		select()
		
		
func select() -> void:
	is_selected = true
	select_button.emit(self)
	reset_tween()
	tween.tween_property(
		rescalable_control, "scale", ui_behavior.button_selected_scale,
		ui_behavior.tween_duration)
	
	
func deselect() -> void:
	is_selected = false
	_set_is_hovered(is_hovered)
	
	
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(ui_behavior.tween_ease)
	tween.set_trans(ui_behavior.tween_transition)


func _set_is_hovered(value: bool) -> void:
	is_hovered = value
	if is_selected:
		return
	reset_tween()
	if is_hovered:
		tween.tween_property(
			rescalable_control, "scale", ui_behavior.button_hover_scale,
			ui_behavior.tween_duration)
	else:
		tween.tween_property(
			rescalable_control, "scale", Vector2.ONE,
			ui_behavior.tween_duration)


func _set_state(value: QuestionNavButton.State) -> void:
	state = value
	match state:
		QuestionNavButton.State.UNANSWERED:
			modulate = ui_behavior.button_unanswered_modulate
		QuestionNavButton.State.ANSWERED:
			modulate = ui_behavior.button_answered_modulate


class UIBehavior:
	var button_hover_scale: Vector2
	var button_selected_scale: Vector2
	var button_answered_modulate: Color
	var button_unanswered_modulate: Color
	var tween_duration: float
	var tween_ease : Tween.EaseType
	var tween_transition: Tween.TransitionType
