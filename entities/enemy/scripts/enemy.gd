class_name Enemy extends CharacterBody2D

enum EnemyType {
	Jumper,
	Stacker,
	Mantis
}

func set_life(point : int):
	pass

func reset_life():
	pass

func evaluate_life_reaction(point : int):
	pass

func get_exact_type(enemy : Enemy) -> Enemy:
	match (typeof(enemy)):
		EnemyJumper:
			print("Jumper")
			return enemy as EnemyJumper

	return enemy
