class_name SkillStackOverflow extends RigidBody2D

@export var forceVelocity : float = 300.0
@export var forceTimer : Timer
@export var skillTime : float = 10

var isActivated : bool = false

func activate_skill(direction : float):
	
	var customDirection = -1 if direction < 0 else 1
	forceVelocity = forceVelocity * customDirection
	
	forceTimer.start(skillTime)
	isActivated = true

func disable_skill():
	isActivated = false
	queue_free()

func _ready():
	forceTimer.timeout.connect(disable_skill)

func _physics_process(delta):
	if isActivated:
		set_axis_velocity(Vector2(forceVelocity, 0.0))
	else:
		linear_velocity = Vector2.ZERO
