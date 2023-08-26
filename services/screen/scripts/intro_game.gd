extends Node2D
class_name IntroGame

@export var scene_to_change : PackedScene
@export var video_player : VideoStreamPlayer

func change_scene():
	get_tree().change_scene_to_packed(scene_to_change)
	get_tree().unload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	video_player.finished.connect(Callable(change_scene))
