extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State = null

func _ready() -> void:
	# เริ่มที่ initial_state
	if initial_state:
		change_state(initial_state)

func change_state(new_state: State) -> void:
	# ออกจาก state เก่า
	if current_state:
		current_state.exit()
		if current_state.is_connected("request_state_change", Callable(self, "_on_state_change")):
			current_state.disconnect("request_state_change", Callable(self, "_on_state_change"))

	# ตั้ง state ใหม่
	current_state = new_state
	if current_state:
		current_state.enter()
		current_state.connect("request_state_change", Callable(self, "_on_state_change"))

func _process(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)

func _on_state_change(next_state: State) -> void:
	change_state(next_state)
