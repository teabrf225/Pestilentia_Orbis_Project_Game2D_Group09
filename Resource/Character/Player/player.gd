extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 350
@export var jump_force : float = 600
@export var gravity : float = 10
@export var max_jump_count : int = 2
var jump_count : int = 2

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false

var is_grounded : bool = false
#@onready var player_sprite = $Player1
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles

# --------- BUILT-IN FUNCTIONS ---------- #

func _process(_delta):
	# Calling functions
	movement()
	player_animations()
	flip_player()
	
	#if GameManager.hp <= 0:
		#GameManager.hp = 30
		#AudioManager.death_sfx.play()
		#death_particles.emitting = true
		#death_tween()
	
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
	#particle_trails.emitting = false

	if is_on_floor():
		if abs(velocity.x) > 0:
			#particle_trails.emitting = true
			$AnimatedSprite2D.play("Run",1)
		else:
			$AnimatedSprite2D.play("Idle",1)
			
	else:
		if $AnimatedSprite2D.animation != "Jump":
			#print("Before Frame ",$AnimatedSprite2D.frame)
			$AnimatedSprite2D.play("Jump",1,2)
			$AnimatedSprite2D.frame = 0
			if await $AnimatedSprite2D.animation_finished == null:
				#print("After Frame ",$AnimatedSprite2D.frame)
				$AnimatedSprite2D.pause()
				
# Flip player sprite based on X velocity
func flip_player():
	#if velocity.x < 0 and $character2D.scale.x < 0:
		#$character2D.scale.x *= -1
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	#elif velocity.x > 0 and $character2D.scale.x > 0:
		#$character2D.scale.x *= -1
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
#func _on_collision_body_entered(_body):
	#if _body.is_in_group("Traps"):
		#GameManager.damage(10)
