extends CharacterBody2D
class_name Player
# --------- VARIABLES ---------- #
@export_category("Player Component")
@export var health_component: HealthComponent
@export var hit_component: HitComponent
@export_group("Attack")
@export var attack_component: AttackComponent
@export var attack_collision: CollisionShape2D

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 350
@export var jump_force : float = 600
@export var gravity : float = 25
@export var max_jump_count : int = 2
var jump_count : int = 2
@export var combo_time: float = 1.0
@onready var combo_timer: Timer = $Combo_Timer

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false

var is_grounded : bool = false
var direction : String = "left"
var is_attacking = false
var buttons_pressed: String = ""
#@onready var spawn_point = %SpawnPoint
# --------- BUILT-IN FUNCTIONS ---------- #
func _ready() -> void:
	health_component.died.connect(death_tween)
	#health_component.health_changed.connect(hp_now)
	if attack_component:
		attack_collision.visible = false
	combo_timer.wait_time = combo_time
	combo_timer.one_shot = true
	combo_timer.timeout.connect(_on_combo_timer_timeout)

func _process(_delta):
	# Calling functions
	movement()
	player_animations()
	flip_player()
	#hp_now()
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	# Move Player
	var inputAxis = Input.get_axis("Move_Left", "Move_Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1
		
# Player jump
func jump():
	jump_tween()
	#AudioManager.jump_sfx.play()
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	if is_attacking:
		return  # อย่า override animation ตอนกำลัง attack
	if is_on_floor():
		if abs(velocity.x) > 0:
			$AnimatedSprite2D.play("Run",1)
		else:
			$AnimatedSprite2D.play("Idle",1)
			
	else:
		if $AnimatedSprite2D.animation != "Jump":
			$AnimatedSprite2D.play("Jump",1,2)
			$AnimatedSprite2D.frame = 0
			if await $AnimatedSprite2D.animation_finished == null:
				$AnimatedSprite2D.pause()
				
# Flip player sprite based on X velocity
func flip_player():
	#if velocity.x < 0 and $character2D.scale.x < 0:
		#$character2D.scale.x *= -1
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		if $AnimatedSprite2D.flip_h and direction != 'right':
			direction = 'right'
			if attack_collision:
				attack_collision.position.x *= (-1)
	#elif velocity.x > 0 and $character2D.scale.x > 0:
		#$character2D.scale.x *= -1
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		if not $AnimatedSprite2D.flip_h and direction != "left":
			direction = 'left'
			if attack_collision:
				attack_collision.position.x *= (-1)

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	#global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	health_component.health = health_component.max_health

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
#func hp_now():
	#print(health_component.health)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		buttons_pressed += "attack"
		start_attack()
		combo_timer.stop()
	
func start_attack():
	if "attack" in buttons_pressed:
		if abs(velocity.x) > 0:
			is_attacking = true
			$AnimatedSprite2D.play("Run+Attack")
			attack_collision.visible = true
			attack_component.active = true
			$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_attack_finished"))
		else:
			#print(buttons_pressed)
			#print(buttons_pressed.split("attack"))
			#print(len(buttons_pressed.split("attack")))
			#print((len(buttons_pressed.split("attack")) % 3) + 1)
			is_attacking = true
			var mame_combo = "Attack"+ str((len(buttons_pressed.split('attack')) % 3 if buttons_pressed != 'attack' else 0)+1)
			#print(mame_combo)
			$AnimatedSprite2D.play(mame_combo,1)
			attack_collision.visible = true
			attack_component.active = true
			$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_attack_finished"))
			
			
func _on_attack_finished():
	attack_collision.visible = false
	attack_component.active = false
	is_attacking = false
	combo_timer.start()
	print("stop atk")


func _on_hit_component_hit_knockback(attack:Attack) -> void:
	print("Knight give Value Dmg: ",attack.attack_damage,' knockback_force: ', attack.knockback_force,' attack_position: ', attack.attack_position)

func _on_combo_timer_timeout():
	buttons_pressed = ''
	#print("reset combo")
