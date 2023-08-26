class_name PlayerSkillSpawner extends Node2D

@export var player_system : PlayerSystem
@export var instance_offset : Vector2 = Vector2.ZERO
@export var activator_ray : PlayerActivatorRay
@export var skill_stack_overflow_packed : PackedScene
@export var input_disabled_time : float = 1.0
@export var input_timer : Timer

var _can_input : bool = true

func disable_input(time):
	_can_input = false
	input_timer.start(time)

func enable_input():
	_can_input = true

func _ready():
	input_timer.timeout.connect(enable_input)

func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		instance_offset.x = instance_offset.x * -1
	if Input.is_action_just_pressed("move_right"):
		instance_offset.x = abs(instance_offset.x)
	
	if player_system.stack_overflow == 0:
		return
	
	if _can_input:
		if Input.is_action_just_pressed("skill_one") and !activator_ray.is_colliding():
			disable_input(input_disabled_time)
			activator_ray.sleep_ray(input_disabled_time)
			
			var skill = skill_stack_overflow_packed.instantiate() as SkillStackOverflow
			owner.add_child(skill)
			skill.global_position = global_position + instance_offset
			player_system.update_stats_by_use(-1, "StackOverflow")
