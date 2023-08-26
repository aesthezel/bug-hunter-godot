class_name SkillFrameJump extends RayCast2D

enum FrameJumpType {
	HORIZONTAL,
	VERTICAL
}

enum FrameJumpDirection {
	POSITIVE = 1,
	NEGATIVE = -1,
	NEUTRAL = 0
}

@export var player_system : PlayerSystem
@export var ray_type : FrameJumpType
@export var player_transform : Node2D
@export var player_collider : CollisionShape2D
@export var ray_distance : float = 50.0
@export var min_possible_distance : float = 7
@export var frame_jump_timer : Timer
@export var can_use_time : float

var ray_direction : FrameJumpDirection = FrameJumpDirection.POSITIVE

var can_cross : bool
var can_use : bool

func reset_can_use():
	can_use = true

# Called when the node enters the scene tree for the first time.
func _ready():
	can_use = true
	frame_jump_timer.timeout.connect(reset_can_use)

func get_ray_direction() -> FrameJumpDirection:
	if ray_type == FrameJumpType.HORIZONTAL:
		var horizontal_direction = Input.get_axis("move_left", "move_right")
		if horizontal_direction:
			return FrameJumpDirection.NEGATIVE if horizontal_direction < 0 else FrameJumpDirection.POSITIVE
	
	if ray_type == FrameJumpType.VERTICAL:
		var vertical_direction = Input.get_axis("move_up", "move_down")
		if vertical_direction:
			return FrameJumpDirection.NEGATIVE if vertical_direction < 0 else FrameJumpDirection.POSITIVE
		
	return FrameJumpDirection.NEUTRAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	can_cross = true
	
	var possible_direction = get_ray_direction()
	if possible_direction != FrameJumpDirection.NEUTRAL:
		ray_direction = possible_direction
	
	target_position = Vector2(ray_distance * ray_direction, 0.0)
	
	var final_ray_distance = ray_distance
	
	if is_colliding():
		var collisionPosition = get_collision_point()
		var distanceCollision = collisionPosition - player_collider.global_position
		final_ray_distance = abs(distanceCollision.x - ray_distance)
		
		if final_ray_distance < min_possible_distance:
			can_cross = false
		else:
			can_cross = true
	
	if !can_use:
		return
	
	if player_system.frame_jump == 0:
		return
		
	if Input.is_action_just_pressed("skill_two") and can_cross:
		if ray_type == FrameJumpType.HORIZONTAL and Input.get_axis("move_left", "move_right") != 0:
			player_transform.position.x += final_ray_distance * ray_direction
		elif ray_type == FrameJumpType.VERTICAL and Input.get_axis("move_down", "move_up") != 0:
			player_transform.position.y += final_ray_distance * ray_direction
		
		can_use = false
		frame_jump_timer.start(can_use_time)
		player_system.update_stats_by_use(-1, "FrameJump")
