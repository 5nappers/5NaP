class_name PathingController

extends Node

@export var pathing: MonsterPathing
@export var timer: Timer

# Aggression is used to determine if the monster wants to path towards the player or away from them and will change over time.
# Difficulty effects it, but difficulty on its own primarily effects how fast the monsters will path and is a static value per level.
const max_aggression: float = 50
const aggression_multiplier: float = 0.25
const timer_time: float = 10;

var aggression: float = 0
var isAttacking: bool = false;


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	pathing.finish_path.connect(on_finish_path)
	pathing.no_path.connect(on_no_path)
	timer.start(timer_time)


func _process(delta: float) -> void:
	aggression += ((pathing.difficulty as float / pathing.max_difficulty) + 5 * aggression_multiplier) * delta * (pathing.difficulty * aggression_multiplier)
	aggression = clampf(aggression, 0, max_aggression)


func on_timer_timeout() -> void:
	check_agression_direction()
	timer.start(timer_time)


func on_finish_path() -> void:
	print("path done")


func on_no_path() -> void:
	print("no path")


func check_agression_direction() -> void:
	if (aggression == max_aggression && !isAttacking):
		pathing.set_new_destination(pathing.player_office_node)
		isAttacking = true;
