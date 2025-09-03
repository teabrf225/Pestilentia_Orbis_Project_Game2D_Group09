@icon("res://Resource/Icon/Zone-Person-Urgent--Streamline-Outlined-Material-Symbols.svg")
extends Node2D
class_name DetectionComponent

@export var active: bool = true
@export_category("Vision")
@export_group("Forward")
@export var forward: RayCast2D
@export var forward_up: RayCast2D
@export var forward_down: RayCast2D

@export_group("Vision Range")
@export var max_range: float

@onready var range_vision_forward = forward.target_position.x
@onready var range_vision_forward_up = forward_up.target_position
@onready var range_vision_forward_down = forward_down.target_position

signal player_detected(location,object_direction,direction)
signal player_out_of_range

func setup(_max_range = null):
	if _max_range != null and typeof(_max_range) == TYPE_FLOAT:
		max_range = _max_range

func _physics_process(_delta: float) -> void:
	if forward.is_colliding() or forward_up.is_colliding() or forward_down.is_colliding():
		var forward_collider = forward.get_collider()
		if forward_collider is Player:
			var location = forward.get_collision_point()
			var direction = forward.get_collision_normal()
			forward.target_position = to_local(forward_collider.position)
			if abs(forward.target_position.x-forward.position.x) > max_range:
				#print("out of range",abs(forward.target_position.x-forward.position.x))
				forward.target_position = Vector2(range_vision_forward,0)
				forward_up.target_position = Vector2(range_vision_forward_up)
				forward_down.target_position = Vector2(range_vision_forward_down)
				emit_signal("player_out_of_range")
			else:
				var move_direction = Vector2(sign(-direction.x), 0)
				emit_signal("player_detected", location, direction, move_direction)
				#print("See ",forward.get_collider().get_class()," In location: ", location," Object Direction ",direction," Direction: ",move_direction)
