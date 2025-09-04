extends State

@export var enemy : Enemy
@export var health : HealthComponent
@export var next_state : State


func enter():
	#health.health_changed.connect(on_hurt)
	super.enter()
	if animation_sprite:
		await get_tree().create_timer(1).timeout
		print("Hurt back to idle")
		request_change_to(next_state)
	print("Enterrrr")
func exit():
	super.exit()

# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดพฤติกรรมของสถานะ
# เช่น การเคลื่อนที่, การรับ input, การโจมตี
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อทำงานของตัวเอง
func update_state(_delta: float) -> void:
	pass

# ฟังก์ชันที่ให้ Inherit เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะ
# เช่น ตรวจสอบว่า Animation เล่นจบหรือผู้เล่นกดปุ่ม
# ทุกสถานะย่อยต้อง Override (เขียนโค้ดทับ) ฟังก์ชันนี้เพื่อกำหนดเงื่อนไขการเปลี่ยนสถานะของตัวเอง
func transition() -> void:
	pass
