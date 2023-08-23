class_name EnemyJumper extends Enemy

@export var max_life := 1
@export var jump_velocity : Vector2 = Vector2.ZERO
@export var jump_wait_timer : Timer
@export var time_to_jump : float = 3
@export var recovery_timer : Timer
@export var time_to_recovery : float = 3
@export var view_direction_ray : RayCast2D
@export var view_distance : float = 20
@export var enemy_view_direction : EnemyDirection
@export var enemy_sprite : Sprite2D
@export var flip_timer : Timer

var current_life := 0
var motion = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var blocked_flip := false

enum EnemyDirection {
	LEFT = -1,
	RIGHT = 1
}

enum EnemyJumperStates { 
	IDLE,
	JUMPING,
	STUN,
	DIED
}

var current_state = {
	"state" : EnemyJumperStates.IDLE,
	"previous_state" : EnemyJumperStates.IDLE,
	"first_time" : false
}

func unlock_flip():
	blocked_flip = false

# ENEMY BASE
func switch_direction():
	blocked_flip = true
	flip_timer.start(time_to_recovery)
	enemy_view_direction = EnemyDirection.LEFT if enemy_view_direction == EnemyDirection.RIGHT else EnemyDirection.RIGHT
	enemy_sprite.flip_h = !enemy_sprite.flip_h

func set_life(point : int):
	evaluate_life_reaction(point)
	current_life = clamp(current_life + point, 0, max_life)
	print(current_life)
	if current_life == 0:
		change_state(EnemyJumperStates.STUN)
		
func evaluate_life_reaction(point : int):
	if point < 0:
		velocity.x = 100 * enemy_view_direction
		velocity.y = -50
	elif point > 0:
		velocity.y = -50

func reset_life():
	set_life(max_life)
	change_state(EnemyJumperStates.IDLE)

# STATES
func change_state(new_state : EnemyJumperStates):
	current_state.first_time = false
	current_state.previous_state = current_state.state
	current_state.state = new_state

func idle_state(delta):
	if current_state.first_time == false:
		jump_wait_timer.start(time_to_jump)
		current_state.first_time = true
	
	velocity.x = 0
	velocity.y += gravity * delta
	move_and_slide()
	
func jumping_state(delta):
	if is_on_floor() and !current_state.first_time:
		velocity.y = jump_velocity.y
		velocity.x = jump_velocity.x * enemy_view_direction
		current_state.first_time = true
	elif !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor() and current_state.first_time:
		change_state(EnemyJumperStates.IDLE)

	move_and_slide()

func stun_state(delta):
	if !current_state.first_time:
		jump_wait_timer.stop()
		recovery_timer.start(time_to_recovery)
		current_state.first_time = true
	
	velocity.x = 0
	velocity.y += gravity * delta
	move_and_slide()
	
func died_state():
	if !current_state.first_time:
		print("Enemy died")
		self.queue_free()
# END STATES

func _ready():
	current_life = max_life
	view_direction_ray.target_position.x = view_distance * enemy_view_direction
	jump_wait_timer.timeout.connect(Callable(change_state).bind(EnemyJumperStates.JUMPING))
	recovery_timer.timeout.connect(Callable(reset_life))
	flip_timer.timeout.connect(Callable(unlock_flip))

func _process(delta):
	match current_state.state:
		EnemyJumperStates.IDLE:
			idle_state(delta)
		EnemyJumperStates.JUMPING:
			jumping_state(delta)
		EnemyJumperStates.STUN:
			stun_state(delta)
		EnemyJumperStates.DIED:
			died_state()
	
	if view_direction_ray.is_colliding() and !blocked_flip:
		switch_direction()

