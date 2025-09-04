extends State

@export var enemy: Enemy
@export var detection_component: DetectionComponent
@export var min_range_atk: float = 50
@export var max_range_atk: float = 500
@export var atk_state: State
@export var normal_state: State
var distance = null
var direction = null
var found_player = null

func enter():
	super.enter()
	direction = (player.global_position - enemy.global_position).normalized()
	var player_now = player
	
func exit():
	super.exit()
	distance = null
	direction = null
	found_player = null
# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดพฤติกรรมของสถานะ
# เช่น การเคลื่อนที่, การรับ input, การโจมตี
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อทำงานของตัวเอง
func update_state(_delta: float) -> void:
	if enemy and direction == null:
		return
	if detection_component.raycast_forward.is_colliding():
		var collider = detection_component.raycast_forward.get_collider()
		if collider == player:
			found_player = true
			direction = (player.global_position - enemy.global_position).normalized()
			#print(1 if direction.x > 0 else -1)
			enemy.velocity = Vector2((1 if direction.x > 0 else -1)*enemy.move_speed *1.5, enemy.velocity.y)
			enemy.move_and_slide()
			direction = (player.global_position.x - enemy.global_position.x)
			#print(abs(direction)," And ",min_range_atk)
			if abs(direction) < min_range_atk:
				#print("Can atk")
				request_change_to(atk_state)
		else:
			found_player = false
			#print("Not player")
			request_change_to(normal_state)
		
	#if enemy.velocity.x < 0:
		#enemy.update_facing_direction("Left")
	#else:
		#enemy.update_facing_direction("Right")
	
	if enemy.is_on_wall():
		if enemy.direction == "Left":
			enemy.update_facing_direction("Right")
		else:
			enemy.update_facing_direction("Left")
# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะ
# เช่น ตรวจสอบว่า Animation เล่นจบหรือผู้เล่นกดปุ่ม
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะของตัวเอง
func transition():
	pass
