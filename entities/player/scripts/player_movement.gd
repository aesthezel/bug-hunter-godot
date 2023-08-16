class_name PlayerMovement extends CharacterBody2D

@export var sprite : Sprite2D
@export var speed : float = 300.0
@export var jump_velocity : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func perform_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func perform_jump():
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity

func perform_move():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = true if velocity.x > 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _physics_process(delta):
	perform_gravity(delta)
	perform_jump()
	perform_move()
