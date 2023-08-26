extends Node2D
class_name ControlScreen

@export var animation_player : AnimationPlayer
@export var scene_to_change : PackedScene
@export var timer_to_change : Timer

func change_scene():
	get_tree().root.add_child(scene_to_change.instantiate())
	get_tree().unload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("control")
	timer_to_change.timeout.connect(Callable(change_scene))
	timer_to_change.start(6)
	
func _process(delta):
	if Input.is_action_just_pressed("start"):
		change_scene()
