class_name PlayerActivatorRay extends RayCast2D

@export var ray_distance : float = 10.0
@export var sleep_timer : Timer

var sleeping : bool

func sleep_ray(time : float):
	sleeping = true
	sleep_timer.start(time)

func wake_ray():
	sleeping = false

func _ready():
	sleep_timer.timeout.connect(wake_ray)

func _process(delta):
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	if horizontal_direction:
		target_position = Vector2(-ray_distance, 0.0) if horizontal_direction < 0 else Vector2(ray_distance, 0.0)
		
	if is_colliding() and !sleeping:
		var stackOverFlow = get_collider() as SkillStackOverflow # Preguntar si el objeto es de este tipo
		if stackOverFlow != null:
			if Input.is_action_just_pressed("attack"):
				stackOverFlow.activate_skill(target_position.x)
