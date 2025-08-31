extends CharacterBody2D
class_name Enemy

@export_category("Setup Component")
@export var health_component: HealthComponent
@export var hit_component: HitComponent
@export var attack_component: AttackComponent
@export var attack_collision: CollisionShape2D
@export var detection_component: DetectionComponent

@export_category("Properties")
@export_group("Value setting")
@export_range(0,1000000,0.1,"hide_slider") var hp: float = 1
@export_subgroup("attack")
@export_range(0,1000000,0.1,"hide_slider") var dmg: float = 1
@export var use_knockback: bool = false
@export var knockback_force: float = 0
@export_subgroup("crit")
@export var use_crit: bool = false
@export_range(0,1000000,0.1,"hide_slider") var crit_rate: float = 1
@export_range(0,1000000,0.1,"hide_slider") var crit_dmg: float = 50
@export_group("Other setting")
@export var move_speed : float = 350
@export var jump_force : float = 600
@export var gravity : float = 25
@export var max_vision: float

var direction : String = "left"

func _ready() -> void:
	if health_component:
		health_component.setup(hp,"use_max_health")
	if attack_collision:
		attack_collision.disabled = true
	if attack_component:
		attack_component.setup(dmg)
		if use_crit:
			attack_component.setup(null,null,use_crit,crit_rate,crit_dmg)
		if use_knockback:
			if hit_component:
				hit_component.setup(use_knockback)
			attack_component.setup(null,knockback_force)
	if detection_component:
		detection_component.setup(max_vision)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	_update_flip()

func _update_flip():
	if velocity.x > 0:
		# หันขวา
		$AnimatedSprite2D.flip_h = true
		if direction != "right":
			direction = "right"
			if attack_collision:
				attack_component.scale.x *= -1
				detection_component.scale.x *= -1
	elif velocity.x < 0:
		# หันซ้าย
		$AnimatedSprite2D.flip_h = false
		if direction != "left":
			direction = "left"
			if attack_collision:
				attack_component.scale.x *= -1
				detection_component.scale.x *= -1
