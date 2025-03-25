extends Control

@export var monsters := []:
	set(value):
		monsters = value
		# update map position here

@export var top_left_pos: Node3D
@export var bottom_right_pos: Node3D
