extends MeshInstance3D


@export var transition_duration := 0.4

var tween: Tween

@onready var material := get_active_material(0) as StandardMaterial3D


func _ready() -> void:
	refresh_tween()


func _on_focus(f: Focusable) -> void:
	print("focus")
	refresh_tween()
	tween.tween_property(material, "emission_energy_multiplier", 2, transition_duration)


func _on_unfocus() -> void:
	print("unfocus")
	refresh_tween()
	tween.tween_property(material, "emission_energy_multiplier", 0, transition_duration)


func refresh_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	
