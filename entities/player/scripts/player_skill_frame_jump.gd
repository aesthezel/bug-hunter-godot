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

@export var ray_type : FrameJumpType
@export var player_transform : Node2D
@export var player_collider : CollisionShape2D
@export var ray_distance : float = 50.0
@export var min_possible_distance : float = 7

var ray_direction : FrameJumpDirection = FrameJumpDirection.POSITIVE

var canCross : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player_transform.global_scale)

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
	canCross = true
	
	var possible_direction = get_ray_direction()
	if possible_direction != FrameJumpDirection.NEUTRAL:
		ray_direction = possible_direction
	
	target_position = Vector2(ray_distance * ray_direction, 0.0)
	
	var finalRayDistance = ray_distance
	
	if is_colliding():
		var collisionPosition = get_collision_point()
		var distanceCollision = collisionPosition - player_collider.global_position
		finalRayDistance = abs(distanceCollision.x - ray_distance)
		
		if finalRayDistance < min_possible_distance:
			canCross = false
		else:
			canCross = true
		
	if Input.is_action_just_pressed("dash") and canCross:
		if ray_type == FrameJumpType.HORIZONTAL and Input.get_axis("move_left", "move_right") != 0:
			player_transform.position.x += finalRayDistance * ray_direction
		elif ray_type == FrameJumpType.VERTICAL and Input.get_axis("move_down", "move_up") != 0:
			player_transform.position.y += finalRayDistance * ray_direction
