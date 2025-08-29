@icon("res://Resource/Icon/Sword--Streamline-Phosphor.svg")
extends Area2D
class_name AttackComponent

@export var active: bool = false

@export_range(0,1000000,0.1,"hide_slider") var damage: float
@export var knockback: float
@export_enum("player", "monster", "Boss1", "Boss2", "Boss3", "trap_ground") var type_entity: String
@export_group("Crit")
@export var use_crit: bool = false
@export_range(0.1,100,0.1,"hide_slider") var crit_rate: float
@export_range(0,1000,1,"hide_slider") var crit_multiplier: float = 100

func _ready() -> void:
	connect("area_entered", Callable(self,"_on_area_entered"))

func setup(_damage=null,_knockback=null,_use_crit=null,_crit_rate=null,_crit_multiplier=null):
	if _damage != null:
		damage = _damage
	if _knockback != null:
		knockback = _knockback
	if _use_crit != null:
		use_crit = _use_crit
	if _crit_rate != null:
		crit_rate = _crit_rate
	if _crit_multiplier != null:
		crit_multiplier = _crit_multiplier

func _on_area_entered(body: Area2D) -> void:
	print("some thing enter to zore: ",body.get_parent(),body.has_method("damege"))
	if not active:
		return
	if body.has_method("damage") and  body.get_parent() != get_parent():
		print("body has hit damage")
		var attack = Attack.new()
		var crit_dmg = randf() < (crit_rate/100) if use_crit else false
		if crit_dmg:
			var crit_mutiplier_array = [1,2]
			attack.crit_damage = damage * ((crit_multiplier/100) + crit_mutiplier_array.pick_random())
		attack.attack_damage = attack.crit_damage if crit_dmg else damage
		attack.knockback_force = knockback if knockback > 0 else attack.knockback_force
		attack.attack_position = global_position if knockback else attack.attack_position
		attack.crit_rate = crit_rate if crit_dmg else attack.crit_rate
		attack.crit_multiplier = crit_multiplier if crit_dmg else attack.crit_multiplier
		body.damage(attack,type_entity,get_parent())
		print("Base Dmg: ",damage," Crit Dmg: ",attack.crit_damage)
		print("from: ",get_parent(), ' to: ',body.get_parent()," Type: ",type_entity)
