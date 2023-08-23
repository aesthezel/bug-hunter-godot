class_name MovingPlatformLoop extends Node2D

@export var path_follow : PathFollow2D
@export var tween_translate : Tween.TransitionType
@export var tween_ease : Tween.EaseType
@export var replays : int = 0
@export var time_to_move : float = 5

func create_new_tween_direction(start_percent : float, end_percent : float):
	var tween : Tween = create_tween().set_trans(tween_translate).set_ease(tween_ease).set_loops(replays)
	tween.tween_property(path_follow, "progress_ratio", end_percent, time_to_move)
	tween.tween_property(path_follow, "progress_ratio", start_percent, time_to_move)

# Called when the node enters the scene tree for the first time.
func _ready():
	create_new_tween_direction(0, 1)
