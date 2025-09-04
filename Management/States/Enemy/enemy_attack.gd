extends State

@export var enemy: Enemy
@export var detection_component: DetectionComponent
@export var min_range_atk:float = 50
@export var attack_component: AttackComponent
@export var attack_collision: CollisionShape2D
@export var chase_state: State
@export var atk_state: State
var distance = null
var is_attacking: bool = false

func enter():
	if animation_sprite:
		animation_sprite.connect("animation_finished", Callable(self, "_on_attack_finished"))
	if animation_player:
		animation_player.connect("animation_finished", Callable(self, "_on_attack_finished"))
	super.enter()
	is_attacking = true
	attack_component.active = true
	attack_collision.disabled = false

func exit():
	super.exit()
	
func update_state(_delta: float) -> void:
	if detection_component.raycast_forward.is_colliding():
		var collier = detection_component.raycast_forward.get_collider()
		if collier == player:
			distance = (player.global_position.x - enemy.global_position.x)
			if distance > min_range_atk:
				request_change_to(chase_state)
			else:
				is_attacking = true
				_play_animation()
				attack_component.active = true
				attack_collision.disabled = false
	else:
		request_change_to(chase_state)

func transition() -> void:
	pass

func _on_attack_finished():
	if is_attacking:
		print(is_attacking)
		attack_component.active = false
		is_attacking = false
		attack_collision.disabled = true
