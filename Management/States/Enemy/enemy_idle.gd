extends State
class_name EnemyIdleState

var idle_timer: Timer

func enter() -> void:
	super.enter()
	if enemy:
		enemy.velocity = Vector2.ZERO
		_start_idle_timer()
	else:
		push_warning("Enemy not assigned in state: " + name)

func exit() -> void:
	if idle_timer and idle_timer.is_inside_tree():
		idle_timer.queue_free()

func update_state(_delta: float) -> void:
	pass

func transition() -> void:
	pass

func _start_idle_timer() -> void:
	idle_timer = Timer.new()
	idle_timer.wait_time = randi_range(1, 3)
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_idle_timeout)
	add_child(idle_timer)
	idle_timer.start()

func _on_idle_timeout() -> void:
	if action_next_state.size() == 0:
		push_warning("No next state assigned for " + name)
		return

	var roll = randi_range(0, 100)
	if roll < 50:
		# ยืน idle ต่อ
		request_change_to(action_next_state[0]) 
	else:
		# เดินไปยัง state ต่อไป
		if action_next_state.size() > 1:
			request_change_to(action_next_state[1])
