@icon("res://Resource/Icon/Heartbeat--Streamline-Phosphor.svg")
extends Node2D
class_name HealthComponent

@export var max_health: float = 100.0
var health : float
@export var die_and_hied: bool = false

signal health_changed(current_health: float, max_health:float)
signal died

func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health, max_health)

func setup(_max_health = null,_health = null):
	if _max_health != null:
		max_health	= _max_health
	if _health != null:
		health = max_health
		print(get_tree()," Hp: ",health," Max Hp: ",max_health)
	emit_signal("health_changed", health, max_health)

func take_damage(attack: Attack):
	health -= attack.attack_damage
	health = max(health,0)
	print(get_parent()," Hp: ",health)
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		emit_signal("died")
		if die_and_hied:
			get_parent().queue_free()
