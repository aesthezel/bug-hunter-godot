class_name Enemy extends CharacterBody2D

func get_current_life() -> int:
	return -1

func get_string_type() -> String:
	return "Enemy"

func set_life(point : int):
	pass

func reset_life():
	pass

func evaluate_life_reaction(point : int):
	pass

func scanned():
	pass	
