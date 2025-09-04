extends State
@export var enemy: Enemy
@export var detection_component: DetectionComponent
@export var chase_state: State
@export var next_state: State
var direction := 1 # ซ้าย(-1) ขวา(1)
var gravity := 200
var jump_force := -100
var jump_interval := 1.5 # วินาทีกระโดดครั้งนึง
var jump_timer := 0.0
var tmp = null


func enter():
	super.enter()
	jump_timer = jump_interval
	if animation_sprite:
		animation_sprite.animation_finished.connect(on_finished)
	if animation_player:
		pass

func exit():
	super.exit()

func update_state(delta: float) -> void:
	if not enemy:
		return
	
	# ใช้ gravity
	enemy.velocity.y += gravity * delta

	# นับเวลาเพื่อกระโดด
	jump_timer -= delta
	if jump_timer <= 0.0 and enemy.is_on_floor():
		enemy.velocity.y = jump_force
		enemy.velocity.x = direction * enemy.move_speed - 200
		jump_timer = jump_interval
	
	enemy.move_and_slide()

func transition() -> void:
	if enemy.is_on_wall():
		if tmp == "Left":
			tmp = "Right"
			direction = -1 if tmp == "Left" else 1
			enemy.update_facing_direction(tmp)
			enemy.velocity = Vector2(direction*enemy.move_speed, enemy.velocity.y)
		elif tmp == 'Right':
			tmp = "Left"
			direction = -1 if tmp == "Left" else 1
			enemy.update_facing_direction(tmp)
			enemy.velocity = Vector2(direction*enemy.move_speed, enemy.velocity.y)
	if detection_component and detection_component.raycast_forward:
		if detection_component.raycast_forward.is_colliding():
			var collider = detection_component.raycast_forward.get_collider()
			if collider == player:
				request_change_to(chase_state)
func on_finished():
	request_change_to(next_state)
