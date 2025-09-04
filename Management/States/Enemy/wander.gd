extends State

@export var enemy: Enemy
@export var detection_component: DetectionComponent
@export var next_state: State
@export var chase_state: State
var idle_timer: Timer
@onready var direction_list = ["Left","Right"]
var direction = null
var tmp = null

func enter():
	super.enter()
	tmp = direction_list.pick_random()
	direction = -1 if tmp == "Left" else 1
	enemy.update_facing_direction(tmp)

	# Timer สำหรับเปลี่ยน state
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
	tmp = null

func update_state(_delta: float) -> void:
	if not enemy or direction == null:
		return
	enemy.velocity = Vector2(direction*enemy.move_speed, enemy.velocity.y)
	enemy.move_and_slide()

func transition() -> void:
	if enemy.is_on_wall():
		if tmp == "Left":
			tmp = "Right"
			direction = -1 if tmp == "Left" else 1
			enemy.update_facing_direction(tmp)
			enemy.velocity = Vector2(direction*enemy.move_speed, enemy.velocity.y)
		elif tmp == 'Right':
			tmp = "Left"
			direction = -1 if tmp == "Left" else 1
			enemy.update_facing_direction(tmp)
			enemy.velocity = Vector2(direction*enemy.move_speed, enemy.velocity.y)
	if detection_component.raycast_forward.is_colliding():
		var collider = detection_component.raycast_forward.get_collider()
		if collider == player:
			#print("Wander to Chase")
			request_change_to(chase_state)

func on_timeout():
	print("Walk timeout → Idle")
	request_change_to(next_state)
