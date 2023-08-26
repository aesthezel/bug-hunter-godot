class_name PlayerMovement extends CharacterBody2D

@export var player_system : PlayerSystem
@export var sprite : Sprite2D
@export var speed : float = 300.0
@export var jump_velocity : float = -400.0

var is_scanning : bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func perform_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func perform_hit():
	velocity.y = -100
	move_and_slide()

func perform_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		GameEvents.play_sound.emit("jump")

func perform_move():
	var direction = Input.get_axis("move_left", "move_right")
	if direction: 
		# Este if hace que si direction no vale 0, es decir si vale -1 o 1 haga el movimiento hacia el lado correspondiente
		velocity.x = direction * speed
		sprite.flip_h = false if velocity.x > 0 else true
	else:
		velocity.x = 0 #move_toward(velocity.x, 0, speed)
		if !is_scanning:
			player_system.player_animator.play("idle")

	move_and_slide()
	
func perform_scan():
	if Input.is_action_just_pressed("scan"):
		is_scanning = true
		player_system.player_animator.play("scan")
		
func end_scan(animation : String):
	if animation == "scan":
		is_scanning = false

func _ready():
	player_system.player_animator.animation_finished.connect(Callable(end_scan))

func _physics_process(delta):
	perform_gravity(delta)
	perform_jump()
	perform_move()
	perform_scan()
