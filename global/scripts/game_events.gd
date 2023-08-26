extends Node

signal play_sound(sound_name : String)
signal stop_sound(sound_name : String)
signal on_change_stat(life : int, stack_overflow : int, frame_jump : int)
signal on_scan(power_level : int, enemy_type : String)
signal game_over()
