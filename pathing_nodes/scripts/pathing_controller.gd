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
	pathing.difficulty = clamp(pathing.difficulty, 1, pathing.max_difficulty)	
	timer.timeout.connect(on_timer_timeout)
	pathing.finish_path.connect(on_finish_path)
	timer.start(timer_time)


func _process(delta: float) -> void:
	aggression += ((pathing.difficulty as float / pathing.max_difficulty) + 5 * aggression_multiplier) * delta * (pathing.difficulty * aggression_multiplier)
	aggression = clampf(aggression, 0, max_aggression)


func on_timer_timeout() -> void:
	if (pathing.is_movement_paused):
		pathing.is_movement_paused = false;
	
	check_agression_direction()
	change_to_logical_path()
	timer.start(timer_time)


func on_finish_path() -> void:
	aggression = 0
	change_to_logical_path()
	pathing.is_movement_paused = true;
	timer.stop()
	timer.start(10) # how long the monster waits after capturing you, can be set by animation or something later

func check_agression_direction() -> void:
	isAttacking = aggression == max_aggression


func change_to_logical_path() -> void:
	if (isAttacking && !pathing.path_completed):
		pathing.set_new_destination(pathing.player_office_node)
	else:
		pathing.set_new_destination(pathing.monster_home_node)
