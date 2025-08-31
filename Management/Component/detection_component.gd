@icon("res://Resource/Icon/Zone-Person-Urgent--Streamline-Outlined-Material-Symbols.svg")
extends Node
class_name DetectionComponent

@export var active: bool = true
@export var forward_vision: RayCast2D


func _process(delta: float) -> void:
	var test = forward_vision.is_colliding()
	print(test)
