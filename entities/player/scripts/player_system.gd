class_name PlayerSystem extends Node2D

@export var player_movement : PlayerMovement
@export var player_activator_ray : PlayerActivatorRay
@export var player_animator : AnimationPlayer
@export var player_collision : Area2D
@export var stack_overflow_texture : CompressedTexture2D
@export var frame_jump_texture : CompressedTexture2D
@export var player_sprite : Sprite2D
@export var scene_to_change : PackedScene
@export var timer_to_change : Timer

@export var starting_life : int
@export var max_stack_overflow : int
@export var max_frame_jump : int

var life : int = 0
var stack_overflow : int = 0
var frame_jump : int = 0

func update_stats_by_enemy(quantity : int, enemy_type : String):
	match(enemy_type):
		"EnemyStackMemory":
			stack_overflow = clamp(stack_overflow + quantity, 0, max_stack_overflow)
		"EnemyJumper":
			frame_jump = clamp(frame_jump + quantity, 0, max_frame_jump)
	GameEvents.on_change_stat.emit(life, stack_overflow, frame_jump)
	
func update_stats_by_use(quantity : int, type : String):
	match(type):
		"StackOverflow":
			stack_overflow = clamp(stack_overflow + quantity, 0, max_stack_overflow)
			player_sprite.texture = stack_overflow_texture
		"FrameJump":
			frame_jump = clamp(frame_jump + quantity, 0, max_frame_jump)
			player_sprite.texture = frame_jump_texture
			
	GameEvents.on_change_stat.emit(life, stack_overflow, frame_jump)
	
func update_life(quantity : int):
	life = clamp(life + quantity, 0, starting_life)
	GameEvents.on_change_stat.emit(life, stack_overflow, frame_jump)
	
	if life == 0:
		GameEvents.play_sound.emit("game_over")
		timer_to_change.start(2)
		#get_tree().reload_current_scene()
		#GameEvents.game_over.emit()

func damage(body : Node2D):
	var enemy = body as Enemy
	if enemy != null:
		player_movement.perform_hit()
		update_life(-1)
		
func change_scene():
	get_tree().change_scene_to_packed(scene_to_change)
	get_tree().unload_current_scene()

func _ready():
	GameEvents.on_scan.connect(update_stats_by_enemy)
	life = starting_life
	
	GameEvents.on_change_stat.emit(life, stack_overflow, frame_jump)
	player_collision.body_entered.connect(Callable(damage))
	timer_to_change.timeout.connect(Callable(change_scene))
