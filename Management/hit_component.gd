extends Area2D
class_name HitComponent

@export var health_component: HealthComponent

func damege(attack: Attack):
	if health_component:
		health_component.damage(attack)
