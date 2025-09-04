@icon("res://Resource/Icon/Zone-Person-Urgent--Streamline-Outlined-Material-Symbols.svg")
extends Node2D
class_name DetectionComponent

@export var raycast_forward: RayCast2D
@export var max_range: float = 100.0

func setup(_max_range = null):
	if _max_range != null and typeof(_max_range) == TYPE_FLOAT:
		max_range = _max_range

func _physics_process(_delta: float) -> void:
	pass
