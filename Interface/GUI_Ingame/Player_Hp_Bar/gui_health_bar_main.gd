extends CanvasLayer

@export var health_component: HealthComponent
@export var health_bar: TextureProgressBar
@export var health_linear_bar: TextureProgressBar

var health: int = 0 : set = _set_health

func _ready() -> void:
	if health_component:
		_init_health(health_component.max_health)
		health_component.health_changed.connect(_on_health)

func _init_health(_health):
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	health_linear_bar.init_health(_health)

func _set_health(new_health):
	health = min(health_bar.max_value, new_health)
	health_bar.value = health
	health_linear_bar.health = health
	
	#if health <= 0:
		#reset_health()

func _on_health(current_health: float, max_health: float):
	_set_health(current_health)
	health_bar.max_value = max_health
	health_linear_bar.max_value = max_health

func reset_health():
	if health_component:
		_init_health(health_component.max_health)
		#visible = true
