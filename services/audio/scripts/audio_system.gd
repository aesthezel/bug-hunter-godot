extends Node
class_name AudioSystem

@export var bgm_sound : AudioStreamPlayer2D
@export var scanner_sound : AudioStreamPlayer2D
@export var game_over_sound : AudioStreamPlayer2D
@export var jump_sound : AudioStreamPlayer2D
@export var stack_over_flow_launch_sound : AudioStreamPlayer2D

func play(sound_name : String):
	match(sound_name):
		"background":
			bgm_sound.play()
		"scanner":
			scanner_sound.play()
		"game_over":
			game_over_sound.play()
		"jump":
			jump_sound.play()
		"stack_launch":
			stack_over_flow_launch_sound.play()
			
func stop(sound_name : String):
	match(sound_name):
		"background":
			bgm_sound.stop()

func _ready():
	GameEvents.play_sound.connect(play)
	GameEvents.stop_sound.connect(stop)
