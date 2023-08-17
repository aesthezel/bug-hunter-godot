class_name ActivatorRay extends RayCast2D

@export var rayDistance : float = 10.0

func _process(delta):
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	if horizontal_direction:
		target_position = Vector2(-rayDistance, 0.0) if horizontal_direction < 0 else Vector2(rayDistance, 0.0)
		
	if is_colliding():
		var stackOverFlow = get_collider() as SkillStackOverflow # Preguntar si el objeto es de este tipo
		if stackOverFlow != null:
			if Input.is_action_pressed("attack"):
				stackOverFlow.activate_skill(target_position.x)
