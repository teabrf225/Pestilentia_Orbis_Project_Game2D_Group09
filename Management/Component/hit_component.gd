@icon("res://Resource/Icon/Bounding-Box--Streamline-Phosphor.svg")
extends Area2D
class_name HitComponent

@export var health_component: HealthComponent
@export var knockback: bool = false
signal hit_knockback(attack)
signal on_hurt

func setup(_use_knocback: bool=false):
	if _use_knocback:
		knockback = _use_knocback

func damage(attack: Attack,_type_entity,_from):
	print("Hit!!!")
	if health_component:
		health_component.take_damage(attack)
		on_hurt.emit()
		if knockback and _type_entity != null:
			if _type_entity == "trap_ground":
				get_parent().velocity = (get_parent().global_position - attack.attack_position).normalized()*attack.knockback_force
			hit_knockback.emit(attack)
	print("from: ",_from, ' to ',get_parent(), ' Dmg: ',attack.attack_damage)
