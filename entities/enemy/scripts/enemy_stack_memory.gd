extends Enemy
class_name EnemyStackMemory

@export var max_life := 3
@export var move_velocity : Vector2 = Vector2.ZERO
@export var move_wait_timer : Timer
@export var time_to_stack_memory : float = 3
@export var recovery_timer : Timer
@export var time_to_recovery : float = 3
@export var view_direction_ray : RayCast2D
@export var view_distance : float = 20
@export var enemy_view_direction : EnemyDirection
@export var enemy_sprite : Sprite2D
@export var flip_timer : Timer
@export var animation_beattle : AnimationPlayer
@export var animation_ball_move : AnimationPlayer
@export var animation_ball_grow : AnimationPlayer
@export var ball_node : Node2D
@export var ball_distance : float = 15
@export var attach_left : Node2D
@export var attach_right : Node2D

var current_life := 0
var motion = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var blocked_flip := false

enum EnemyDirection {
	LEFT = -1,
	RIGHT = 1
}

enum EnemyStackMemoryStates { 
	IDLE,
	MEMORY,
	STUN,
	DIED
}

var current_state = {
	"state" : EnemyStackMemoryStates.IDLE,
	"previous_state" : EnemyStackMemoryStates.IDLE,
	"first_time" : false
}

func get_string_type() -> String:
	return "EnemyStackMemory"
	
func get_current_life() -> int:
	return current_life

func unlock_flip():
	blocked_flip = false

# ENEMY BASE
func switch_direction():
	blocked_flip = true
	flip_timer.start(time_to_recovery)
	enemy_view_direction = EnemyDirection.LEFT if enemy_view_direction == EnemyDirection.RIGHT else EnemyDirection.RIGHT
	enemy_sprite.flip_h = !enemy_sprite.flip_h
	ball_node.reparent(attach_left if enemy_view_direction == EnemyDirection.RIGHT else attach_right)
	ball_node.position.x = ball_distance * enemy_view_direction

func set_life(point : int):
	evaluate_life_reaction(point)
	current_life = clamp(current_life + point, 0, max_life)
	if current_life == 0:
		change_state(EnemyStackMemoryStates.STUN)
		
func scanned():
	died_state()
		
func evaluate_life_reaction(point : int):
	if point < 0:
		velocity.x = 100 * enemy_view_direction
		velocity.y = -50
	elif point > 0:
		velocity.y = -50

func reset_life():
	set_life(max_life)
	change_state(EnemyStackMemoryStates.IDLE)

# STATES
func change_state(new_state : EnemyStackMemoryStates):
	current_state.first_time = false
	current_state.previous_state = current_state.state
	current_state.state = new_state

func idle_state(delta):
	if !current_state.first_time:
		move_wait_timer.start(time_to_stack_memory)
		current_state.first_time = true
	
	velocity.x = 0
	velocity.y += gravity * delta
	move_and_slide()
	
func stack_memory_state(delta):
	if !current_state.first_time:
		ball_node.visible = true
		animation_ball_move.play("Move")
		animation_ball_grow.play("Grow")
		current_state.first_time = true
	
	velocity.x = move_velocity.x * enemy_view_direction
	if !is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func stun_state(delta):
	if !current_state.first_time:
		move_wait_timer.stop()
		recovery_timer.start(time_to_recovery)
		current_state.first_time = true
	
	velocity.x = 0
	velocity.y += gravity * delta
	move_and_slide()
	
func died_state():
	if !current_state.first_time:
		self.queue_free()
# END STATES

func _ready():
	ball_node.visible = false
	current_life = max_life
	view_direction_ray.target_position.x = view_distance * enemy_view_direction
	move_wait_timer.timeout.connect(Callable(change_state).bind(EnemyStackMemoryStates.MEMORY))
	recovery_timer.timeout.connect(Callable(reset_life))
	flip_timer.timeout.connect(Callable(unlock_flip))

func _process(delta):
	match current_state.state:
		EnemyStackMemoryStates.IDLE:
			idle_state(delta)
		EnemyStackMemoryStates.MEMORY:
			stack_memory_state(delta)
		EnemyStackMemoryStates.STUN:
			stun_state(delta)
		EnemyStackMemoryStates.DIED:
			died_state()
	
	if view_direction_ray.is_colliding() and !blocked_flip:
		switch_direction()
