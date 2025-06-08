extends Node


var ambience_2_volume_db: float

@onready var ambience_2: AudioStreamPlayer = $Ambience2
@onready var ambience_2_timer: Timer = $Ambience2/Timer
@export var volume_fade_duration := 2.0


func _ready() -> void:
	ambience_2_volume_db = ambience_2.volume_db
	ambience_2.volume_db = -40
	ambience_2.play()


func _on_ambience_2_timer_timeout() -> void:
	if randi_range(1, 5) >= 3:
		fade_volume(ambience_2, ambience_2_volume_db)
	else:
		fade_volume(ambience_2, -40)
		

func fade_volume(track: AudioStreamPlayer, volume_db: float) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.tween_property(ambience_2, "volume_db", volume_db, volume_fade_duration)
