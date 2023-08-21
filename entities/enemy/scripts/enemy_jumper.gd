class_name EnemyJumper extends CharacterBody2D

@export var life := 1
@export var speed := 500.0
@export var jump_height := 5.0
@export var jump_distance = 5.0
@export var jump_direction = Vector2.RIGHT
@export var jump_velocity : Vector2 = Vector2.ZERO

@export var jump_wait_timer : Timer
@export var time_to_jump : float = 3

var motion = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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

# STATES
func change_state(new_state : EnemyJumperStates):
	current_state.first_time = false
	current_state.previous_state = current_state.state
	current_state.state = new_state

func idle_state():
	if current_state.first_time == false:
		jump_wait_timer.start(time_to_jump)
		current_state.first_time = true
	
func jumping_state(delta):
	
	if is_on_floor() and !current_state.first_time:
		velocity.y = jump_velocity.y
		velocity.x = jump_velocity.x
		current_state.first_time = true
	elif !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor() and current_state.first_time:
		change_state(EnemyJumperStates.IDLE)

	move_and_slide()

func stun_state():
	pass
	
func died_state():
	pass
# END STATES

func _ready():
	jump_wait_timer.timeout.connect(Callable(change_state).bind(EnemyJumperStates.JUMPING))

func _process(delta):
	
	match current_state.state:
		EnemyJumperStates.IDLE:
			idle_state()
		EnemyJumperStates.JUMPING:
			jumping_state(delta)
		EnemyJumperStates.STUN:
			stun_state()
		EnemyJumperStates.DIED:
			died_state()
