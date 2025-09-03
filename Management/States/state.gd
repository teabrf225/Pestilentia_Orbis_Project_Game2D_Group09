# state.gd
# คลาสแม่แบบสำหรับทุกสถานะ (State) ใน Finite State Machine
# คลาสนี้เป็นเพียงพื้นฐานและไม่ควรมีโค้ดที่เจาะจงกับตัวละครใดๆ
# ทุกสถานะที่ต้องการสร้าง ควร Inherit หรือสืบทอดจากคลาสนี้

extends Node
class_name State

# สัญญาณ (Signal) เพื่อบอก State Machine ให้เปลี่ยนสถานะ
# นี่เป็นวิธีที่ทำให้แต่ละสถานะไม่ต้องรู้จัก State Machine โดยตรง
signal request_state_change(new_state: State)

# ข้อมูลสำหรับเล่น Animation
# ตัวแปรเหล่านี้จะถูกกำหนดค่าจาก State Machine หรือตัวละครหลัก
@export var name_animation: String = ""
@export var animation_player: AnimationPlayer
@export var animation_sprite: AnimatedSprite2D


# ฟังก์ชันหลักที่ถูกเรียกเมื่อเข้าสู่สถานะ
# ใช้สำหรับตั้งค่าเริ่มต้นของสถานะ เช่น เริ่ม Animation หรือเปิดการทำงานของ _physics_process
func enter():
	# เปิดการทำงานของ _physics_process เมื่อเข้าสู่สถานะ
	set_physics_process(true)
	_play_animation()
	print(name + ": เข้าสู่สถานะ")

# ฟังก์ชันหลักที่ถูกเรียกเมื่อออกจากสถานะ
# ใช้สำหรับล้างค่าหรือปิดการทำงานของสถานะ
func exit():
	# ปิดการทำงานของ _physics_process เมื่อออกจากสถานะ
	set_physics_process(false)
	print(name + ": ออกจากสถานะ")

# ฟังก์ชันที่ทำงานทุกเฟรมสำหรับ Physics
# ใช้เรียกฟังก์ชันย่อยที่จัดการพฤติกรรมและการเปลี่ยนสถานะ
func _physics_process(delta: float) -> void: 
	update_state(delta) # อัปเดตพฤติกรรมของสถานะ
	transition() # ตรวจสอบเงื่อนไขการเปลี่ยนสถานะ

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

# ฟังก์ชันสำหรับส่งสัญญาณไปยัง State Machine เพื่อขอเปลี่ยนสถานะ
func request_change_to(new_state: State) -> void:
	emit_signal("request_state_change", new_state)

# ฟังก์ชันสำหรับเล่น Animation ที่ถูกกำหนดไว้
func _play_animation():
	if name_animation == "":
		return
	if animation_player and animation_player.has_animation(name_animation):
		animation_player.play(name_animation)
	elif animation_sprite and animation_sprite.sprite_frames.has_animation(name_animation):
		animation_sprite.play(name_animation)
