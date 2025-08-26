extends Node2D
class_name HealthComponent

@export var max_health: float = 100.0
var health : float

signal health_changed(current_health: float, max_health:float)
signal died

func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health, max_health)
	
func take_damage(attack: Attack):
	health -= attack.attack_damage
	health = max(health,0)
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		emit_signal("died")
