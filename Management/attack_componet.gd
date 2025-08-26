extends Area2D
class_name AttackComponent

@export var active: bool = false

@export_range(0,1000,0.1,"hide_slider") var damage: float
@export_range(0,1000,1) var knockback: int
@export_enum("player", "monster", "Boss1", "Boss2", "Boss3", "trap_ground") var type_entity: String
@export_group("Crit")
@export var use_crit: bool = false
@export_range(0.1,100,0.1,"hide_slider") var crit_rate: float
@export_range(0,1000,1,"hide_slider") var crit_multiplier: float = 100

func _ready() -> void:
	connect("area_entered", Callable(self,"_on_area_entered"))
	
func _on_area_entered(body: HitComponent) -> void:
	if not active:
		return
	if body is HitComponent or body.has_method("damege"):
		var attack = Attack.new()
		var crit_dmg = randf() < (crit_rate/100) if use_crit else false
		if crit_dmg:
			damage *= crit_multiplier
		attack.attack_damage = damage
		attack.knockback_force = knockback if knockback > 0 else attack.knockback_force
		attack.attack_position = global_position if knockback else attack.attack_position
		attack.crit_rate = crit_rate
		attack.crit_multiplier = crit_multiplier
		body.damege(attack,type_entity)
		print("from: ",get_parent(), ' to: ',body.get_parent()," Type: ",type_entity)
