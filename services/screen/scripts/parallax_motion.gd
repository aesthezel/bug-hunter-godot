extends TextureRect

@export var scroll_speed_x : float
@export var scroll_speed_y : float

# Called when the node enters the scene tree for the first time.
func _ready():
	(material as ShaderMaterial).set_shader_parameter("scroll_speed_x", scroll_speed_x)
	(material as ShaderMaterial).set_shader_parameter("scroll_speed_y", scroll_speed_y)
