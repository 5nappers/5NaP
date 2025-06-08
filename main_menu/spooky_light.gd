extends OmniLight3D


@export var time_on_average := 0.5
@export var time_on_randomness := 0.3
@export var time_off_average := 3.0
@export var time_off_randomness := 2.0
@export var energy_off := 0.0
@export var energy_on := 0.4
@export var energy_off_randomness := 0.05
@export var energy_on_randomness := 0.1

var is_on := false

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.start()


func _process(delta: float) -> void:
	var base_energy = energy_on if is_on else energy_off
	# do some processing to make flicker happen
	var speed = randf_range(10, 11)
	var randomness = energy_on_randomness if is_on else energy_off_randomness
	light_energy = base_energy + (2 * sin(timer.time_left * speed) - 1) * randomness


func _on_timer_timeout() -> void:
	is_on = !is_on
	if is_on:
		timer.wait_time = randf_range(
				time_on_average - time_on_randomness, time_on_average + time_on_randomness)
	else:
		timer.wait_time = randf_range(
				time_off_average - time_off_randomness, time_off_average + time_off_randomness)
	timer.start()
