extends State

func enter():
	super.enter()
	
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
