class_name CameraSystem extends Node2D

@export var camera : Camera2D
@export var target : Node2D
@export var follow_speed : float = 300.0
@export var mass : float = 3.0

var _velocity : Vector2 = Vector2.ZERO
var _anchor_position : Vector2 = Vector2.ZERO

const SLOW_RADIUS : float = 300.0

func move_camera_to_target(delta):
	var camera_position = camera.position
	var target_position = target.position
	
	var distance_to_target = camera_position.distance_to(target_position)
	var desired_velocity = (target_position - camera_position).normalized() * follow_speed
	
	if distance_to_target < SLOW_RADIUS:
		desired_velocity *= (distance_to_target / (SLOW_RADIUS))
	
	_velocity += (desired_velocity - _velocity) / mass
	camera.position += _velocity * delta 

func _physics_process(delta):
	move_camera_to_target(delta)
