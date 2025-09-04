# state_machine.gd
# คลาส Finite State Machine ที่ควบคุมการทำงานของสถานะต่างๆ
# ควรเพิ่มคลาสนี้เป็น Node ลูกของตัวละครหลัก (เช่น Player, Enemy)

extends Node
class_name StateMachine

# ตัวแปรสำหรับเก็บตัวละครหลัก (เจ้าของ State Machine)
# จะถูกกำหนดค่าเมื่อเข้าสู่ Scene Tree
var owner_node: Node

# สถานะเริ่มต้นที่กำหนดจาก Inspector
@export var initial_state: State

# สถานะปัจจุบัน
var current_state: State = null

# ตัวแปรสำหรับเก็บข้อมูลที่แต่ละสถานะอาจต้องใช้ เช่น debug text
@export var debug_label: Label = null

func _ready() -> void:
	# เก็บอ้างอิงของเจ้าของ (ตัวละครหลัก)
	owner_node = owner
	
	# เริ่มต้นด้วยสถานะเริ่มต้นที่กำหนดไว้
	if initial_state:
		change_state(initial_state)

func change_state(new_state: State) -> void:
	# ออกจากสถานะเก่าก่อนเปลี่ยน
	if current_state:
		# ยกเลิกการเชื่อมต่อ Signal ของสถานะเก่า
		if current_state.is_connected("request_state_change", Callable(self, "_on_state_change")):
			current_state.disconnect("request_state_change", Callable(self, "_on_state_change"))
		current_state.exit()

	# ตั้งค่าสถานะใหม่
	current_state = new_state
	
	# เข้าสู่สถานะใหม่
	if current_state:
		# เชื่อมต่อ Signal เพื่อรอรับคำขอเปลี่ยนสถานะ
		current_state.connect("request_state_change", Callable(self, "_on_state_change"))
		current_state.enter()
		
# ฟังก์ชันที่ถูกเรียกเมื่อ State ย่อยร้องขอให้เปลี่ยนสถานะ
func _on_state_change(next_state: State) -> void:
	change_state(next_state)

func _physics_process(_delta: float) -> void:
	# เรียกฟังก์ชัน transition ในสถานะปัจจุบัน
	if current_state:
		current_state.transition()
		
		# อัปเดต debug text หากมี
		#if debug_label:
			#debug_label.text = current_state.name
