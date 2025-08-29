extends TextureProgressBar

@export var health_component: HealthComponent
@export var damage_bar: TextureProgressBar
@export var timer: Timer
@export var closer_outline: bool = false
@export var die_hide_bar: bool = false

var health: float = 0.0: set = _set_health

func _ready() -> void:
	if closer_outline:
		tint_over.a = 0
	if health_component:
		init_health(health_component.max_health)
		health_component.health_changed.connect(init_health_with_health_component)

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0 and die_hide_bar:
		queue_free()
	if health < prev_health:
		timer.start()
		
	else:
		damage_bar.value = health
	
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func init_health_with_health_component(_health, _max_health):
	health = _health
	max_value = _max_health
	value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
