extends Area2D
class_name HitComponent

@export var health_component: HealthComponent
@export var knockback: bool = false
signal hit_knockback(knockback_force, attack_position)

func damege(attack: Attack,type_entity):
	if health_component:
		health_component.take_damage(attack)
		if knockback and type_entity != null:
			if type_entity == "trap_ground":
				get_parent().velocity = (get_parent().global_position - attack.attack_position).normalized()*attack.knockback_force
			hit_knockback.emit(attack)
