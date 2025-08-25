extends TextureProgressBar

@export var player:Player

func _ready() -> void:
		player.healthChanged.connect(update)
		
func update():
	value = player.currentHealth * 100 / player.maxHealth
