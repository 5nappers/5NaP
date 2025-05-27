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
	set = set_is_hovered
var state := State.UNANSWERED
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
	print("select")
	is_selected = true
	select_button.emit(self)
	reset_tween()
	tween.tween_property(
		rescalable_control, "scale", ui_behavior.button_selected_scale,
		ui_behavior.tween_duration)
	
	
func deselect() -> void:
	print("deselect")
	is_selected = false
	set_is_hovered(is_hovered)
	
	
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(ui_behavior.tween_ease)
	tween.set_trans(ui_behavior.tween_transition)


func set_is_hovered(value: bool) -> void:
	is_hovered = value
	if is_selected:
		return
	reset_tween()
	if is_hovered:
		tween.tween_property(
			rescalable_control, "scale", ui_behavior.button_hover_scale,
			ui_behavior.tween_duration)
		print("hovered!")
	else:
		tween.tween_property(
			rescalable_control, "scale", Vector2.ONE,
			ui_behavior.tween_duration)
		print("unhovered!")


class UIBehavior:
	var button_hover_scale: Vector2
	var button_selected_scale: Vector2
	var tween_duration: float
	var tween_ease : Tween.EaseType
	var tween_transition: Tween.TransitionType
