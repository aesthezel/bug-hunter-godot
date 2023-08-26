extends Control
class_name MainScreen

@export var scene_to_change : PackedScene
@export var press_start_sound : AudioStreamPlayer2D
@export var timer_to_change_scene : Timer

var is_pressed : bool

func change_scene():
	get_tree().change_scene_to_packed(scene_to_change)
	get_tree().unload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	is_pressed = false
	timer_to_change_scene.timeout.connect(Callable(change_scene))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_pressed:
		return
	
	if Input.is_action_just_pressed("start"):
		is_pressed = true
		press_start_sound.play()
		timer_to_change_scene.start(2)
		
