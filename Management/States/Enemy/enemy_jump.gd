extends State
class_name EnemyJumpState

# --- variables สำหรับ jump movement ---
var jump_direction: Vector2 = Vector2.ZERO
var jumped: bool = false

func enter() -> void:
	super.enter()
	if enemy:
		# กำหนดทิศทางสุ่ม: ซ้ายหรือขวา
		var dir = randi_range(0, 1)  # 0 = ซ้าย, 1 = ขวา
		jump_direction = Vector2(-1, -1) if dir == 0 else Vector2(1, -1)
		
		# เริ่มกระโดด
		enemy.velocity = jump_direction * enemy.jump_force
		jumped = true
	else:
		push_warning("Enemy not assigned in state: " + name)

func update_state(_delta: float) -> void:
	if not enemy:
		return
	
	# เพิ่มแรง gravity ลง velocity.y
	enemy.velocity.y += enemy.gravity * _delta
	
	# อัปเดต position ของ enemy
	enemy.move_and_slide()

func transition() -> void:
	if not enemy or not jumped:
		return
	
	# ถ้าเจอพื้น → จบ jump
	if enemy.is_on_floor():
		jumped = false
		if action_next_state.size() > 0:
			# slot 0 ของ action_next_state = IdleState
			request_change_to(action_next_state[0])
