extends State

@export var enemy: Enemy
@export var detection_component: DetectionComponent
@export var min_range_atk: float = 50
@export var max_range_atk: float = 500
@export var atk_state: State
@export var normal_state: State

var direction: Vector2 = Vector2.ZERO
var found_player: bool = false
var jump_cooldown: float = 0.0
@export var jump_interval: float = 1.0  # เวลาระหว่างกระโดด

func enter() -> void:
	super.enter()
	jump_cooldown = 0.0
	if player and enemy:
		direction = (player.global_position - enemy.global_position).normalized()

func exit() -> void:
	super.exit()
	direction = Vector2.ZERO
	found_player = false

func update_state(delta: float) -> void:
	if not enemy or not player:
		return
	print("now in chase state")
	# คำนวณทิศทาง player ทุก frame
	direction = (player.global_position - enemy.global_position).normalized()

	# หันหน้าไปทาง player
	if direction.x < 0:
		enemy.update_facing_direction("Left")
	else:
		enemy.update_facing_direction("Right")

	# ไล่ player ด้วยการกระโดด
	jump_cooldown -= delta
	if enemy.is_on_floor() and jump_cooldown <= 0.0:
		enemy.velocity.x = direction.x * enemy.move_speed
		enemy.velocity.y = -enemy.jump_force
		jump_cooldown = jump_interval

	# ให้ gravity ทำงาน
	enemy.velocity.y += enemy.gravity * delta

	enemy.move_and_slide()

	# เช็คระยะเพื่อโจมตี
	var dist_x = abs(player.global_position.x - enemy.global_position.x)
	if dist_x < min_range_atk:
		if enemy.has_method("attack"):
			enemy.attack()
		elif atk_state:
			request_change_to(atk_state)

func transition() -> void:
	pass
