extends State

@export var enemy: Enemy
@export var next_state: State
var idle_timer: Timer
@onready var direction_list = ["Left","Right"]
var direction = null

func enter():
	super.enter()
	var tmp = direction_list.pick_random()
	#print(tmp)
	direction = -1 if tmp == "Left" else 1
	#print(direction)
	enemy.update_facing_direction(tmp)
	idle_timer = Timer.new()
	idle_timer.wait_time = randi_range(2,10)
	idle_timer.timeout.connect(on_timeout)
	idle_timer.autostart = true
	add_child(idle_timer)

func exit():
	super.exit()
	idle_timer.stop()
	idle_timer.timeout.disconnect(on_timeout)
	idle_timer.queue_free()
	idle_timer = null
	direction = null

# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดพฤติกรรมของสถานะ
# เช่น การเคลื่อนที่, การรับ input, การโจมตี
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อทำงานของตัวเอง
func update_state(_delta: float) -> void:
	if not enemy or direction == null:
		return
	else:
		enemy.velocity = Vector2(direction*enemy.move_speed,enemy.velocity.y)
		enemy.move_and_slide()

# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะ
# เช่น ตรวจสอบว่า Animation เล่นจบหรือผู้เล่นกดปุ่ม
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะของตัวเอง
func transition() -> void:
	pass

func on_timeout():
	request_change_to(next_state)
