extends Area2D

@export var wall: CollisionObject2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered, disabling wall collision")
		
		# Find the CollisionShape2D child of the wall
		var wall_shape = wall.get_node("CollisionShape2D")
		
		if wall_shape:
			wall_shape.set_deferred("disabled", true)
			
			# Create a one-shot timer to enable the wall after 1 second
			var timer = get_tree().create_timer(1.0, false) # 1.0 = 1 second, false = not repeating
			
			# Connect the timer's timeout signal to a function
			timer.timeout.connect(_on_timer_timeout)
			
	else:
		print("Non-player body entered, enabling wall collision")
		
		var wall_shape = wall.get_node("CollisionShape2D")
		
		if wall_shape:
			wall_shape.set_deferred("disabled", false)

func _on_timer_timeout() -> void:
	print("1 second has passed, enabling wall collision")
	var wall_shape = wall.get_node("CollisionShape2D")
	if wall_shape:
		wall_shape.set_deferred("disabled", false)
