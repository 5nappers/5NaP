class_name ClockTimer
extends Node


signal timer_end

@export var label: Label
@export var start_time: Vector2 = Vector2(17, 0)
@export var end_time: Vector2 = Vector2(23, 59)
@export var game_duration_sec: float = 480.0

#internal variables
var elapsed_time: float = 0.0
var _current_minutes: int = -1
var _start: int
var _end: int
var _game_over: bool = false

# updates the label only when changed 
var current_minutes: int:
	set(new_value):
		if new_value != _current_minutes:
			_current_minutes = new_value
			label.text = "%d:%02d PM" % [_current_minutes / 60, _current_minutes % 60]


func _ready() -> void:
	_start = int(start_time.x) * 60 + int(start_time.y)
	_end = int(end_time.x) * 60 + int(end_time.y)


func _process(delta: float) -> void:
	elapsed_time += delta
	elapsed_time = min(elapsed_time, game_duration_sec)
	var progress = elapsed_time / game_duration_sec
	current_minutes = int(lerp(_start, _end, progress))
	if elapsed_time >= game_duration_sec and not _game_over:
		_game_over = true
		timer_end.emit()
