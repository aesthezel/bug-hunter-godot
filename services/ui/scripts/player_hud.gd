class_name PlayerHUD extends Control

@export var info_text : RichTextLabel

func update_text(health : int, stack_over_flow : int, frame_jump : int):
	var heart : String
	
	for i in range(0, health):
		heart += "♥"
	
	var normal_text = "bughunter.health = [{life}]\nbugHunter.stackOverflow({stack})\nbugHunter.frameJump({jump})"
	var format_text = normal_text.format({"life" : heart, "stack" : stack_over_flow, "jump" : frame_jump})
	
	# format_text += "\nwhile(bugHunter.scanning)" if scanning else " "
	info_text.text = format_text
	
func _ready():
	# on_change_stat(life : int, stack_overflow : int, frame_jump : int)
	GameEvents.on_change_stat.connect(Callable(update_text))
