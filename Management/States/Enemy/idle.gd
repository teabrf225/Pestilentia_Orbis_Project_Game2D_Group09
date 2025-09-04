extends State

@export var enemy: Enemy
@export var next_state: State   # อันนี้คือ state หลัง idle timer หมด
@export var chase_state: State  # เพิ่มตัวแปร ChaseState
var idle_timer: Timer

func enter():
	super.enter()
	enemy.velocity = Vector2.ZERO

	# ตั้ง timer
	idle_timer = Timer.new()
	idle_timer.wait_time = randi_range(3,10)
	idle_timer.timeout.connect(on_timeout)
	idle_timer.autostart = true
	add_child(idle_timer)

func exit():
	super.exit()
	idle_timer.stop()
	idle_timer.timeout.disconnect(on_timeout)
	idle_timer.queue_free()
	idle_timer = null

func update_state(_delta: float) -> void:
	pass

func transition() -> void:
	pass

func on_timeout():
	print("Idle timeout → Walk")
	request_change_to(next_state)
