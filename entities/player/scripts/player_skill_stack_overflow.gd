class_name SkillStackOverflow extends RigidBody2D

@export var force_velocity : float = 300.0
@export var force_timer : Timer
@export var skill_time : float = 10

var _is_activated : bool = false

func activate_skill(direction : float):
	var custom_direction = -1 if direction < 0 else 1
	force_velocity = force_velocity * custom_direction
	
	force_timer.start(skill_time)
	_is_activated = true

func disable_skill():
	_is_activated = false
	queue_free()

func _ready():
	force_timer.timeout.connect(disable_skill)

func _physics_process(delta):
	if _is_activated:
		set_axis_velocity(Vector2(force_velocity, 0.0))
	else:
		linear_velocity = Vector2.ZERO
