# enemy.gd
# คลาสหลักของศัตรู
# ทำหน้าที่จัดการส่วนประกอบพื้นฐานทั้งหมดและเป็นเจ้าของ State Machine

extends CharacterBody2D
class_name Enemy

@export_category("Setup Component")
@export var health_component: HealthComponent
@export var hit_component: HitComponent
@export var attack_component: AttackComponent
@export var attack_collision: CollisionShape2D
@export var detection_component: DetectionComponent
@export var state_machine: StateMachine
@export var dead_state: State
# เพิ่มตัวแปรสำหรับ Node ที่เก็บ Sprite/AnimationPlayer
@export var animation_control: Node2D

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
@export_enum("Left","Right") var direction: String

func _ready() -> void:
	# Set up components
	if health_component:
		health_component.setup(hp,"use_max_health")
		health_component.died.connect(_on_died)
	#if attack_collision:
		#attack_collision.disabled = true
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
	# Basic physics for the enemy
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
func _on_died():
	# When the enemy dies, tell the State Machine to change to the 'dead' state
	if state_machine and dead_state:
		state_machine.change_state(dead_state)

# ฟังก์ชันนี้จะถูกเรียกใช้โดยแต่ละ State เพื่อควบคุมทิศทางการหันหน้า
func update_facing_direction(new_direction: String):
	if new_direction.to_lower() == "right":
		# พลิกตัวไปทางขวาโดยใช้ scale
		if animation_control:
			animation_control.scale.x = 1
		if direction != "Right":
			direction = "Right"
			if attack_component:
				attack_component.scale.x = 1
			if detection_component:
				detection_component.scale.x = 1
	elif new_direction.to_lower() == "left":
		# พลิกตัวไปทางซ้ายโดยใช้ scale
		if animation_control:
			animation_control.scale.x = -1
		if direction != "Left":
			direction = "Left"
			if attack_component:
				attack_component.scale.x = -1
			if detection_component:
				detection_component.scale.x = -1
