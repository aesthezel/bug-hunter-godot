class_name PlayerActivatorRay extends RayCast2D

@export var ray_distance : float = 10.0
@export var sleep_timer : Timer

var sleeping : bool

func sleep_ray(time : float):
	sleeping = true
	sleep_timer.start(time)

func wake_ray():
	sleeping = false

func checking_stack_overflow(collider):
	var stack_overflow = collider as SkillStackOverflow # Preguntar si el objeto es de este tipo
		
	if stack_overflow != null:
			stack_overflow.activate_skill(target_position.x)

func checking_enemy(collider):
	var enemy = collider as Enemy
	if enemy != null:
		enemy.set_life(-1)
		if enemy.get_current_life() == 0:
			GameEvents.play_sound.emit("scanner")
			GameEvents.on_scan.emit(1, enemy.get_string_type())
			enemy.scanned()

func _ready():
	sleep_timer.timeout.connect(wake_ray)

func _process(delta):
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	if horizontal_direction:
		target_position = Vector2(-ray_distance, 0.0) if horizontal_direction < 0 else Vector2(ray_distance, 0.0)
		
	if is_colliding() and !sleeping:
		var object_collided = get_collider()
		
		if Input.is_action_just_pressed("skill_one"):
			checking_stack_overflow(object_collided)
		
		if Input.is_action_just_pressed("scan"):
			checking_enemy(object_collided)
