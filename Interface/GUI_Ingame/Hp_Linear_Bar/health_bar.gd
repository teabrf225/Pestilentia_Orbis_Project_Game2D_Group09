@icon("res://Resource/Icon/Online-Medical-Service-Monitor--Streamline-Core-Remix.svg")
extends ProgressBar
class_name HealthBar

@export var health_component: HealthComponent
@export var damage_bar: ProgressBar
@export var timer: Timer

var setup_now = false
var health: float = 0: set = _set_health

func _ready() -> void:
	visible = false
	if health_component:
		max_value = health_component.max_health
		_init_health(health_component.health)
		health_component.health_changed.connect(init_health_with_health_component)

func _init_health(_health):
	#print(get_parent()," Set up def Hp: ",_health)
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	if health < max_value:
		visible = true
	
	if health <= 0:
		queue_free()
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health_with_health_component(_health, _max_health):
	if health_component.max_health > health and not setup_now:
		max_value = health_component.max_health
		_init_health(health_component.health)
		setup_now = true
		print("setup HP now",get_parent(),' Hp: ', health, ' Max Hp: ',max_value)
	health = health_component.health

func _on_timer_timeout() -> void:
	damage_bar.value = health
