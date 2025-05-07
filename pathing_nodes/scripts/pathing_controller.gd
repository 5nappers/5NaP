class_name PathingController

extends Node

@export var pathing: MonsterPathing
@export var timer: Timer

# Aggression is used to determine if the monster wants to path towards the player or away from them and will change over time.
# Difficulty effects it, but difficulty on its own primarily effects how fast the monsters will path and is a static value per level.
var aggression: float = 0
const max_aggression: float = 100
const aggression_multiplier: float = 0.25


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	pathing.finish_path.connect(on_finish_path)
	pathing.no_path.connect(on_no_path)


func _process(delta: float) -> void:
	aggression += ((pathing.difficulty as float / pathing.max_difficulty) + 5 * aggression_multiplier) * delta * (pathing.difficulty * aggression_multiplier)
	aggression = clampf(aggression, 0, max_aggression)
	print(aggression)


func on_timer_timeout() -> void:
	timer.start(5)
	print("time")


func on_finish_path() -> void:
	print("path")


func on_no_path() -> void:
	print("no path")
